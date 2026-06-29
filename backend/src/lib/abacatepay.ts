import axios from 'axios';

import { env } from '../config/env.js';

const client = axios.create({
  baseURL: 'https://api.abacatepay.com/v1',
  timeout: 10_000,
  headers: { Authorization: `Bearer ${env.ABACATEPAY_KEY}` },
});

export interface CreatePixInput {
  amountInCents: number;
  description: string;
}

export interface AbacatePayPix {
  id: string;
  brCode: string;
  brCodeBase64: string;
  status: string;
}

// AbacatePay wraps responses as { data, error }.
interface AbacatePayEnvelope<T> {
  data: T;
  error: string | null;
}

export async function createPixQrCode(input: CreatePixInput): Promise<AbacatePayPix> {
  const { data } = await client.post<AbacatePayEnvelope<AbacatePayPix>>('/pixQrCode/create', {
    amount: input.amountInCents,
    description: input.description,
  });

  return data.data;
}

export async function getPixStatus(id: string): Promise<{ status: string }> {
  const { data } = await client.get<AbacatePayEnvelope<{ status: string }>>('/pixQrCode/check', {
    params: { id },
  });

  return data.data;
}
