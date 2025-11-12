import { Router } from "express";
import controllerCustomer from "../controllers/controllerCustomer.js";

const routerCustomer = Router();
const customer = new controllerCustomer();

/**
 * @swagger
 * components:
 *   schemas:
 *     Address:
 *       type: object
 *       required:
 *         - street
 *         - number
 *         - neighborhood
 *       properties:
 *         street:
 *           type: string
 *           example: Rua das Indústrias
 *         number:
 *           type: string
 *           example: "500"
 *         neighborhood:
 *           type: string
 *           example: Distrito Industrial
 * 
 *     Customer:
 *       type: object
 *       required:
 *         - name
 *         - cnpjCpf
 *         - address
 *       properties:
 *         _id:
 *           type: string
 *           description: ID único do cliente
 *         name:
 *           type: string
 *           example: Fábrica de Calçados ABC
 *         cnpjCpf:
 *           type: string
 *           example: 12345678000190
 *         address:
 *           $ref: '#/components/schemas/Address'
 *         phone:
 *           type: string
 *           example: (16) 99234-5678
 *         email:
 *           type: string
 *           format: email
 *           example: contato@fabricaabc.com
 *         createdAt:
 *           type: string
 *           format: date-time
 *         updatedAt:
 *           type: string
 *           format: date-time
 * 
 * @swagger
 * tags:
 *   name: Clientes
 *   description: Gerenciamento de clientes
 */

/**
 * @swagger
 * /customers:
 *   post:
 *     summary: Criar novo cliente
 *     tags: [Clientes]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - name
 *               - cnpjCpf
 *               - address
 *             properties:
 *               name:
 *                 type: string
 *               cnpjCpf:
 *                 type: string
 *               address:
 *                 $ref: '#/components/schemas/Address'
 *               phone:
 *                 type: string
 *               email:
 *                 type: string
 *     responses:
 *       201:
 *         description: Cliente criado com sucesso
 *       400:
 *         description: Erro de validação
 *       401:
 *         description: Não autorizado
 *       409:
 *         description: Cliente já existe
 */

/**
 * @swagger
 * /customers:
 *   get:
 *     summary: Listar todos os clientes
 *     tags: [Clientes]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Lista de clientes
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                 count:
 *                   type: number
 *                 customers:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/Customer'
 *       401:
 *         description: Não autorizado
 */

/**
 * @swagger
 * /customers/{id}:
 *   get:
 *     summary: Buscar cliente por ID
 *     tags: [Clientes]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: ID do cliente
 *     responses:
 *       200:
 *         description: Cliente encontrado
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Customer'
 *       400:
 *         description: ID inválido
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Cliente não encontrado
 */

/**
 * @swagger
 * /customers/{id}:
 *   put:
 *     summary: Atualizar cliente
 *     tags: [Clientes]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: ID do cliente
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *               cnpjCpf:
 *                 type: string
 *               address:
 *                 $ref: '#/components/schemas/Address'
 *               phone:
 *                 type: string
 *               email:
 *                 type: string
 *     responses:
 *       200:
 *         description: Cliente atualizado
 *       400:
 *         description: Erro de validação
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Cliente não encontrado
 *       409:
 *         description: CPF/CNPJ ou email já existe
 */

/**
 * @swagger
 * /customers/{id}:
 *   delete:
 *     summary: Deletar cliente
 *     tags: [Clientes]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: ID do cliente
 *     responses:
 *       200:
 *         description: Cliente deletado com sucesso
 *       400:
 *         description: Cliente possui pedidos ativos
 *       401:
 *         description: Não autorizado
 *       404:
 *         description: Cliente não encontrado
 */

routerCustomer.post('/customers', customer.createCustomer);
routerCustomer.get('/customers', customer.listCustomers);
routerCustomer.get('/customers/:id', customer.getCustomerById);
routerCustomer.put('/customers/:id', customer.updateCustomer);
routerCustomer.delete('/customers/:id', customer.deleteCustomer);

export default routerCustomer;