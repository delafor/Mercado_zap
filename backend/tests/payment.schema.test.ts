import { describe, expect, it } from 'vitest';

import { createPixSchema } from '../src/modules/payments/payment.schema.js';

describe('createPixSchema', () => {
  it('accepts a positive amount', () => {
    expect(createPixSchema.parse({ amount: 25.9 })).toEqual({ amount: 25.9 });
  });

  it('rejects zero or negative amounts', () => {
    expect(() => createPixSchema.parse({ amount: 0 })).toThrow();
    expect(() => createPixSchema.parse({ amount: -10 })).toThrow();
  });

  it('rejects missing or non-numeric amounts', () => {
    expect(() => createPixSchema.parse({})).toThrow();
    expect(() => createPixSchema.parse({ amount: 'abc' })).toThrow();
    expect(() => createPixSchema.parse({ amount: Infinity })).toThrow();
  });
});
