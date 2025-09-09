import { Router } from 'express'
import controllerUser from '../controllers/controllerUser.js'

const routerUser = Router()
const user = new controllerUser();

/**
 * @swagger
 * /search:
 *   post:
 *     summary: Retorna os dados do usuário (exceto a senha)
 *     tags: [Usuário]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               email:
 *                 type: string
 *     responses:
 *       200:
 *         description: Dados do usuário retornados com sucesso
 *       404:
 *         description: Usuário não encontrado
 *       401:
 *         description: Token inválido ou ausente
 */

routerUser.post('/search', user.getUser);

export default routerUser