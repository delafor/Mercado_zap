import { Router } from 'express';

import * as controller from './payment.controller.js';

export const paymentRoutes = Router();

paymentRoutes.post('/pix', controller.createPixPayment);
paymentRoutes.get('/:id', controller.getPayment);
