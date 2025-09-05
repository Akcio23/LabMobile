import { Router } from "express";
import controllerCustomer from "../controllers/controllerCustomer.js";

const routerCustomer = Router();
const customer = new controllerCustomer();

routerCustomer.post('/customers', customer.createCustomer);
routerCustomer.get('/customers', customer.listCustomers);
routerCustomer.get('/customers/:id', customer.getCustomerById);
routerCustomer.put('/customers/:id', customer.updateCustomer);
routerCustomer.delete('/customers/:id', customer.deleteCustomer);

export default routerCustomer;