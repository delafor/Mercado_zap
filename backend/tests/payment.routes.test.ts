import request from 'supertest';
import { beforeEach, describe, expect, it, vi } from 'vitest';

vi.mock('../src/modules/payments/payment.service.js', () => ({
  createPixPayment: vi.fn(),
  getPayment: vi.fn(),
  reconcilePaymentStatus: vi.fn(),
}));

// Avoid touching Redis when app.ts imports the webhook routes.
vi.mock('../src/queues/payment-webhook.queue.js', () => ({
  PAYMENT_WEBHOOK_QUEUE: 'payment-webhook',
  paymentWebhookQueue: { add: vi.fn() },
}));

import { createApp } from '../src/app.js';
import * as service from '../src/modules/payments/payment.service.js';

const app = createApp();

describe('GET /health', () => {
  it('returns ok', async () => {
    const res = await request(app).get('/health');
    expect(res.status).toBe(200);
    expect(res.body).toEqual({ status: 'ok' });
  });
});

describe('POST /payments/pix', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('returns 400 for an invalid amount and does not hit the service', async () => {
    const res = await request(app).post('/payments/pix').send({ amount: -5 });
    expect(res.status).toBe(400);
    expect(res.body.error).toBe(true);
    expect(service.createPixPayment).not.toHaveBeenCalled();
  });

  it('returns 201 with the created payment', async () => {
    vi.mocked(service.createPixPayment).mockResolvedValue({
      id: 'uuid',
      amount: 2590,
      status: 'PENDING',
    } as never);

    const res = await request(app).post('/payments/pix').send({ amount: 25.9 });

    expect(res.status).toBe(201);
    expect(res.body.id).toBe('uuid');
    expect(service.createPixPayment).toHaveBeenCalledWith(25.9);
  });
});
