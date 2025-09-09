import { Router } from "express";
import controllerRegister from "../controllers/controllerRegister.js";

/**
 * @swagger
 * /register:
 *   post:
 *     summary: Registra um novo usuário
 *     tags: [check-in]
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
 *               password:
 *                 type: string
 *     responses:
 *       200:
 *         description: Usuário registrado com sucesso
 *       409:
 *         description: Usuário já existe
 */

const routerRegister = Router();

const createUser = new controllerRegister();

routerRegister.post('/register', createUser.register);

export default routerRegister;
