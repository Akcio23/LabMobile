import mongoose from 'mongoose';

const customerSchema = new mongoose.Schema({
    name: {
        type: String,
        required: [true, 'Name is required'],
        trim: true
    },
    cnpjCpf: {
        type: String,
        required: [true, 'CPF/CNPJ is required'],
        unique: true,
        trim: true,
        validate: {
            validator: function(v) {
                const numbers = v.replace(/\D/g, '');
                return numbers.length === 11 || numbers.length === 14;
            },
            message: 'CPF must have 11 digits or CNPJ must have 14 digits'
        }
    },
    address: {
        street: { type: String, required: true, trim: true},
        number: { type: String, required: true, trim: true},
        neighborhood: { type: String, required: true, trim: true},
        city: { type: String, required: true, trim: true},
        state: { type: String, required: true, trim: true},
        zipCode: { type: String, required: true, trim: true}
    },
    phone: {
        type: String,
        trim: true,
        match: [/^\(\d{2}\) \d{4,5}-\d{4}$/, 'Invalid phone format'],
    },
    email: {
        type: String,
        unique: true,
        sparse: true,
        lowercase: true,
        trim: true,
        match: [/^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$/, 'Invalid email format'],
    }
}, {timestamps: true});

customerSchema.set('toJSON', {
    transform: function(doc, ret) {
        return {
            _id: ret._id,
            name: ret.name,
            cnpjCpf: ret.cnpjCpf,
            address: ret.address,
            phone: ret.phone,
            email: ret.email,
            createdAt: ret.createdAt,
            updatedAt: ret.updatedAt,
        }
    },
    versionKey: false
});

const Customer = mongoose.model('Customer', customerSchema);
export default Customer;