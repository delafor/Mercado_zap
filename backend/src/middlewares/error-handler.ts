import type { ErrorRequestHandler } from 'express';
import { ZodError } from 'zod';

import { AppError } from '../lib/errors.js';
import { logger } from '../lib/logger.js';

// Central error handler. Must be registered last, after all routes.
export const errorHandler: ErrorRequestHandler = (err, _req, res, _next) => {
  if (err instanceof ZodError) {
    res.status(400).json({
      error: true,
      message: 'Validation failed',
      details: err.flatten().fieldErrors,
    });
    return;
  }

  if (err instanceof AppError) {
    res.status(err.statusCode).json({
      error: true,
      message: err.message,
      details: err.details,
    });
    return;
  }

  // Unexpected error: log the real cause, return a generic message.
  logger.error({ err }, 'Unhandled error');
  res.status(500).json({ error: true, message: 'Internal server error' });
};
