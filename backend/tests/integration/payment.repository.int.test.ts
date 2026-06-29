import { afterAll, beforeEach, describe, expect, it } from 'vitest';

import { db, pool } from '../../src/db/client.js';
import { payments } from '../../src/db/schema.js';
import * as repo from '../../src/modules/payments/payment.repository.js';

beforeEach(async () => {
  await db.delete(payments);
});

afterAll(async () => {
  await pool.end();
});

describe('payment.repository (integration)', () => {
  it('inserts a payment and reads it back by id', async () => {
    const created = await repo.insertPayment({
      providerId: 'prov_1',
      amount: 2590,
      brCode: 'br-code',
      description: 'Pedido Mercado Zap',
      status: 'PENDING',
    });

    expect(created.id).toBeDefined();
    expect(created.status).toBe('PENDING');

    const found = await repo.findPaymentById(created.id);
    expect(found?.providerId).toBe('prov_1');
    expect(found?.amount).toBe(2590);
  });

  it('updates the status by provider id', async () => {
    await repo.insertPayment({
      providerId: 'prov_2',
      amount: 100,
      brCode: 'br-code',
      description: 'Pedido Mercado Zap',
      status: 'PENDING',
    });

    const updated = await repo.updatePaymentStatus('prov_2', 'PAID');
    expect(updated?.status).toBe('PAID');
  });

  it('returns undefined for an unknown id', async () => {
    const found = await repo.findPaymentById('00000000-0000-0000-0000-000000000000');
    expect(found).toBeUndefined();
  });
});
