import { Router } from 'express';
import controllerOrder from '../controllers/controllerOrder.js';
import verifyAuth from '../middleware/verifyAuth.js';

const routerOrder = Router();
const order = new controllerOrder();

/**
 * @swagger
 * requests/orders:
 *   post:
 *     summary: Cria um novo pedido
 *     tags: [Pedido]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               customerId:
 *                 type: string
 *               items:
 *                 type: array
 *                 items:
 *                   type: object
 *                   properties:
 *                     productId:
 *                       type: string
 *                     quantity:
 *                       type: number
 *     responses:
 *       200:
 *         description: Pedido criado com sucesso
 *   get:
 *     summary: Lista todos os pedidos
 *     tags: [Pedido]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Lista de pedidos retornada com sucesso
 */

routerOrder.post('/orders', verifyAuth, order.createOrder);
routerOrder.get('/orders', verifyAuth, order.listOrders);
routerOrder.get('/orders/:id', verifyAuth, order.getOrderById);
routerOrder.get('/orders/customer/:customerId', verifyAuth, order.getOrdersByCustomer);
routerOrder.put('/orders/:id', verifyAuth, order.updateOrder);
routerOrder.patch('/orders/:id/status', verifyAuth, order.updateOrderStatus);
routerOrder.delete('/orders/:id', verifyAuth, order.deleteOrder);

export default routerOrder;