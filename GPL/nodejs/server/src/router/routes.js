const express = require('express');
const controller = require('../controllers/appController.js');
const { verifyToken } = require('../middleware/auth.js');

// Ensure you import the update functions

const router = express.Router();

/** POST Methods */
router.post('/register', controller.register);
router.post('/login', controller.login);
router.post('/verify-otp', controller.verifyOtp);
router.post('/logout', controller.logout); // Added logout route
router.post('/forgot-password', controller.forgotPassword);
router.post('/reset-password', controller.resetPassword);




module.exports = router;
