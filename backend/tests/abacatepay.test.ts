import { beforeEach, describe, expect, it, vi } from 'vitest';

// vi.mock is hoisted above imports, so the mock fns must be created with
// vi.hoisted to exist when the factory runs.
const { post, get } = vi.hoisted(() => ({ post: vi.fn(), get: vi.fn() }));

vi.mock('axios', () => ({
  default: {
    create: () => ({ post, get }),
    // Every rejection in this test represents a provider (axios) failure.
    isAxiosError: () => true,
  },
}));

import { createPixQrCode } from '../src/lib/abacatepay.js';
import { AppError } from '../src/lib/errors.js';

describe('abacatepay client', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('translates provider failures into a 502 AppError', async () => {
    post.mockRejectedValue(new Error('boom'));

    await expect(createPixQrCode({ amountInCents: 100, description: 'x' })).rejects.toBeInstanceOf(
      AppError,
    );
    await expect(createPixQrCode({ amountInCents: 100, description: 'x' })).rejects.toMatchObject({
      statusCode: 502,
    });
  });

  it('unwraps the provider envelope on success', async () => {
    post.mockResolvedValue({
      data: { data: { id: 'p1', brCode: 'c', brCodeBase64: 'b', status: 'PENDING' } },
    });

    const result = await createPixQrCode({ amountInCents: 100, description: 'x' });
    expect(result.id).toBe('p1');
  });
});
