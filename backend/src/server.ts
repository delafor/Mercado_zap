import { createApp } from './app.js';
import { env } from './config/env.js';
import { pool } from './db/client.js';
import { logger } from './lib/logger.js';
import { redisConnection } from './queues/redis.js';
import { startPaymentWebhookWorker } from './queues/payment-webhook.worker.js';

const app = createApp();
const worker = startPaymentWebhookWorker();

const server = app.listen(env.PORT, () => {
  logger.info(`Server running on port ${env.PORT}`);
});

async function shutdown(signal: string): Promise<void> {
  logger.info({ signal }, 'Shutting down gracefully...');
  server.close();
  await worker.close();
  await redisConnection.quit();
  await pool.end();
  process.exit(0);
}

process.on('SIGINT', () => void shutdown('SIGINT'));
process.on('SIGTERM', () => void shutdown('SIGTERM'));
