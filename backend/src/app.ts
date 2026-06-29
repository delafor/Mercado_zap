import cors from 'cors';
import express, { type Express } from 'express';
import rateLimit from 'express-rate-limit';
import helmet from 'helmet';
import { stdSerializers } from 'pino';
import { pinoHttp } from 'pino-http';
import swaggerUi from 'swagger-ui-express';

import { env } from './config/env.js';
import { openapiSpec } from './docs/openapi.js';
import { logger } from './lib/logger.js';
import { errorHandler } from './middlewares/error-handler.js';
import { paymentRoutes } from './modules/payments/payment.routes.js';
import { webhookRoutes } from './modules/webhooks/webhook.routes.js';

export function createApp(): Express {
  const app = express();

  // API docs, mounted before helmet so Swagger UI's assets are not blocked by CSP.
  app.use('/docs', swaggerUi.serve, swaggerUi.setup(openapiSpec));
  app.get('/openapi.json', (_req, res) => {
    res.json(openapiSpec);
  });

  app.use(helmet());
  app.use(
    cors({
      origin: env.CORS_ORIGIN === '*' ? true : env.CORS_ORIGIN.split(',').map((o) => o.trim()),
    }),
  );
  app.use(
    pinoHttp({
      logger,
      serializers: {
        // Redact the webhook secret wherever it shows up in the logged request
        // (both the raw URL and the parsed query object).
        req(req) {
          const s = stdSerializers.req(req) as unknown as {
            url?: string;
            query?: Record<string, unknown>;
            [key: string]: unknown;
          };
          if (typeof s.url === 'string') {
            s.url = s.url.replace(/([?&]webhookSecret=)[^&]+/i, '$1[REDACTED]');
          }
          if (s.query && 'webhookSecret' in s.query) {
            s.query = { ...s.query, webhookSecret: '[REDACTED]' };
          }
          return s;
        },
      },
    }),
  );
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
