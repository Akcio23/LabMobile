import { Router } from "express";
import controllerRegister from "../controllers/controllerRegister.js";

const routerRegister = Router();

const createUser = new controllerRegister();

routerRegister.post('/register', createUser.register);

export default routerRegister;
