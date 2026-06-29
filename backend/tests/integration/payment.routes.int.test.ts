import express from 'express';
import request from 'supertest';
import { afterAll, beforeEach, describe, expect, it } from 'vitest';

import { db, pool } from '../../src/db/client.js';
import { payments } from '../../src/db/schema.js';
import { errorHandler } from '../../src/middlewares/error-handler.js';
import * as repo from '../../src/modules/payments/payment.repository.js';
import { paymentRoutes } from '../../src/modules/payments/payment.routes.js';

// Minimal app with just the payment routes (no Redis/queue) for a real
// HTTP-to-database round trip.
const app = express();
app.use(express.json());
app.use('/payments', paymentRoutes);
app.use(errorHandler);

beforeEach(async () => {
  await db.delete(payments);
});

afterAll(async () => {
  await pool.end();
});

describe('GET /payments/:id (integration)', () => {
  it('returns 200 with a persisted payment', async () => {
    const created = await repo.insertPayment({
      providerId: 'prov_1',
      amount: 2590,
      brCode: 'br-code',
      description: 'Pedido Mercado Zap',
      status: 'PENDING',
    });

    const res = await request(app).get(`/payments/${created.id}`);

    expect(res.status).toBe(200);
    expect(res.body.providerId).toBe('prov_1');
    expect(res.body.amount).toBe(2590);
  });

  it('returns 404 for a missing payment', async () => {
    const res = await request(app).get('/payments/00000000-0000-0000-0000-000000000000');
    expect(res.status).toBe(404);
  });
});
