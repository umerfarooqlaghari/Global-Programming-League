const express = require("express");

const { verifyToken } = require("../middleware/auth.js");
const { getUser, updateUser, updateUserProfile, uploadProfilePicture, removeProfilePicture } = require("../controllers/users.js");



const router = express.Router();

/** Read */

router.get('/user/:username', getUser);


/** PUT Methods */
router.put('/update-profile', uploadProfilePicture, updateUserProfile); // Add multer middleware
router.put('/remove-profile-picture', removeProfilePicture); // Remove profile picture
router.post('/updateuser',updateUser)
module.exports = router;

