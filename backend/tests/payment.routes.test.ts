import request from 'supertest';
import { beforeEach, describe, expect, it, vi } from 'vitest';

vi.mock('../src/modules/payments/payment.service.js', () => ({
  createCheckout: vi.fn(),
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

  it('returns 400 for an empty cart and does not hit the service', async () => {
    const res = await request(app).post('/payments/pix').send({ items: [] });
    expect(res.status).toBe(400);
    expect(service.createCheckout).not.toHaveBeenCalled();
  });

  it('returns 400 when the client sends a price instead of items', async () => {
    const res = await request(app).post('/payments/pix').send({ amount: 0.01 });
    expect(res.status).toBe(400);
    expect(service.createCheckout).not.toHaveBeenCalled();
  });

  it('returns 400 when the client sends item prices', async () => {
    const res = await request(app)
      .post('/payments/pix')
      .send({ items: [{ productId: 1, quantity: 1, price: 0.01 }] });
    expect(res.status).toBe(400);
    expect(service.createCheckout).not.toHaveBeenCalled();
  });

  it('returns 201 and forwards only the items to the service', async () => {
    vi.mocked(service.createCheckout).mockResolvedValue({
      id: 'pay-1',
      amountCents: 2590,
      status: 'PENDING',
      brCode: 'br',
      createdAt: new Date(),
      updatedAt: new Date(),
    });

    const res = await request(app)
      .post('/payments/pix')
      .send({ items: [{ productId: 1, quantity: 1 }] });

    expect(res.status).toBe(201);
    expect(res.body.amountCents).toBe(2590);
    expect(service.createCheckout).toHaveBeenCalledWith([{ productId: 1, quantity: 1 }]);
  });
});

describe('GET /payments/:id', () => {
  it('returns 400 for a non-UUID id', async () => {
    const res = await request(app).get('/payments/not-a-uuid');
    expect(res.status).toBe(400);
  });
});
