const { createPixQrCode } = require('../services/abacatepay.service');

// POST /payments/pix
async function createPixPayment(req, res, next) {
  const { amount } = req.body;

  if (typeof amount !== 'number' || !Number.isFinite(amount) || amount <= 0) {
    return res.status(400).json({
      error: true,
      message: 'Field "amount" must be a positive number.',
    });
  }

  try {
    const payment = await createPixQrCode({
      amount,
      description: 'Pedido Mercado Zap',
    });

    return res.status(201).json(payment);
  } catch (err) {
    return next(err);
  }
}

module.exports = { createPixPayment };
