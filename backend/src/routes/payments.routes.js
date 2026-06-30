const { Router } = require('express');

const { createPixPayment } = require('../controllers/payments.controller');

const router = Router();

router.post('/pix', createPixPayment);

module.exports = router;
