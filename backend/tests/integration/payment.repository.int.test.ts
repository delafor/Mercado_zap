import { afterAll, beforeEach, describe, expect, it } from 'vitest';

import { db, pool } from '../../src/db/client.js';
import { orderItems, orders, payments } from '../../src/db/schema.js';
import * as orderRepo from '../../src/modules/payments/order.repository.js';
import * as paymentRepo from '../../src/modules/payments/payment.repository.js';
import * as productRepo from '../../src/modules/products/product.repository.js';

beforeEach(async () => {
  // Clear in FK order; products are seeded and kept.
  await db.delete(payments);
  await db.delete(orderItems);
  await db.delete(orders);
});

afterAll(async () => {
  await pool.end();
});

describe('product.repository (integration)', () => {
  it('returns active products by id from the seeded catalog', async () => {
    const found = await productRepo.findActiveByIds([1, 3]);
    expect(found.map((p) => p.id).sort()).toEqual([1, 3]);
    const arroz = found.find((p) => p.id === 1);
    expect(arroz?.priceCents).toBe(2590);
  });
});

describe('order + payment repositories (integration)', () => {
  it('creates an order with items and a linked payment, then reads it back', async () => {
    const order = await orderRepo.createOrderWithItems(5530, [
      { productId: 1, quantity: 2, unitPriceCents: 2590, lineTotalCents: 5180 },
      { productId: 3, quantity: 1, unitPriceCents: 350, lineTotalCents: 350 },
    ]);
    expect(order.id).toBeDefined();
    expect(order.totalCents).toBe(5530);

    const payment = await paymentRepo.insertPayment({
      orderId: order.id,
      providerId: 'prov_int_1',
      amountCents: 5530,
      brCode: 'br-code',
      status: 'PENDING',
    });

    const found = await paymentRepo.findPaymentById(payment.id);
    expect(found?.amountCents).toBe(5530);
    expect(found?.orderId).toBe(order.id);

    const updated = await paymentRepo.updatePaymentStatus('prov_int_1', 'PAID');
    expect(updated?.status).toBe('PAID');
  });
});
