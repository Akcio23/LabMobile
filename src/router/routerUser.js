import { Router } from 'express'
import controllerUser from '../controllers/controllerUser.js'

const routerUser = Router()
const user = new controllerUser();

routerUser.get('/user', user.getUser);

export default routerUser