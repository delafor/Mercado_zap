import { createPixQrCode, getPixStatus } from '../../lib/abacatepay.js';
import { BadRequestError, NotFoundError } from '../../lib/errors.js';
import { logger } from '../../lib/logger.js';
import type { Payment, PaymentStatus } from '../../db/schema.js';
import * as productRepo from '../products/product.repository.js';
import * as orderRepo from './order.repository.js';
import * as paymentRepo from './payment.repository.js';

const DESCRIPTION = 'Pedido Mercado Zap';

// Maps AbacatePay statuses to our internal enum.
const PROVIDER_STATUS_MAP: Record<string, PaymentStatus> = {
  PENDING: 'PENDING',
  PAID: 'PAID',
  EXPIRED: 'EXPIRED',
  CANCELLED: 'CANCELLED',
  REFUNDED: 'CANCELLED',
};

export interface CheckoutItem {
  productId: number;
  quantity: number;
}

// Public view of a payment: never exposes internal ids (providerId, orderId).
export interface PublicPayment {
  id: string;
  amountCents: number;
  status: PaymentStatus;
  brCode: string;
  createdAt: Date;
  updatedAt: Date;
}

function toPublicPayment(p: Payment): PublicPayment {
  return {
    id: p.id,
    amountCents: p.amountCents,
    status: p.status,
    brCode: p.brCode,
    createdAt: p.createdAt,
    updatedAt: p.updatedAt,
  };
}

/**
 * Creates a PIX charge for a checkout. The price is computed **on the server**
 * from its own catalog — the client only says what it wants to buy, never how
 * much it costs. All money math is in integer cents.
 */
export async function createCheckout(items: CheckoutItem[]): Promise<PublicPayment> {
  // Merge duplicate product ids into a single line.
  const quantities = new Map<number, number>();
  for (const item of items) {
    quantities.set(item.productId, (quantities.get(item.productId) ?? 0) + item.quantity);
  }

  const found = await productRepo.findActiveByIds([...quantities.keys()]);
  const byId = new Map(found.map((p) => [p.id, p]));

  const lines = [...quantities].map(([productId, quantity]) => {
    const product = byId.get(productId);
    if (!product) {
      throw new BadRequestError(`Unknown or inactive product: ${productId}`);
    }
    return {
      productId,
      quantity,
      unitPriceCents: product.priceCents,
      lineTotalCents: product.priceCents * quantity,
    };
  });

  const totalCents = lines.reduce((sum, line) => sum + line.lineTotalCents, 0);
  if (totalCents <= 0) {
    throw new BadRequestError('Order total must be positive');
  }

  const order = await orderRepo.createOrderWithItems(totalCents, lines);

  const pix = await createPixQrCode({ amountInCents: totalCents, description: DESCRIPTION });

  const payment = await paymentRepo.insertPayment({
    orderId: order.id,
    providerId: pix.id,
    amountCents: totalCents,
    brCode: pix.brCode,
    status: 'PENDING',
  });

  return toPublicPayment(payment);
}

export async function getPayment(id: string): Promise<PublicPayment> {
  const payment = await paymentRepo.findPaymentById(id);
  if (!payment) {
    throw new NotFoundError('Payment not found');
  }
  return toPublicPayment(payment);
}

// Called by the webhook worker. Never trusts the webhook body: it re-checks the
// real status with AbacatePay and persists it.
export async function reconcilePaymentStatus(providerId: string): Promise<void> {
  const { status } = await getPixStatus(providerId);
  const mapped = PROVIDER_STATUS_MAP[status] ?? 'PENDING';

  const updated = await paymentRepo.updatePaymentStatus(providerId, mapped);
  if (!updated) {
    logger.warn({ providerId }, 'Received a webhook for an unknown payment');
    return;
  }

  logger.info({ providerId, status: mapped }, 'Payment status reconciled');
}
