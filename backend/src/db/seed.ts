import { logger } from '../lib/logger.js';
import { db, pool } from './client.js';
import { products } from './schema.js';

// Server-owned catalog. Prices in cents — the single source of truth for what a
// product costs. The client never sends prices.
const CATALOG = [
  { id: 1, name: 'Arroz Branco 5kg', category: 'Grãos', priceCents: 2590 },
  { id: 2, name: 'Feijão Carioca 1kg', category: 'Grãos', priceCents: 850 },
  { id: 3, name: 'Biscoito Recheado 140g', category: 'Snacks', priceCents: 350 },
  { id: 4, name: 'Refrigerante Cola 2L', category: 'Bebidas', priceCents: 899 },
  { id: 5, name: 'carrinho 1kg', category: 'Bebidas', priceCents: 899 },
];

export async function seedProducts(): Promise<void> {
  for (const product of CATALOG) {
    await db
      .insert(products)
      .values({ ...product, active: true })
      .onConflictDoUpdate({
        target: products.id,
        set: {
          name: product.name,
          category: product.category,
          priceCents: product.priceCents,
          active: true,
        },
      });
  }
  logger.info(`Seeded ${CATALOG.length} products`);
}

// Allow running directly: `npm run db:seed`.
if (import.meta.url === `file://${process.argv[1]}`) {
  seedProducts()
    .then(() => pool.end())
    .catch((err) => {
      logger.error({ err }, 'Seed failed');
      process.exit(1);
    });
}
