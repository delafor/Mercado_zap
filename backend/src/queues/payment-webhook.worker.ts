import { Worker } from 'bullmq';

import { PAYMENT_WEBHOOK_QUEUE, type PaymentWebhookJob } from './payment-webhook.queue.js';
import { redisConnection } from './redis.js';
import { reconcilePaymentStatus } from '../modules/payments/payment.service.js';
import { logger } from '../lib/logger.js';

// Processes webhook jobs: re-checks the real payment status with AbacatePay
// and persists it. Runs with BullMQ retries/backoff for resilience.
export function startPaymentWebhookWorker(): Worker<PaymentWebhookJob> {
  const worker = new Worker<PaymentWebhookJob>(
    PAYMENT_WEBHOOK_QUEUE,
    async (job) => {
      await reconcilePaymentStatus(job.data.providerId);
    },
    { connection: redisConnection },
  );

  worker.on('completed', (job) => logger.info({ jobId: job.id }, 'Webhook job completed'));
  worker.on('failed', (job, err) => logger.error({ jobId: job?.id, err }, 'Webhook job failed'));

  return worker;
}
