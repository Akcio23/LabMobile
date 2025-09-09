import { Router } from "express";
import controllerAuthentication from "../controllers/controllerAuthentication.js";

const routerAuthentication = Router();

const signin = new controllerAuthentication();

/**
 * @swagger
 * /login:
 *   post:
 *     summary: Autentica o usuário e retorna um token JWT
 *     tags: [Check-in]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               email:
 *                 type: string
 *               password:
 *                 type: string
 *     responses:
 *       200:
 *         description: Login bem-sucedido
 *       401:
 *         description: Senha inválida
 *       404:
 *         description: Usuário não encontrado
 */

routerAuthentication.post('/login', signin.login);

export default routerAuthentication;
