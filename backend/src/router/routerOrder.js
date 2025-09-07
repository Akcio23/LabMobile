import { Router } from 'express';
import controllerOrder from '../controllers/controllerOrder.js';
import verifyAuth from '../middleware/verifyAuth.js';

const routerOrder = Router();
const order = new controllerOrder();

routerOrder.post('/orders', verifyAuth, order.createOrder);
routerOrder.get('/orders', verifyAuth, order.listOrders);
routerOrder.get('/orders/:id', verifyAuth, order.getOrderById);
routerOrder.get('/orders/customer/:customerId', verifyAuth, order.getOrdersByCustomer);
routerOrder.put('/orders/:id', verifyAuth, order.updateOrder);
routerOrder.patch('/orders/:id/status', verifyAuth, order.updateOrderStatus);
routerOrder.delete('/orders/:id', verifyAuth, order.deleteOrder);

export default routerOrder;