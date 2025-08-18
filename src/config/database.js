import mongoose from 'mongoose'
import 'dotenv/config'

const dbUrl = process.env.URI_BD

const conectDataBase = () => {
  mongoose.connect(dbUrl)
  .then(() => {
    console.log("✅ connected to MongoDB");
  })
  .catch((err) => {
    console.error("❌ Error connecting:", err);
  });
}

export default conectDataBase