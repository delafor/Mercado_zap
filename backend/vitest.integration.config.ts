import { defineConfig } from 'vitest/config';

// Integration tests run against real Postgres/Redis (see docker-compose.yml).
export default defineConfig({
  test: {
    environment: 'node',
    include: ['tests/integration/**/*.int.test.ts'],
    globalSetup: ['./tests/integration/global-setup.ts'],
    setupFiles: ['./tests/integration/setup.ts'],
    // Tests share one database; run files sequentially to avoid races.
    fileParallelism: false,
  },
});
