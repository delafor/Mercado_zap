import { eq } from 'drizzle-orm';

import { db } from '../../db/client.js';
import { payments, type NewPayment, type Payment, type PaymentStatus } from '../../db/schema.js';

export async function insertPayment(data: NewPayment): Promise<Payment> {
  const [row] = await db.insert(payments).values(data).returning();
  return row;
}

export async function findPaymentById(id: string): Promise<Payment | undefined> {
  const [row] = await db.select().from(payments).where(eq(payments.id, id));
  return row;
}

export async function updatePaymentStatus(
  providerId: string,
  status: PaymentStatus,
): Promise<Payment | undefined> {
  const [row] = await db
    .update(payments)
    .set({ status, updatedAt: new Date() })
    .where(eq(payments.providerId, providerId))
    .returning();
  return row;
}
