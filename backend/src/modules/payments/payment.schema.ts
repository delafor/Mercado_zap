import { z } from 'zod';

// Amount is in currency units (e.g. reais); converted to cents in the service.
export const createPixSchema = z.object({
  amount: z.number().positive().finite(),
});

export type CreatePixDto = z.infer<typeof createPixSchema>;
