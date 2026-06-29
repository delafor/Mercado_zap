import { createPixQrCode, getPixStatus } from '../../lib/abacatepay.js';
import { NotFoundError } from '../../lib/errors.js';
import { logger } from '../../lib/logger.js';
import type { Payment, PaymentStatus } from '../../db/schema.js';
import * as repo from './payment.repository.js';

const DESCRIPTION = 'Pedido Mercado Zap';

// Maps AbacatePay statuses to our internal enum.
const PROVIDER_STATUS_MAP: Record<string, PaymentStatus> = {
  PENDING: 'PENDING',
  PAID: 'PAID',
  EXPIRED: 'EXPIRED',
  CANCELLED: 'CANCELLED',
  REFUNDED: 'CANCELLED',
};

function toCents(amount: number): number {
  return Math.round(amount * 100);
}

export async function createPixPayment(amount: number): Promise<Payment> {
  const amountInCents = toCents(amount);

  const pix = await createPixQrCode({ amountInCents, description: DESCRIPTION });

  return repo.insertPayment({
    providerId: pix.id,
    amount: amountInCents,
    brCode: pix.brCode,
    description: DESCRIPTION,
    status: 'PENDING',
  });
}

export async function getPayment(id: string): Promise<Payment> {
  const payment = await repo.findPaymentById(id);
  if (!payment) {
    throw new NotFoundError('Payment not found');
  }
  return payment;
}

// Called by the webhook worker. Never trusts the webhook body: it re-checks the
// real status with AbacatePay and persists it.
export async function reconcilePaymentStatus(providerId: string): Promise<void> {
  const { status } = await getPixStatus(providerId);
  const mapped = PROVIDER_STATUS_MAP[status] ?? 'PENDING';

  const updated = await repo.updatePaymentStatus(providerId, mapped);
  if (!updated) {
    logger.warn({ providerId }, 'Received a webhook for an unknown payment');
    return;
  }

  logger.info({ providerId, status: mapped }, 'Payment status reconciled');
}
