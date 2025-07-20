const Message = require('../models/message');
const UserModel = require('../models/user.model');

// Get conversation between user and admin
const getConversation = async (req, res) => {
  try {
    const { userId } = req.params;
    
    const messages = await Message.find({
      $or: [
        { senderId: userId, receiverId: 'admin' },
        { senderId: 'admin', receiverId: userId }
      ]
    }).sort({ timestamp: 1 });

    res.status(200).json(messages);
  } catch (error) {
    console.error('Error fetching conversation:', error);
    res.status(500).json({ error: 'Failed to fetch conversation' });
  }
};

// Get all conversations for admin
const getAllConversations = async (req, res) => {
  try {
    // Get all unique user IDs who have sent messages
    const conversations = await Message.aggregate([
      {
        $match: {
          $or: [
            { receiverId: 'admin' },
            { senderId: 'admin' }
          ]
        }
      },
      {
        $group: {
          _id: {
            $cond: [
              { $eq: ['$senderId', 'admin'] },
              '$receiverId',
              '$senderId'
            ]
          },
          lastMessage: { $last: '$message' },
          lastTimestamp: { $last: '$timestamp' },
          messageCount: { $sum: 1 }
        }
      },
      {
        $lookup: {
          from: 'users',
          localField: '_id',
          foreignField: '_id',
          as: 'userInfo'
        }
      },
      {
        $project: {
          userId: '$_id',
          lastMessage: 1,
          lastTimestamp: 1,
          messageCount: 1,
          username: { $arrayElemAt: ['$userInfo.username', 0] },
          email: { $arrayElemAt: ['$userInfo.email', 0] }
        }
      },
      {
        $sort: { lastTimestamp: -1 }
      }
    ]);

    res.status(200).json(conversations);
  } catch (error) {
    console.error('Error fetching conversations:', error);
    res.status(500).json({ error: 'Failed to fetch conversations' });
  }
};

// Send a message
const sendMessage = async (req, res) => {
  try {
    const { senderId, receiverId, message, isAdmin } = req.body;

    const newMessage = new Message({
      senderId,
      receiverId,
      message,
      isAdmin: isAdmin || false
    });

    await newMessage.save();
    res.status(201).json(newMessage);
  } catch (error) {
    console.error('Error sending message:', error);
    res.status(500).json({ error: 'Failed to send message' });
  }
};

// Get user info by ID
const getUserInfo = async (req, res) => {
  try {
    const { userId } = req.params;
    const user = await UserModel.findById(userId).select('username email role');
    
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.status(200).json(user);
  } catch (error) {
    console.error('Error fetching user info:', error);
    res.status(500).json({ error: 'Failed to fetch user info' });
  }
};

module.exports = {
  getConversation,
  getAllConversations,
  sendMessage,
  getUserInfo
};
