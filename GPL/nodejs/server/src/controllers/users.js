const UserModel = require('../models/user.model');
const multer = require('multer');
const path = require('path');
const fs = require('fs');

// Configure multer for file uploads
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    const uploadPath = 'uploads/profile-pictures/';
    // Create directory if it doesn't exist
    if (!fs.existsSync(uploadPath)) {
      fs.mkdirSync(uploadPath, { recursive: true });
    }
    cb(null, uploadPath);
  },
  filename: function (req, file, cb) {
    // Generate unique filename
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, 'profile-' + uniqueSuffix + path.extname(file.originalname));
  }
});

const upload = multer({
  storage: storage,
  limits: {
    fileSize: 5 * 1024 * 1024 // 5MB limit
  },
  fileFilter: function (req, file, cb) {
    // Check file type
    if (file.mimetype.startsWith('image/')) {
      cb(null, true);
    } else {
      cb(new Error('Only image files are allowed!'), false);
    }
  }
});


exports.updateUser = async function (req, res) {
  try {
    const { aboutMe } = req.body;

    console.log('Update user request body:', req.body);
    console.log('Update user headers:', req.headers);

    if (!aboutMe && aboutMe !== '') {
      return res.status(400).json({ error: 'About Me is required' });
    }

    const userId = req.headers.authorization; // Get user ID from Authorization header
    console.log('User ID from authorization:', userId);

    if (!userId) {
      return res.status(401).json({ error: 'User ID is required' });
    }

    const user = await UserModel.findById(userId);
    console.log('Found user:', user ? 'Yes' : 'No');

    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    user.aboutme = aboutMe;
    await user.save();

    console.log('User updated successfully');
    res.status(200).json({
      success: true,
      message: 'Profile updated successfully',
      aboutMe: aboutMe
    });
  } catch (e) {
    console.error("Failed to update user:", e);
    res.status(500).json({ error: 'Error updating user: ' + e.message });
  }
};






//* PUT localhost:8000/api/updateUserProfile

exports.updateUserProfile = async function (req, res) {
  try {
    const userId = req.headers.authorization || req.body.userId;

    console.log('Profile picture upload request');
    console.log('User ID:', userId);
    console.log('Request body:', req.body);
    console.log('Uploaded file:', req.file);

    if (!userId) {
      return res.status(401).json({ error: 'User ID is required' });
    }

    if (!req.file) {
      return res.status(400).json({ error: 'No file uploaded' });
    }

    // Find the user first to delete old profile picture if exists
    const user = await UserModel.findById(userId);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    // Delete old profile picture file if exists
    if (user.profilePicture) {
      const oldFilePath = path.join(__dirname, '../../', user.profilePicture);
      if (fs.existsSync(oldFilePath)) {
        try {
          fs.unlinkSync(oldFilePath);
          console.log('Old profile picture deleted:', oldFilePath);
        } catch (err) {
          console.error('Error deleting old file:', err);
        }
      }
    }

    // Create the file URL
    const profilePictureUrl = `/uploads/profile-pictures/${req.file.filename}`;

    console.log('New profile picture URL:', profilePictureUrl);

    // Update user with new profile picture
    const updatedUser = await UserModel.findByIdAndUpdate(
      userId,
      { profilePicture: profilePictureUrl },
      { new: true } // Return the updated document
    );

    console.log('Profile picture updated successfully');
    res.status(200).json({
      success: true,
      message: 'Profile picture updated successfully',
      user: {
        _id: updatedUser._id,
        username: updatedUser.username,
        email: updatedUser.email,
        profilePicture: updatedUser.profilePicture
      },
      profilePictureUrl: profilePictureUrl
    });
  } catch (error) {
    console.error('Error updating profile picture:', error);
    res.status(500).json({ error: 'Internal server error: ' + error.message });
  }
};

// Export the multer upload middleware
exports.uploadProfilePicture = upload.single('profilePicture');

// Remove profile picture
exports.removeProfilePicture = async function (req, res) {
  try {
    const userId = req.headers.authorization || req.body.userId;

    console.log('Remove profile picture request');
    console.log('User ID:', userId);
    console.log('Request body:', req.body);

    if (!userId) {
      return res.status(401).json({ error: 'User ID is required' });
    }

    const user = await UserModel.findById(userId);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    console.log('Current profile picture:', user.profilePicture);

    // If user has a profile picture, try to delete the file
    if (user.profilePicture) {
      const filePath = path.join(__dirname, '../../', user.profilePicture);
      console.log('Attempting to delete file:', filePath);

      if (fs.existsSync(filePath)) {
        try {
          fs.unlinkSync(filePath);
          console.log('Profile picture file deleted successfully');
        } catch (err) {
          console.error('Error deleting file:', err);
        }
      } else {
        console.log('File does not exist:', filePath);
      }
    }

    // Update user to remove profile picture from database
    const updatedUser = await UserModel.findByIdAndUpdate(
      userId,
      { profilePicture: null },
      { new: true }
    );

    console.log('Profile picture removed from database successfully');
    res.status(200).json({
      success: true,
      message: 'Profile picture removed successfully',
      user: {
        _id: updatedUser._id,
        username: updatedUser.username,
        email: updatedUser.email,
        profilePicture: updatedUser.profilePicture
      }
    });
  } catch (error) {
    console.error('Error removing profile picture:', error);
    res.status(500).json({ error: 'Internal server error: ' + error.message });
  }
};



/** Get User Function */
exports.getUser = async (req, res) => {
  try {
    const { username } = req.params;

    if (!username) return res.status(400).json({ error: 'No username provided' });

    const user = await UserModel.findOne({ username }).exec();
    if (!user) return res.status(404).json({ error: 'No such user exists' });

    const { password, ...rest } = Object.assign({}, user.toJSON());
    res.status(200).json(rest);
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Unable to fetch user' });
  }
};

