import { Router } from 'express'
import controllerUser from '../controllers/controllerUser.js'

const routerUser = Router()
const user = new controllerUser();

routerUser.post('/user', user.getUser);

export default routerUser