import { execSync } from 'node:child_process';

// Applies migrations and seeds the product catalog once before the integration
// suite runs.
export default function setup(): void {
  process.env.DATABASE_URL ??= 'postgres://mercadozap:mercadozap@localhost:5432/mercadozap';
  execSync('npm run db:migrate', { stdio: 'inherit' });
  execSync('npm run db:seed', { stdio: 'inherit' });
}
