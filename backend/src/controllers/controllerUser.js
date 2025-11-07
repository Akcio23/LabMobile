import User from "../models/User.js";
import bcrypt from "bcrypt";

class controllerUser {
  constructor() {
    this.getUser = this.getUser.bind(this);
    this.resetPassword = this.resetPassword.bind(this);
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

  async resetPassword(req, res) {
    const { email, password, newPassword } = req.body;

    const foundUser = await this.checkUser(email);

    if (!foundUser) {
      return res.status(404).send({ message: "User not found" });
    }

    const verifyPassword = await bcrypt.compare(password, foundUser.password);

    if (!verifyPassword) {
      return res.status(400).send({ message: "password not match" });
    }

    const hashedPassword = await bcrypt.hash(newPassword, 10)

    await User.updateOne({ email }, { $set: { password: hashedPassword } });

    return res.status(200).send({ message: "Password updated successfully" });
  }

  async checkUser(email) {
    const user = await User.findOne({ email });
    return user;
  }
}

export default controllerUser;
