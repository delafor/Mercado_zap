// Centralized error handler. Logs the real (possibly upstream) error for
// debugging but never leaks provider internals to the client.
// eslint-disable-next-line no-unused-vars
function errorHandler(err, req, res, next) {
  const upstream = err.response?.data;
  console.error('[error]', upstream || err.message);

  res.status(502).json({
    error: true,
    message: 'Payment processing failed. Please try again.',
  });
}

module.exports = { errorHandler };
