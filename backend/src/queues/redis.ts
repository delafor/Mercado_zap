import { Redis } from 'ioredis';

import { env } from '../config/env.js';

// BullMQ requires maxRetriesPerRequest to be null on its connection.
export const redisConnection = new Redis(env.REDIS_URL, {
  maxRetriesPerRequest: null,
});
