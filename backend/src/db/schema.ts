import { integer, pgEnum, pgTable, text, timestamp, uuid } from 'drizzle-orm/pg-core';

export const paymentStatus = pgEnum('payment_status', [
  'PENDING',
  'PAID',
  'EXPIRED',
  'CANCELLED',
  'FAILED',
]);

export const payments = pgTable('payments', {
  id: uuid('id').primaryKey().defaultRandom(),
  // AbacatePay's identifier for this charge.
  providerId: text('provider_id').notNull().unique(),
  // Amount in cents.
  amount: integer('amount').notNull(),
  status: paymentStatus('status').notNull().default('PENDING'),
  brCode: text('br_code').notNull(),
  description: text('description').notNull(),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
});

export type Payment = typeof payments.$inferSelect;
export type NewPayment = typeof payments.$inferInsert;
export type PaymentStatus = Payment['status'];
