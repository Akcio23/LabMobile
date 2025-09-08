import mongoose from "mongoose";

const orderItemSchema = new mongoose.Schema({
    soleName: {
        type: String,
        required: [true, 'Nome da sola é obrigatório'],
        trim: true,
    },
    soleColor: {
        type: String,
        required: [true, 'Cor da sola é obrigatório'],
        trim: true,
    },
    unitPrice: {
        type: Number,
        required: [true, 'Preço unitário é obrigatório'],
        min: 0
    },
    sizes: {
        type: Map,
        of: Number,
        validate: {
            validator: function(sizes) {
                const validSizes = Array.from(sizes.keys()).every(size => {
                    const sizeNum = parseInt(size);
                    return sizeNum >= 33 && sizeNum <= 44;
                });

                const hasQuantity = Array.from(sizes.values()).some(qtd => qtd > 0);

                const noNegatives = Array.from(sizes.values()).every(qtd => qtd >= 0);

                return validSizes && hasQuantity && noNegatives;
            },
            message: 'Tamanhos devem estar entre 33-44 e ter pelo menos uma quantidade'
        }
    },
    subtotal: {
        type: Number,
        default: 0
    }
}, { _id: false });

orderItemSchema.virtual('totalQuantity').get(function() {
    if (!this.sizes) {
        return 0;
    }

    return Array.from(this.sizes.values()).reduce((sum, qtd) => sum + qtd, 0);
});

orderItemSchema.pre('save', function(next) {
    const total = Array.from(this.sizes.values()).reduce((sum, qtd) => sum + qtd, 0);
    this.subtotal = total * this.unitPrice;
    next();
});

const orderSchema = new mongoose.Schema({
    orderNumber: {
        type: Number,
        unique: true,
    },
    customer: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Customer',
        required: [true, 'Cliente é obrigatório']
    },
    status: {
        type: String,
        enum: ['pendente', 'em_producao', 'finalizado', 'entregue'],
        default: 'pendente',
    },
    items: {
        type: [orderItemSchema],
        validate: {
            validator: function(items) {
                return items.length >= 1 && items.length <= 5;
            },
            message: 'Pedido deve ter entre 1 e 5 itens'
        }
    },
    totalAmount: {
        type: Number,
        default: 0
    },
    observations: {
        type: String,
        trim: true
    }
}, { timestamps: true });

orderSchema.pre('save', async function(next) {
    if (this.isNew) {
        const lastOrder = await this.constructor.findOne({}, {}, { sort: { 'orderNumber': -1} });
        this.orderNumber = lastOrder ? lastOrder.orderNumber + 1 : 1;
    }

    this.totalAmount = this.items.reduce((sum, item) => sum + item.subtotal, 0);

    next();
})

orderSchema.set('toJSON', {
    virtuals: true,
    transform: function(doc, ret) {
        return {
            _id: ret._id,
            orderNumber: ret.orderNumber,
            customer: ret.customer,
            status: ret.status,
            items: ret.items,
            totalAmount: ret.totalAmount,
            observations: ret.observations,
            createdAt: ret.createdAt,
            updatedAt: ret.updatedAt
        };
    }
});

const Order = mongoose.model('Order', orderSchema);
export default Order;