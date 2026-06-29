// Integration env. Uses the real services from docker-compose.yml; CI can
// override DATABASE_URL / REDIS_URL.
process.env.NODE_ENV = 'test';
process.env.LOG_LEVEL = 'silent';
process.env.DATABASE_URL ??= 'postgres://mercadozap:mercadozap@localhost:5432/mercadozap';
process.env.REDIS_URL ??= 'redis://localhost:6379';
process.env.ABACATEPAY_KEY ??= 'test-key';
process.env.ABACATEPAY_WEBHOOK_SECRET ??= 'test-secret';
