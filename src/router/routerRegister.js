import { Router } from "express";

const routerRegister = Router();

routerRegister.post('/register', (req, res) => {
  const { email, password } = req.body;

  res.json({ message: 'Registro realizado com sucesso!' });
});

export default routerRegister;
