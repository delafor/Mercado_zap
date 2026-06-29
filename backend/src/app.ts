import cors from 'cors';
import express, { type Express } from 'express';
import rateLimit from 'express-rate-limit';
import helmet from 'helmet';
import { pinoHttp } from 'pino-http';

import { logger } from './lib/logger.js';
import { errorHandler } from './middlewares/error-handler.js';
import { paymentRoutes } from './modules/payments/payment.routes.js';
import { webhookRoutes } from './modules/webhooks/webhook.routes.js';

export function createApp(): Express {
  const app = express();

  app.use(helmet());
  app.use(cors());
  app.use(pinoHttp({ logger }));
  app.use(express.json());

  app.get('/health', (_req, res) => {
    res.json({ status: 'ok' });
  });

  // Rate limit the public API. Webhooks are excluded so the provider is not throttled.
  const apiLimiter = rateLimit({
    windowMs: 60_000,
    limit: 100,
    standardHeaders: true,
    legacyHeaders: false,
  });

  app.use('/payments', apiLimiter, paymentRoutes);
  app.use('/webhooks', webhookRoutes);

  app.use(errorHandler);

  return app;
}
