import Customer from '../models/Customer.js';
import Order from '../models/Order.js';

class controllerCustomer {
    constructor() {
        this.createCustomer = this.createCustomer.bind(this);
        this.checkCustomerExists = this.checkCustomerExists.bind(this);
        this.listCustomers = this.listCustomers.bind(this);
        this.getCustomerById = this.getCustomerById.bind(this);
        this.updateCustomer = this.updateCustomer.bind(this);
        this.deleteCustomer = this.deleteCustomer.bind(this);
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

        } catch (error) {

            console.error('Error creating customer:', error)

            if (error.name === 'ValidationError') {
                return res.status(400).json({
                    message: 'Validation error',
                    datails: error.message
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

    async listCustomers(req, res) {
        try {

            const customers = await Customer.find()
                .select('name cnpjCpf address')
                .sort({ name: 1 });

            return res.status(200).json({
                message: 'Customers retrieved successfully',
                count: customers.length,
                customers: customers
            });

        } catch (error) {
            console.error('Error listing customers', error);

            return res.status(500).json({
                message: 'Error getting customers'
            });
        }
    }

    async getCustomerById(req, res) {
        try {

            const { id } = req.params;

            const customer = await Customer.findById(id);

            if (!customer) {
                return res.status(404).send({ message: 'Customer not found' })
            }

            return res.status(200).json(customer);

        } catch (error) {

            if (error.name === 'CastError') {
                return res.status(400).json({
                    message: 'Invalid ID format'
                });
            }

            console.error('Error getting customer', error);
            return res.status(500).json({
                message: 'Error getting customer'
            });
        }
    }

    async updateCustomer(req, res) {
        try {
            
            const { id } = req.params;
            const updateData = req.body;

            const customer = await Customer.findByIdAndUpdate(id, updateData, { new: true, runValidators: true });
            if (!customer) {
                return res.status(404).send({ message: 'Customer not found' });
            }

            return res.status(200).json(customer)
        } catch (error) {

            if (error.name === 'CastError') {
                return res.status(400).json({
                    message: 'Invalid ID format'
                });
            }

            if (error.code === 11000) {
                return res.status(409).json({
                    message: 'CPF/CNPJ or Email already exists'
                });
            }

            if (error.name === 'ValidationError') {
                return res.status(400).json({
                    message: 'Validation error',
                    details: error.message
                });
            }

            console.error('Error updating customer', error);
            return res.status(500).json({
                message: 'Error updating customer'
            });
        }
    }
    
    async deleteCustomer(req, res) {
        try {

            const { id } = req.params;

            const activeOrders = await Order.find({
                customer: id,
                status: { $in: ['pendente', 'em_producao'] }
            });

            if (activeOrders.length > 0) {
                return res.status(400).json({
                    message: 'Não é possível deletar cliente com pedidos pendentes ou em produção',
                    activeOrders: activeOrders.length
                });
            }

            const customer = await Customer.findByIdAndDelete(id);

            if (!customer) {
                return res.status(404).json({ message: 'Customer not found'});
            }

            return res.status(200).json({
                message: 'Customer deleted successfully'
            })

        } catch (error) {
            
            if (error.name === 'CastError') {
                return res.status(400).json({
                    message: 'Invalid ID format'
                });
            }

            console.error('Error deleting customer', error);
            return res.status(500).json({
                message: 'Error deleting customer'
            });
        }
    }
}

export default controllerCustomer;