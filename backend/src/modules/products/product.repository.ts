import { and, eq, inArray } from 'drizzle-orm';

import { db } from '../../db/client.js';
import { products, type Product } from '../../db/schema.js';

export async function findActiveByIds(ids: number[]): Promise<Product[]> {
  if (ids.length === 0) return [];
  return db
    .select()
    .from(products)
    .where(and(inArray(products.id, ids), eq(products.active, true)));
}
