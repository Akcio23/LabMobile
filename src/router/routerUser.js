import { Router } from 'express'

const routerUser = Router()


routerUser.get('/user', (req, res) => {
  res.json({ message: 'User route' });
});


export default routerUser