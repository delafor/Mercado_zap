import type { Request, Response } from 'express';

import { asyncHandler } from '../../lib/errors.js';
import { checkoutSchema, paymentIdSchema } from './payment.schema.js';
import * as service from './payment.service.js';

export const createPixPayment = asyncHandler(async (req: Request, res: Response) => {
  const { items } = checkoutSchema.parse(req.body);
  const payment = await service.createCheckout(items);
  res.status(201).json(payment);
});

export const getPayment = asyncHandler(async (req: Request, res: Response) => {
  const id = paymentIdSchema.parse(req.params.id);
  const payment = await service.getPayment(id);
  res.json(payment);
});
