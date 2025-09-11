import { Router } from 'express';
import controllerOrder from '../controllers/controllerOrder.js';
import verifyAuth from '../middleware/verifyAuth.js';

const routerOrder = Router();
const order = new controllerOrder();

/**
 * @swagger
 * components:
 *   schemas:
 *     OrderItem:
 *       type: object
 *       required:
 *         - soleName
 *         - soleColor
 *         - unitPrice
 *         - sizes
 *       properties:
 *         soleName:
 *           type: string
 *           example: Sola Premium
 *         soleColor:
 *           type: string
 *           example: Preto
 *         unitPrice:
 *           type: number
 *           example: 15.50
 *         sizes:
 *           type: object
 *           additionalProperties:
 *             type: number
 *           example:
 *             "35": 10
 *             "36": 15
 *             "37": 20
 *         totalQuantity:
 *           type: number
 *           example: 45
 *         subtotal:
 *           type: number
 *           example: 697.50
 * 
 *     Order:
 *       type: object
 *       required:
 *         - customer
 *         - items
 *       properties:
 *         _id:
 *           type: string
 *         orderNumber:
 *           type: number
 *           example: 1
 *         customer:
 *           type: string
 *           description: ID do cliente
 *         status:
 *           type: string
 *           enum: [pendente, em_producao, finalizado, entregue]
 *           default: pendente
 *         items:
 *           type: array
 *           minItems: 1
 *           maxItems: 5
 *           items:
 *             $ref: '#/components/schemas/OrderItem'
 *         totalAmount:
 *           type: number
 *           example: 697.50
 *         observations:
 *           type: string
 *           example: Entrega urgente
 *         createdAt:
 *           type: string
 *           format: date-time
 *         updatedAt:
 *           type: string
 *           format: date-time
 * 
 * @swagger
 * tags:
 *   name: Pedidos
 *   description: Gerenciamento de pedidos
 */

/**
 * @swagger
 * /orders:
 *   post:
 *     summary: Criar novo pedido
 *     tags: [Pedidos]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - customer
 *               - items
 *             properties:
 *               customer:
 *                 type: string
 *                 description: ID do cliente
 *               items:
 *                 type: array
 *                 minItems: 1
 *                 maxItems: 5
 *                 items:
 *                   $ref: '#/components/schemas/OrderItem'
 *               observations:
 *                 type: string
 *     responses:
 *       201:
 *         description: Pedido criado com sucesso
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                 order:
 *                   $ref: '#/components/schemas/Order'
 *       400:
 *         description: Erro de validação
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Cliente não encontrado
 */

/**
 * @swagger
 * /orders:
 *   get:
 *     summary: Listar todos os pedidos
 *     tags: [Pedidos]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Lista de pedidos
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                 count:
 *                   type: number
 *                 orders:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/Order'
 *       401:
 *         description: Não autorizado
 */

/**
 * @swagger
 * /orders/{id}:
 *   get:
 *     summary: Buscar pedido por ID
 *     tags: [Pedidos]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: ID do pedido
 *     responses:
 *       200:
 *         description: Pedido encontrado
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Order'
 *       400:
 *         description: ID inválido
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Pedido não encontrado
 */

/**
 * @swagger
 * /orders/customer/{customerId}:
 *   get:
 *     summary: Buscar pedidos de um cliente
 *     tags: [Pedidos]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: customerId
 *         required: true
 *         schema:
 *           type: string
 *         description: ID do cliente
 *     responses:
 *       200:
 *         description: Pedidos do cliente
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                 count:
 *                   type: number
 *                 orders:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/Order'
 *       400:
 *         description: ID inválido
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Cliente não encontrado
 */

/**
 * @swagger
 * /orders/{id}:
 *   put:
 *     summary: Atualizar pedido
 *     tags: [Pedidos]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: ID do pedido
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               items:
 *                 type: array
 *                 items:
 *                   $ref: '#/components/schemas/OrderItem'
 *               observations:
 *                 type: string
 *     responses:
 *       200:
 *         description: Pedido atualizado
 *       400:
 *         description: Pedido finalizado/entregue não pode ser editado
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Pedido não encontrado
 */

/**
 * @swagger
 * /orders/{id}/status:
 *   patch:
 *     summary: Atualizar status do pedido
 *     tags: [Pedidos]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: ID do pedido
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - status
 *             properties:
 *               status:
 *                 type: string
 *                 enum: [pendente, em_producao, finalizado, entregue]
 *     responses:
 *       200:
 *         description: Status atualizado
 *       400:
 *         description: Status inválido
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Pedido não encontrado
 */

/**
 * @swagger
 * /orders/{id}:
 *   delete:
 *     summary: Deletar pedido
 *     tags: [Pedidos]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: ID do pedido
 *     responses:
 *       200:
 *         description: Pedido deletado
 *       400:
 *         description: Apenas pedidos pendentes podem ser deletados
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Pedido não encontrado
 */

routerOrder.post('/orders', verifyAuth, order.createOrder);
routerOrder.get('/orders', verifyAuth, order.listOrders);
routerOrder.get('/orders/:id', verifyAuth, order.getOrderById);
routerOrder.get('/orders/customer/:customerId', verifyAuth, order.getOrdersByCustomer);
routerOrder.put('/orders/:id', verifyAuth, order.updateOrder);
routerOrder.patch('/orders/:id/status', verifyAuth, order.updateOrderStatus);
routerOrder.delete('/orders/:id', verifyAuth, order.deleteOrder);

export default routerOrder;