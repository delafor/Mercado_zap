require('dotenv').config();

const express = require('express');
const cors = require('cors');
const axios = require('axios');

const app = express();

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.send('Backend online');
});

app.post('/payments/pix', async (req, res) => {
  try {
    const response = await axios.post(
      'https://api.abacatepay.com/v1/pixQrCode/create',
      {
      amount: Math.round(req.body.amount * 100),

        description: 'Pedido Mercado Zap',
      },
      {
        headers: {
          Authorization: `Bearer ${process.env.ABACATEPAY_KEY}`,
        },
      },
    );

    res.json(response.data);
  } catch (e) {
    console.log(e.response?.data);

    res.status(500).json({
      error: true,
      message: e.response?.data || 'Erro no pagamento',
    });
  }
});

app.listen(3000, () => {
  console.log('Servidor rodando na porta 3000');
});