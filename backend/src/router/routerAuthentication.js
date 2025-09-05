import { Router } from "express";
import controllerAuthentication from "../controllers/controllerAuthentication.js";

const routerAuthentication = Router();

const signin = new controllerAuthentication();

routerAuthentication.post('/login', signin.login);

export default routerAuthentication;
