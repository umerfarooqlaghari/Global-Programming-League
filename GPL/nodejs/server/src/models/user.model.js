const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
  username: {
    type: String,
    required: true,
    unique: true,
  },
  password: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
    unique: true,
  },
  role: {
    type: String,
    enum: ['student', 'admin'],
    default: 'student',
  },
  profilePicture: {
    type: String,

  },
  picturePath: {
    type: String,
    default: '',
  },
  friends: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
    },
  ],
  aboutme: {
    type: String,
    default: 'Put your bio here',
  },
  githubLink: {
    type: String,
    default: '',
  },
  loggedOutAt: {
    type: Date, // Tracks the logout timestamp
    default: null,
  },
}, { timestamps: true });

const UserModel = mongoose.models.User || mongoose.model('User', UserSchema);
module.exports = UserModel;
