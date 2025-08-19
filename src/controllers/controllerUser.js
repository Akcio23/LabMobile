import User from "../models/User.js";

class controllerUser {
    constructor() {
        this.getUser = this.getUser.bind(this)
    }
    async getUser(req, res) {
        const { email } = req.body;
        const user = await User.findOne({ email });
        if (!user) {
            return res.status(404).send({ message: "User not found" });
        }

        const { password, ...userWithoutPassword } = user.toObject();

        return res.status(200).send({ user: userWithoutPassword });
    }
}

export default controllerUser;