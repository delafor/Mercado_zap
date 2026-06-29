import axios from 'axios';

import { env } from '../config/env.js';
import { AppError } from './errors.js';
import { logger } from './logger.js';

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

// Runs a provider request, translating any failure into a 502 (logging the real
// cause) so the provider's internals never leak to the client and provider
// outages are not reported as generic 500s.
async function request<T>(operation: string, fn: () => Promise<T>): Promise<T> {
  try {
    return await fn();
  } catch (err) {
    if (axios.isAxiosError(err)) {
      logger.error(
        { operation, status: err.response?.status, data: err.response?.data },
        'AbacatePay request failed',
      );
      throw new AppError(502, 'Payment provider unavailable');
    }
    throw err;
  }
}

export async function createPixQrCode(input: CreatePixInput): Promise<AbacatePayPix> {
  return request('createPixQrCode', async () => {
    const { data } = await client.post<AbacatePayEnvelope<AbacatePayPix>>('/pixQrCode/create', {
      amount: input.amountInCents,
      description: input.description,
    });
    return data.data;
  });
}

export async function getPixStatus(id: string): Promise<{ status: string }> {
  return request('getPixStatus', async () => {
    const { data } = await client.get<AbacatePayEnvelope<{ status: string }>>('/pixQrCode/check', {
      params: { id },
    });
    return data.data;
  });
}
