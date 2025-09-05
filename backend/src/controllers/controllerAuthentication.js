import bcrypt from 'bcrypt'
import User from '../models/User.js';
import 'dotenv/config'
import jwt from 'jsonwebtoken'
class controllerAuthentication {
    login = async (req, res) => {
        const { email, password } = req.body;

        const user = await User.findOne({ email })

        if (!user) {
            return res.status(404).send({ message: "user not found" });
        }

        const isPasswordValid = await bcrypt.compare(password, user.password)

        if (!isPasswordValid) {
            return res.status(401).send({ message: "Invalid password" });
        }
        const token = await this.sessionToken(user)

        return res.status(200).send({
            message: "Login Successful",
            token
        })
    }

    async sessionToken(user) {

        const tokenData = {
            name: user.name,
            email: user.email
        }

        const tokenKey = process.env.KEY

        const tokenOptions = {
            subject: String(user._id),
            expiresIn: '2h',
        }

        const token = jwt.sign(tokenData, tokenKey, tokenOptions)

        return token
    }
}

export default controllerAuthentication