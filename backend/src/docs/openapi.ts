// Hand-written OpenAPI 3 spec. Served as JSON at /openapi.json and rendered by
// Swagger UI at /docs.
export const openapiSpec = {
  openapi: '3.0.3',
  info: {
    title: 'Mercado Zap — Payments API',
    version: '1.0.0',
    description: 'Creates PIX charges via AbacatePay and tracks their status.',
  },
  servers: [{ url: 'http://localhost:3000', description: 'Local' }],
  paths: {
    '/health': {
      get: {
        summary: 'Healthcheck',
        responses: {
          '200': {
            description: 'Service is up',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: { status: { type: 'string', example: 'ok' } },
                },
              },
            },
          },
        },
      },
    },
    '/payments/pix': {
      post: {
        summary: 'Create a PIX charge',
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: { $ref: '#/components/schemas/CreatePixRequest' },
            },
          },
        },
        responses: {
          '201': {
            description: 'Payment created',
            content: {
              'application/json': { schema: { $ref: '#/components/schemas/Payment' } },
            },
          },
          '400': {
            description: 'Invalid amount',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
          '502': {
            description: 'Payment provider unavailable',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
        },
      },
    },
    '/payments/{id}': {
      get: {
        summary: 'Get a payment by id',
        parameters: [
          {
            name: 'id',
            in: 'path',
            required: true,
            schema: { type: 'string', format: 'uuid' },
          },
        ],
        responses: {
          '200': {
            description: 'The payment',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Payment' } } },
          },
          '404': {
            description: 'Payment not found',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
        },
      },
    },
    '/webhooks/abacatepay': {
      post: {
        summary: 'AbacatePay payment webhook',
        description: 'Validates the shared secret, acknowledges with 202 and enqueues processing.',
        parameters: [
          {
            name: 'webhookSecret',
            in: 'query',
            required: true,
            schema: { type: 'string' },
          },
        ],
        responses: {
          '202': { description: 'Acknowledged' },
          '401': {
            description: 'Invalid webhook secret',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/Error' } } },
          },
        },
      },
    },
  },
  components: {
    schemas: {
      CreatePixRequest: {
        type: 'object',
        required: ['amount'],
        properties: {
          amount: { type: 'number', example: 25.9, description: 'Amount in currency units (BRL)' },
        },
      },
      Payment: {
        type: 'object',
        properties: {
          id: { type: 'string', format: 'uuid' },
          providerId: { type: 'string' },
          amount: { type: 'integer', description: 'Amount in cents' },
          status: {
            type: 'string',
            enum: ['PENDING', 'PAID', 'EXPIRED', 'CANCELLED', 'FAILED'],
          },
          brCode: { type: 'string' },
          description: { type: 'string' },
          createdAt: { type: 'string', format: 'date-time' },
          updatedAt: { type: 'string', format: 'date-time' },
        },
      },
      Error: {
        type: 'object',
        properties: {
          error: { type: 'boolean', example: true },
          message: { type: 'string' },
          details: {},
        },
      },
    },
  },
} as const;
