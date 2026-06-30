import { Queue } from 'bullmq';

import { redisConnection } from './redis.js';

export const PAYMENT_WEBHOOK_QUEUE = 'payment-webhook';

export interface PaymentWebhookJob {
  providerId: string;
}

export const paymentWebhookQueue = new Queue<PaymentWebhookJob>(PAYMENT_WEBHOOK_QUEUE, {
  connection: redisConnection,
  defaultJobOptions: {
    attempts: 5,
    backoff: { type: 'exponential', delay: 2000 },
    removeOnComplete: 1000,
    removeOnFail: 5000,
  },
});
