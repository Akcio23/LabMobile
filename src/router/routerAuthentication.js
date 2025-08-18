import { Router } from "express";

const routerAuthentication = Router();

routerAuthentication.post('/login', (req, res) => {
  const { email, password } = req.body;

  res.json({ message: 'Login realizado com sucesso!' });
});

export default routerAuthentication;
