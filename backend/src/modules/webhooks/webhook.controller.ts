import type { Request, Response } from 'express';
import { z } from 'zod';

import { env } from '../../config/env.js';
import { asyncHandler, UnauthorizedError } from '../../lib/errors.js';
import { logger } from '../../lib/logger.js';
import { paymentWebhookQueue } from '../../queues/payment-webhook.queue.js';

// AbacatePay payload shape varies by event; we only need a payment id and try a
// few known locations.
const webhookSchema = z.object({
  data: z.object({
    id: z.string().optional(),
    pixQrCode: z.object({ id: z.string() }).optional(),
    payment: z.object({ id: z.string() }).optional(),
  }),
});

export const handleAbacatePayWebhook = asyncHandler(async (req: Request, res: Response) => {
  // AbacatePay sends the configured secret as ?webhookSecret=...
  if (req.query.webhookSecret !== env.ABACATEPAY_WEBHOOK_SECRET) {
    throw new UnauthorizedError('Invalid webhook secret');
  }

  const { data } = webhookSchema.parse(req.body);
  const providerId = data.pixQrCode?.id ?? data.payment?.id ?? data.id;

  if (!providerId) {
    logger.warn({ body: req.body }, 'Webhook received without a payment id');
    res.status(202).json({ received: true });
    return;
  }

  // Acknowledge fast and process asynchronously via the queue.
  await paymentWebhookQueue.add('reconcile', { providerId });
  res.status(202).json({ received: true });
});
