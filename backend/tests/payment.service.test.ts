import { beforeEach, describe, expect, it, vi } from 'vitest';

vi.mock('../src/lib/abacatepay.js', () => ({
  createPixQrCode: vi.fn(),
  getPixStatus: vi.fn(),
}));

vi.mock('../src/modules/payments/payment.repository.js', () => ({
  insertPayment: vi.fn(),
  findPaymentById: vi.fn(),
  updatePaymentStatus: vi.fn(),
}));

import * as abacatepay from '../src/lib/abacatepay.js';
import * as repo from '../src/modules/payments/payment.repository.js';
import {
  createPixPayment,
  getPayment,
  reconcilePaymentStatus,
} from '../src/modules/payments/payment.service.js';

describe('payment.service', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('converts the amount to cents and persists a PENDING payment', async () => {
    vi.mocked(abacatepay.createPixQrCode).mockResolvedValue({
      id: 'prov_1',
      brCode: 'br-code',
      brCodeBase64: 'base64',
      status: 'PENDING',
    });
    vi.mocked(repo.insertPayment).mockImplementation(
      async (data) =>
        ({ id: 'uuid', createdAt: new Date(), updatedAt: new Date(), ...data }) as never,
    );

    const payment = await createPixPayment(25.9);

    expect(abacatepay.createPixQrCode).toHaveBeenCalledWith({
      amountInCents: 2590,
      description: 'Pedido Mercado Zap',
    });
    expect(repo.insertPayment).toHaveBeenCalledWith(
      expect.objectContaining({ providerId: 'prov_1', amount: 2590, status: 'PENDING' }),
    );
    expect(payment.amount).toBe(2590);
  });

  it('throws NotFound when the payment does not exist', async () => {
    vi.mocked(repo.findPaymentById).mockResolvedValue(undefined);
    await expect(getPayment('missing')).rejects.toThrow('Payment not found');
  });

  it('reconciles the status from the provider, not the webhook body', async () => {
    vi.mocked(abacatepay.getPixStatus).mockResolvedValue({ status: 'PAID' });
    vi.mocked(repo.updatePaymentStatus).mockResolvedValue({ providerId: 'prov_1' } as never);

    await reconcilePaymentStatus('prov_1');

    expect(abacatepay.getPixStatus).toHaveBeenCalledWith('prov_1');
    expect(repo.updatePaymentStatus).toHaveBeenCalledWith('prov_1', 'PAID');
  });
});
