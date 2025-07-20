const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');
const { Server } = require('socket.io');
const http = require('http');
const dotenv = require('dotenv'); // Environment variables
const router = require('./router/routes'); // Centralized routes file
const postRoutes = require('./router/posts'); // Post routes file
const userRoutes = require('./router/users'); // User routes file
const contestRoutes= require('./router/contest');
const pastpaperRoutes= require('./router/pastpaper');
const competitionsRoutes= require('./router/competitions');
const rankingsRoutes= require('./router/rankings');
const messageRoutes = require('./router/messages'); // Message routes
const Message = require('./models/message'); // Import Message model
// Initialize express app
const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"]
  }
});
dotenv.config({ path: './src/.env' }); // Load environment variables

const PORT = process.env.PORT || 5500; // Updated port

// MongoDB URI
const mongoUri =
  process.env.MONGO_URI || // Check for the environment variable
  'mongodb+srv://bscs2112188:anaskhan123@cluster0.xh9s5.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0'; // Fallback to your previous hardcoded URI

// Middleware
app.use(cors({
  origin: '*', // Allow all origins
  methods: ['GET', 'POST', 'PUT', 'DELETE','PATCH'], // Specify allowed methods
  allowedHeaders: ['Content-Type', 'Authorization'], // Allow Content-Type and Authorization headers
}));


app.use(express.json()); // Built-in body parser for JSON
app.use(bodyParser.urlencoded({ extended: true })); // Parse URL-encoded form data

// Serve static files for uploaded images
app.use('/uploads', express.static('uploads'));

// Routes
app.use('/api', router);
app.use('/api/users', userRoutes);
app.use('/api/posts', postRoutes);
app.use('/api/contest',contestRoutes);
app.use('/api/pastpaper',pastpaperRoutes);
app.use('/api/competitions',competitionsRoutes);
app.use('/api/rankings/',rankingsRoutes);
app.use('/api/messages', messageRoutes);


io.on('connection', (socket) => {
  console.log('User connected:', socket.id);

  // Join user room
  socket.on('join', (userId) => {
    socket.join(userId);
    console.log(`User ${userId} joined room: ${userId}`);
  });

  // Handle messages
  socket.on('sendMessage', async (data) => {
    try {
      // Save message to MongoDB
      const newMessage = new Message({
        senderId: data.senderId,
        receiverId: data.receiverId,
        message: data.message,
        isAdmin: data.isAdmin || false
      });
      await newMessage.save();

      // Emit to receiver's room
      if (data.receiverId === 'admin') {
        // Send to all admin connections
        io.to('admin').emit('receiveMessage', newMessage);
      } else {
        // Send to specific user
        io.to(data.receiverId).emit('receiveMessage', newMessage);
      }

      // Also emit back to sender for confirmation
      socket.emit('messageSent', newMessage);

      console.log(`Message sent from ${data.senderId} to ${data.receiverId}`);
    } catch (err) {
      console.error('Error sending message:', err);
      socket.emit('messageError', { error: 'Failed to send message' });
    }
  });

  // Join admin room for admin users
  socket.on('joinAdmin', () => {
    socket.join('admin');
    console.log('Admin joined admin room');
  });

  socket.on('disconnect', () => {
    console.log('User disconnected:', socket.id);
  });
});

// MongoDB Connection
mongoose
  .connect(mongoUri)
  .then(() => {
    console.log('Connected to Database');
    console.log('Database name:', mongoose.connection.db.databaseName);
    console.log('MongoDB URI:', mongoUri);
    server.listen(PORT, () => {
      console.log(`Server is running on port ${PORT}`);
    });
  })
  .catch((err) => {
    console.error('Connection Failed:', err);
  });
