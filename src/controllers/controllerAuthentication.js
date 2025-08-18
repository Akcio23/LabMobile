class routerAuthentication {
    async login(req, res) {
        const { email, password } = req.body;
       
        res.json({ message: 'Login realizado com sucesso!' });
    }
}