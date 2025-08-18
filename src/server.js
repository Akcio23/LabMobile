import 'dotenv/config';
import express from 'express';
import conectDataBase from './config/database.js';
import routerUser from './router/routerUser.js';
import routerRegister from './router/routerRegister.js';

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

app.use('/', routerUser);
app.use('/', routerRegister);

app.listen(PORT, () => {
  console.log(`Server ON ${PORT}`);
});
