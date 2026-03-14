const mongoose = require('mongoose');
const dotenv = require('dotenv');

dotenv.config();

const connectDB = async () => {
    try {
        const mongoURI = process.env.MONGODB_URI;
        if (!mongoURI) {
            throw new Error('MONGODB_URI is not defined in .env');
        }
        const conn = await mongoose.connect(mongoURI, {
            maxPoolSize: 10,
            socketTimeoutMS: 45000,
        });
        console.log(`✓ MongoDB Connected: ${conn.connection.host}`);
        return conn;
    } catch (error) {
        console.error(`✗ MongoDB Connection Error: ${error.message}`);
        process.exit(1);
    }
};

module.exports = connectDB;
