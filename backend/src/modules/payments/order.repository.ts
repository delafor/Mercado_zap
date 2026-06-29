import { db } from '../../db/client.js';
import { orderItems, orders, type Order } from '../../db/schema.js';

export interface OrderLine {
  productId: number;
  quantity: number;
  unitPriceCents: number;
  lineTotalCents: number;
}

// Creates the order and its line items atomically.
export async function createOrderWithItems(totalCents: number, lines: OrderLine[]): Promise<Order> {
  return db.transaction(async (tx) => {
    const [order] = await tx.insert(orders).values({ totalCents }).returning();
    await tx.insert(orderItems).values(lines.map((line) => ({ ...line, orderId: order.id })));
    return order;
  });
}
