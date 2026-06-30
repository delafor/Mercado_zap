const axios = require('axios');

const { env } = require('../config/env');

const client = axios.create({
  baseURL: 'https://api.abacatepay.com/v1',
  headers: { Authorization: `Bearer ${env.abacatePayKey}` },
});

// AbacatePay expects the amount in cents.
function toCents(value) {
  return Math.round(value * 100);
}

async function createPixQrCode({ amount, description }) {
  const { data } = await client.post('/pixQrCode/create', {
    amount: toCents(amount),
    description,
  });

  return data;
}

module.exports = { createPixQrCode };
