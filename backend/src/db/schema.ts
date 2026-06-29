import {
  bigint,
  boolean,
  integer,
  pgEnum,
  pgTable,
  text,
  timestamp,
  uuid,
} from 'drizzle-orm/pg-core';

export const paymentStatus = pgEnum('payment_status', [
  'PENDING',
  'PAID',
  'EXPIRED',
  'CANCELLED',
  'FAILED',
]);

// Server-owned catalog. Prices are stored in cents (integer) — never floats.
export const products = pgTable('products', {
  id: integer('id').primaryKey(),
  name: text('name').notNull(),
  category: text('category').notNull(),
  priceCents: bigint('price_cents', { mode: 'number' }).notNull(),
  active: boolean('active').notNull().default(true),
});

// A checkout: an immutable snapshot of what was ordered and the total computed
// by the server.
export const orders = pgTable('orders', {
  id: uuid('id').primaryKey().defaultRandom(),
  totalCents: bigint('total_cents', { mode: 'number' }).notNull(),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
});

export const orderItems = pgTable('order_items', {
  id: uuid('id').primaryKey().defaultRandom(),
  orderId: uuid('order_id')
    .notNull()
    .references(() => orders.id, { onDelete: 'cascade' }),
  productId: integer('product_id')
    .notNull()
    .references(() => products.id),
  quantity: integer('quantity').notNull(),
  // Unit price snapshotted at purchase time, so later price changes do not
  // rewrite history.
  unitPriceCents: bigint('unit_price_cents', { mode: 'number' }).notNull(),
  lineTotalCents: bigint('line_total_cents', { mode: 'number' }).notNull(),
});

export const payments = pgTable('payments', {
  id: uuid('id').primaryKey().defaultRandom(),
  orderId: uuid('order_id')
    .notNull()
    .unique()
    .references(() => orders.id),
  // AbacatePay's identifier for this charge.
  providerId: text('provider_id').notNull().unique(),
  amountCents: bigint('amount_cents', { mode: 'number' }).notNull(),
  status: paymentStatus('status').notNull().default('PENDING'),
  brCode: text('br_code').notNull(),
  createdAt: timestamp('created_at', { withTimezone: true }).notNull().defaultNow(),
  updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
});

export type Product = typeof products.$inferSelect;
export type Order = typeof orders.$inferSelect;
export type NewOrderItem = typeof orderItems.$inferInsert;
export type Payment = typeof payments.$inferSelect;
export type NewPayment = typeof payments.$inferInsert;
export type PaymentStatus = Payment['status'];
