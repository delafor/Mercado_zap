import { beforeEach, describe, expect, it, vi } from 'vitest';

vi.mock('../src/lib/abacatepay.js', () => ({
  createPixQrCode: vi.fn(),
  getPixStatus: vi.fn(),
}));
vi.mock('../src/modules/products/product.repository.js', () => ({
  findActiveByIds: vi.fn(),
}));
vi.mock('../src/modules/payments/order.repository.js', () => ({
  createOrderWithItems: vi.fn(),
}));
vi.mock('../src/modules/payments/payment.repository.js', () => ({
  insertPayment: vi.fn(),
  findPaymentById: vi.fn(),
  updatePaymentStatus: vi.fn(),
}));

import * as abacatepay from '../src/lib/abacatepay.js';
import * as orderRepo from '../src/modules/payments/order.repository.js';
import * as paymentRepo from '../src/modules/payments/payment.repository.js';
import {
  createCheckout,
  getPayment,
  reconcilePaymentStatus,
} from '../src/modules/payments/payment.service.js';
import * as productRepo from '../src/modules/products/product.repository.js';

describe('payment.service', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('computes the total from the server catalog (in cents), not the client', async () => {
    vi.mocked(productRepo.findActiveByIds).mockResolvedValue([
      { id: 1, name: 'Arroz', category: 'G', priceCents: 2590, active: true },
      { id: 3, name: 'Biscoito', category: 'S', priceCents: 350, active: true },
    ]);
    vi.mocked(orderRepo.createOrderWithItems).mockResolvedValue({
      id: 'order-1',
      totalCents: 5530,
    } as never);
    vi.mocked(abacatepay.createPixQrCode).mockResolvedValue({
      id: 'prov_1',
      brCode: 'br',
      brCodeBase64: 'b',
      status: 'PENDING',
    });
    vi.mocked(paymentRepo.insertPayment).mockImplementation(
      async (data) =>
        ({ id: 'pay-1', createdAt: new Date(), updatedAt: new Date(), ...data }) as never,
    );

    // 2 x 2590 + 1 x 350 = 5530 cents
    const payment = await createCheckout([
      { productId: 1, quantity: 2 },
      { productId: 3, quantity: 1 },
    ]);

    expect(orderRepo.createOrderWithItems).toHaveBeenCalledWith(5530, expect.any(Array));
    expect(abacatepay.createPixQrCode).toHaveBeenCalledWith({
      amountInCents: 5530,
      description: 'Pedido Mercado Zap',
    });
    expect(paymentRepo.insertPayment).toHaveBeenCalledWith(
      expect.objectContaining({ amountCents: 5530, orderId: 'order-1', status: 'PENDING' }),
    );
    expect(payment.amountCents).toBe(5530);
    // Public shape: internal ids are not exposed.
    expect(payment).not.toHaveProperty('providerId');
    expect(payment).not.toHaveProperty('orderId');
  });

  it('rejects an unknown or inactive product', async () => {
    vi.mocked(productRepo.findActiveByIds).mockResolvedValue([]);
    await expect(createCheckout([{ productId: 999, quantity: 1 }])).rejects.toThrow(
      /Unknown or inactive/,
    );
  });

  it('throws NotFound when the payment does not exist', async () => {
    vi.mocked(paymentRepo.findPaymentById).mockResolvedValue(undefined);
    await expect(getPayment('missing')).rejects.toThrow('Payment not found');
  });

  it('reconciles the status from the provider, not the webhook body', async () => {
    vi.mocked(abacatepay.getPixStatus).mockResolvedValue({ status: 'PAID' });
    vi.mocked(paymentRepo.updatePaymentStatus).mockResolvedValue({ providerId: 'prov_1' } as never);

    await reconcilePaymentStatus('prov_1');

    expect(abacatepay.getPixStatus).toHaveBeenCalledWith('prov_1');
    expect(paymentRepo.updatePaymentStatus).toHaveBeenCalledWith('prov_1', 'PAID');
  });
});
