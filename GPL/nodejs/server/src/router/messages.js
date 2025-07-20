const express = require('express');
const router = express.Router();
const {
  getConversation,
  getAllConversations,
  sendMessage,
  getUserInfo
} = require('../controllers/messageController');

// Get conversation between user and admin
router.get('/conversation/:userId', getConversation);

// Get all conversations for admin
router.get('/conversations', getAllConversations);

// Send a message
router.post('/send', sendMessage);

// Get user info
router.get('/user/:userId', getUserInfo);

module.exports = router;
