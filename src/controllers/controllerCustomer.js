import Customer from '../models/Customer.js';

class controllerCustomer {
    constructor() {
        this.createCustomer = this.createCustomer.bind(this);
        this.checkCustomerExists = this.checkCustomerExists.bind(this);
    }

    async createCustomer(req, res) {
        try {
            const { name, cnpjCpf, address, phone, email } = req.body;

            const customerExists = await this.checkCustomerExists(cnpjCpf);
            if (customerExists) {
                return res.status(409).send({ message: 'Customer already exists' });
            }

            const customer = new Customer({ name, cnpjCpf, address, phone, email });
            await customer.save();

            return res.status(201).send({ message: 'Customer registered successfully' })
        } catch (err) {
            console.error('Error creating customer:', err)

            if (err.name === 'ValidationError') {
                return res.status(400).json({
                    message: 'Validation error',
                    datails: err.message
                });
            }

            return res.status(500).json({
                message: 'Error creating customer'
            });
        }
    }

    async checkCustomerExists(cnpjCpf) {
        const customer = await Customer.findOne({ cnpjCpf });
        if (!customer) {
            return false;
        }

        return true;
    }
}

export default controllerCustomer;