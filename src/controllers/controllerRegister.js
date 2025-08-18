class routerRegister {
    async register(req, res) {
        const { email, password } = req.body;

        return res.status(200).send({ data, token })

    }
}