import type { Request, Response } from 'express';

import { asyncHandler } from '../../lib/errors.js';
import { createPixSchema } from './payment.schema.js';
import * as service from './payment.service.js';

export const createPixPayment = asyncHandler(async (req: Request, res: Response) => {
  const { amount } = createPixSchema.parse(req.body);
  const payment = await service.createPixPayment(amount);
  res.status(201).json(payment);
});

export const getPayment = asyncHandler(async (req: Request, res: Response) => {
  const payment = await service.getPayment(req.params.id);
  res.json(payment);
});
