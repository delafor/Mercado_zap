// Dummy environment so importing modules that read env.ts does not exit during
// tests. External services (DB, Redis, AbacatePay) are mocked in each test.
process.env.NODE_ENV = 'test';
process.env.LOG_LEVEL = 'silent';
process.env.DATABASE_URL = 'postgres://test:test@localhost:5432/test';
process.env.REDIS_URL = 'redis://localhost:6379';
process.env.ABACATEPAY_KEY = 'test-key';
process.env.ABACATEPAY_WEBHOOK_SECRET = 'test-secret';
