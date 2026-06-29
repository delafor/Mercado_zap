import express from 'express';
import request from 'supertest';
import { afterAll, beforeEach, describe, expect, it } from 'vitest';

import { db, pool } from '../../src/db/client.js';
import { orderItems, orders, payments } from '../../src/db/schema.js';
import { errorHandler } from '../../src/middlewares/error-handler.js';
import * as orderRepo from '../../src/modules/payments/order.repository.js';
import * as paymentRepo from '../../src/modules/payments/payment.repository.js';
import { paymentRoutes } from '../../src/modules/payments/payment.routes.js';

// Minimal app with just the payment routes (no Redis/queue) for a real
// HTTP-to-database round trip.
const app = express();
app.use(express.json());
app.use('/payments', paymentRoutes);
app.use(errorHandler);

beforeEach(async () => {
  await db.delete(payments);
  await db.delete(orderItems);
  await db.delete(orders);
});

afterAll(async () => {
  await pool.end();
});

describe('GET /payments/:id (integration)', () => {
  it('returns 200 with the public payment shape (no internal ids)', async () => {
    const order = await orderRepo.createOrderWithItems(2590, [
      { productId: 1, quantity: 1, unitPriceCents: 2590, lineTotalCents: 2590 },
    ]);
    const payment = await paymentRepo.insertPayment({
      orderId: order.id,
      providerId: 'prov_int_2',
      amountCents: 2590,
      brCode: 'br-code',
      status: 'PENDING',
    });

    const res = await request(app).get(`/payments/${payment.id}`);

    expect(res.status).toBe(200);
    expect(res.body.id).toBe(payment.id);
    expect(res.body.amountCents).toBe(2590);
    expect(res.body).not.toHaveProperty('providerId');
    expect(res.body).not.toHaveProperty('orderId');
  });

  it('returns 404 for a missing payment', async () => {
    const res = await request(app).get('/payments/00000000-0000-0000-0000-000000000000');
    expect(res.status).toBe(404);
  });

  it('returns 400 for a non-UUID id', async () => {
    const res = await request(app).get('/payments/not-a-uuid');
    expect(res.status).toBe(400);
  });
});
