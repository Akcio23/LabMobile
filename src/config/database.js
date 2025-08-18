// filepath: c:\Users\Pedro PC\Desktop\faculdade\trab_mobile\src\config\database.js
import mongoose from 'mongoose'

const dbUrl = ''

console.log(dbUrl)

const conectDataBase = () => {
  mongoose.connect(dbUrl, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
    serverSelectionTimeoutMS: 10000,
  })
  .then(() => {
    console.log("✅ Conectado ao MongoDB Atlas");
  })
  .catch((err) => {
    console.error("❌ Erro de conexão:", err);
  });
}

export default conectDataBase