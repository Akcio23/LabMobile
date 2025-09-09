import { Router } from "express";
import controllerCustomer from "../controllers/controllerCustomer.js";

const routerCustomer = Router();
const customer = new controllerCustomer();

/**
 * @swagger
 * /customers:
 *   post:
 *     summary: Cria um novo cliente
 *     tags: [Cliente]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *               email:
 *                 type: string
 *     responses:
 *       200:
 *         description: Cliente criado com sucesso
 *   get:
 *     summary: Lista todos os clientes
 *     tags: [Cliente]
 *     responses:
 *       200:
 *         description: Lista de clientes retornada com sucesso
 */

routerCustomer.post('/customers', customer.createCustomer);
routerCustomer.get('/customers', customer.listCustomers);
routerCustomer.get('/customers/:id', customer.getCustomerById);
routerCustomer.put('/customers/:id', customer.updateCustomer);
routerCustomer.delete('/customers/:id', customer.deleteCustomer);

export default routerCustomer;