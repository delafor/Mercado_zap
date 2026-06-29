import { Router } from 'express';

import { handleAbacatePayWebhook } from './webhook.controller.js';

export const webhookRoutes = Router();

webhookRoutes.post('/abacatepay', handleAbacatePayWebhook);
