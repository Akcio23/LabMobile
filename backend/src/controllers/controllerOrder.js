import Order from '../models/Order.js';
import Customer from '../models/Customer.js';

class controllerOrder {
    constructor() {
        this.createOrder = this.createOrder.bind(this);
        this.listOrders = this.listOrders.bind(this);
        this.getOrderById = this.getOrderById.bind(this);
        this.getOrdersByCustomer = this.getOrdersByCustomer.bind(this);
        this.updateOrderStatus = this.updateOrderStatus.bind(this);
        this.updateOrder = this.updateOrder.bind(this);
        this.deleteOrder = this.deleteOrder.bind(this);
    }

    async createOrder(req, res) {
        try {
            const { customer, items, observations } = req.body;

            const customerExists = await Customer.findById(customer);
            if (!customerExists) {
                return res.status(404).json({ message: 'Cliente não encontrado' });
            }

            const processedItems = items.map(item => ({
                soleName: item.soleName,
                soleColor: item.soleColor,
                unitPrice: item.unitPrice,
                sizes: new Map(Object.entries(item.sizes))
            }));

            const order = new Order({
                customer: customer,
                items: processedItems,
                observations: observations
            });

            await order.save();

            const orderWithCustomer = await Order.findById(order._id)
                .populate('customer', 'name cnpjCpf');

            return res.status(201).json({
                message: 'Pedido criado com sucesso',
                order: orderWithCustomer
            });

        } catch (error) {
            console.error('Erro ao criar pedido:', error);

            if (error.name === 'ValidationError') {
                return res.status(404).json({
                    message: 'Erro de validação',
                    details: error.message
                });
            }

            return res.status(500).json({
                message: 'Erro ao criar pedido'
            });
        }
    }

    async listOrders(req, res) {
        try {
            const orders = await Order.find()
                .populate('customer', 'name cnpjCpf')
                .sort({ orderNumber: -1 });

            return res.status(200).json({
                message: 'Pedidos recuperados com sucesso',
                count: orders.length,
                orders: orders
            });

        } catch (error) {
            console.error('Erro ao listar pedidos:', error);
            return res.status(500).json({
                message: 'Erro ao listar pedidos'
            });
        }
    }

    async getOrderById(req, res) {
        try {
            const { id } = req.params;

            const order = await Order.findById(id)
                .populate('customer');

            if (!order) {
                return res.status(404).json({
                    message: 'Pedido não encontrado'
                });
            }

            return res.status(200).json(order);

        } catch (error) {
            if (error.name === 'CastError') {
                return res.status(400).json({
                    message: 'ID de pedido inválido'
                });
            }

            console.error('Erro ao buscar pedido:', error);
            return res.status(500).json({
                message: 'Erro ao buscar pedido'
            });
        }
    }

    async getOrdersByCustomer(req, res) {
        try {
            const { customerId } = req.params;

            const customerExists = await Customer.findById(customerId);
            if (!customerExists) {
                return res.status(404).json({
                    message: 'Cliente não encontrado'
                });
            }

            const orders = await Order.find({ customer: customerId })
                .populate('customer', 'name cnpjCpf')
                .sort({ orderNumber: -1 });

            return res.status(200).json({
                message: `Pedidos do cliente ${customerExists.name}`,
                count: orders.length,
                orders: orders
            });

        } catch (error) {
            if (error.name === 'CastError') {
                return res.status(400).json({
                    message: 'ID de cliente inválido'
                });
            }

            console.error('Erro ao buscar pedidos do cliente:', error);
            return res.status(500).json({
                message: 'Erro ao buscar pedidos do cliente'
            });
        }
    }

    async updateOrderStatus(req, res) {
        try {
            const { id } = req.params;
            const { status } = req.body;

            const validStatus = ['pendente', 'em_producao', 'finalizado', 'entregue'];
            if (!validStatus.includes(status)) {
                return res.status(400).json({
                    message: 'Status inválido. Use: pendente, em_producao, finalizado ou entregue'
                });
            }

            const order = await Order.findByIdAndUpdate(
                id,
                { status: status },
                { new: true, runValidators: true }
            ).populate('customer', 'name cnpjCpf');

            if (!order) {
                return res.status(404).json({
                    message: 'Pedido não encontrado'
                });
            }

            return res.status(200).json({
                message: 'Status atualizado com sucesso',
                order: order
            });

        } catch (error) {
            if (error.name === 'CastError') {
                return res.status(400).json({
                    message: 'ID de pedido inválido'
                });
            }

            console.error('Erro ao atualizar status:', error);
            return res.status(500).json({
                message: 'Erro ao atualizar status do pedido'
            });
        }
    }

    async updateOrder(req, res) {
        try {
            const { id } = req.params;
            const { items, observations } = req.body;

            const existingOrder = await Order.findById(id);
            if (!existingOrder) {
                return res.status(404).json({
                    message: 'Pedido não encontrado'
                });
            }

            if (existingOrder.status === 'finalizado' || existingOrder.status === 'entregue') {
                return res.status(400).json({
                    message: 'Não é possível editar pedidos finalizados ou entregues'
                });
            }

            if (items) {
                const processedItems = items.map(item => ({
                    soleName: item.soleName,
                    soleColor: item.soleColor,
                    unitPrice: item.unitPrice,
                    sizes: new Map(Object.entries(item.sizes))
                }));
                existingOrder.items = processedItems;
            }

            if (observations !== undefined) {
                existingOrder.observations = observations;
            }

            await existingOrder.save();

            const updatedOrder = await Order.findById(id)
                .populate('customer', 'name cnpjCpf');

            return res.status(200).json({
                message: 'Pedido atualizado com sucesso',
                order: updatedOrder
            });

        } catch (error) {
            if (error.name === 'CastError') {
                return res.status(400).json({
                    message: 'ID de pedido inválido'
                });
            }

            if (error.name === 'ValidationError') {
                return res.status(400).json({
                    message: 'Erro de validação',
                    details: error.message
                });
            }

            console.error('Erro ao atualizar pedido:', error);
            return res.status(500).json({
                message: 'Erro ao atualizar pedido'
            });
        }
    }

    async deleteOrder(req, res) {
        try {
            const { id } = req.params;

            const order = await Order.findById(id);
            if (!order) {
                return res.status(404).json({
                    message: 'Pedido não encontrado'
                });
            }

            if (order.status !== 'pendente') {
                return res.status(400).json({
                    message: 'Apenas pedidos pendentes podem ser deletados'
                });
            }

            await Order.findByIdAndDelete(id);

            return res.status(200).json({
                message: 'Pedido deletado com sucesso',
                orderNumber: order.orderNumber
            });

        } catch (error) {
            if (error.name === 'CastError') {
                return res.status(400).json({
                    message: 'ID de pedido inválido'
                });
            }

            console.error('Erro ao deletar pedido:', error);
            return res.status(500).json({
                message: 'Erro ao deletar pedido'
            });
        }
    }
}

export default controllerOrder