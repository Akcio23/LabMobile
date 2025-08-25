import 'dotenv/config';
import express from 'express';
import conectDataBase from './config/database.js';
import routerUser from './router/routerUser.js';
import routerRegister from './router/routerRegister.js';
import routerAuthentication from './router/routerAuthentication.js';
import routerCustomer from './router/routerCustomer.js';
import verifyAuth from './middleware/verifyAuth.js';

const app = express();
const PORT = process.env.PORT || 3000;


conectDataBase();

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }))

app.get('/', (req, res) => {
  res.json({
    message: 'API funcionando!',
    mongoose: 'Conectado com MongoDB via Mongoose'
  });
});


app.use('/', routerRegister);
app.use('/', routerAuthentication);

app.use('/', verifyAuth, routerUser);
app.use('/', verifyAuth, routerCustomer);

app.listen(PORT, () => {
  console.log(`Server ON ${PORT}`);
});
