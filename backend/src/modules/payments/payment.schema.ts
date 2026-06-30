import { z } from 'zod';

// The client sends WHAT it wants to buy — never the price. The server computes
// the amount from its own catalog.
export const checkoutSchema = z
  .object({
    items: z
      .array(
        z
          .object({
            productId: z.number().int().positive(),
            quantity: z.number().int().positive().max(99),
          })
          .strict(),
      )
      .min(1)
      .max(50),
  })
  .strict();

export type CheckoutDto = z.infer<typeof checkoutSchema>;

// Path param: a payment id must be a UUID.
export const paymentIdSchema = z.string().uuid();
