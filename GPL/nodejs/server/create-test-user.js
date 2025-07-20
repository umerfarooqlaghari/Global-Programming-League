const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const UserModel = require('./src/models/user.model');
require('dotenv').config({ path: './src/.env' });

// MongoDB URI from environment
const mongoUri = process.env.MONGO_URI || 
  'mongodb+srv://mumerfarooqlaghari:7VYu5MpW0TGS5uOU@cluster0.1smgsno.mongodb.net/gpl?retryWrites=true&w=majority&appName=Cluster0';

async function createTestUser() {
  try {
    // Connect to MongoDB
    await mongoose.connect(mongoUri);
    console.log('Connected to Database');

    // Check if user already exists
    const existingUser = await UserModel.findOne({ email: 'mumerfarooqlaghari@gmail.com' });
    if (existingUser) {
      console.log('User already exists with this email');
      await mongoose.disconnect();
      return;
    }

    // Hash the password
    const hashedPassword = bcrypt.hashSync('132Trent@!', 10);

    // Create the user
    const newUser = new UserModel({
      username: 'mumerfarooq',
      email: 'mumerfarooqlaghari@gmail.com',
      password: hashedPassword,
      role: 'student',
      githubLink: '',
      aboutme: 'Test user account',
      profilePicture: null,
      picturePath: '',
      friends: []
    });

    // Save the user
    await newUser.save();
    console.log('Test user created successfully!');
    console.log('Email: mumerfarooqlaghari@gmail.com');
    console.log('Password: 132Trent@!');
    console.log('Username: mumerfarooq');
    console.log('Role: student');

  } catch (error) {
    console.error('Error creating test user:', error);
  } finally {
    await mongoose.disconnect();
    console.log('Disconnected from database');
  }
}

// Run the script
createTestUser();
