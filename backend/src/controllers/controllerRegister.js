import User from "../models/User.js";
import bcrypt from 'bcrypt'
class controllerRegister {

    constructor() {
        this.register = this.register.bind(this);
        this.checkUser = this.checkUser.bind(this);
    }

    async register(req, res) {
        const { name, email, password } = req.body;

        const userExists = await this.checkUser(req);
        if (!userExists) {
            return res.status(409).send({ message: "User already exists" });
        }

        const hashedPassword = await bcrypt.hash(password, 10)

        const user = new User({ name, email, password:hashedPassword });
        await user.save();

        return res.status(200).send({ message: "User registered successfully" });
    }

    async checkUser(req) {
        const { email } = req.body;

        const user = await User.findOne({ email });
        if (!user) {
            return  true
        }

        return false
    }
}

export default controllerRegister;