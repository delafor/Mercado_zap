const express = require('express');
const cors = require('cors');

const paymentsRoutes = require('./routes/payments.routes');
const { errorHandler } = require('./middlewares/errorHandler');

const app = express();

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => res.send('Backend online'));

app.use('/payments', paymentsRoutes);

// Error handler must be registered last, after the routes.
app.use(errorHandler);

module.exports = app;
