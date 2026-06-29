require('dotenv').config();

// Reads an environment variable and fails fast if it is missing, so the
// server never starts in a half-configured state.
function required(name) {
  const value = process.env[name];

  if (!value || !value.trim()) {
    throw new Error(`Missing required environment variable: ${name}`);
  }

  return value.trim();
}

const env = {
  port: Number(process.env.PORT) || 3000,
  abacatePayKey: required('ABACATEPAY_KEY'),
};

module.exports = { env };
