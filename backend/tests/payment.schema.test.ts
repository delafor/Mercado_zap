import { describe, expect, it } from 'vitest';

import { checkoutSchema, paymentIdSchema } from '../src/modules/payments/payment.schema.js';

describe('checkoutSchema', () => {
  it('accepts valid items', () => {
    expect(checkoutSchema.parse({ items: [{ productId: 1, quantity: 2 }] })).toEqual({
      items: [{ productId: 1, quantity: 2 }],
    });
  });

  it('rejects an empty cart', () => {
    expect(() => checkoutSchema.parse({ items: [] })).toThrow();
  });

  it('rejects invalid product ids and quantities', () => {
    expect(() => checkoutSchema.parse({ items: [{ productId: 1, quantity: 0 }] })).toThrow();
    expect(() => checkoutSchema.parse({ items: [{ productId: 1, quantity: 1.5 }] })).toThrow();
    expect(() => checkoutSchema.parse({ items: [{ productId: -1, quantity: 1 }] })).toThrow();
  });

  it('rejects any price the client tries to send', () => {
    expect(() =>
      checkoutSchema.parse({ items: [{ productId: 1, quantity: 1, price: 0.01 }] }),
    ).toThrow();
  });
});

describe('paymentIdSchema', () => {
  it('accepts a UUID', () => {
    expect(paymentIdSchema.parse('00000000-0000-0000-0000-000000000000')).toBeDefined();
  });

  it('rejects a non-UUID', () => {
    expect(() => paymentIdSchema.parse('not-a-uuid')).toThrow();
  });
});
