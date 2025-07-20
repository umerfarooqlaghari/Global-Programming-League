const UserModel = require('../models/user.model');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const nodemailer = require('nodemailer');
const otpGenerator = require('otp-generator');
const otpStore = new Map(); // Temporary OTP storage

/** Helper function to create JWT */
const createToken = (user) => {
  return jwt.sign(
    { id: user._id, username: user.username, role: user.role },
    process.env.JWT_SECRET,
    { expiresIn: process.env.JWT_EXPIRES_IN || '1h' } // Configurable expiration
  );
};

/** POST * //localhost:8000/api/register  */
exports.register = async (req, res) => {
  try {
    const {
      username,
      password,
      confirmPass,
      email,
      role = 'student',
      profile = '',
      picturePath = '',
      friends = [],
      githubLink = '',
    } = req.body;



    const existUsername = await UserModel.findOne({ username }).exec();
    const existEmail = await UserModel.findOne({ email }).exec();

    if (existUsername) return res.status(400).json({ error: 'Username already taken' });
    if (existEmail) return res.status(400).json({ error: 'Email already registered' });
    if (password !== confirmPass) return res.status(400).json({ error: 'Passwords do not match' });

    const otp = otpGenerator.generate(6, { upperCaseAlphabets: false, specialChars: false });
    const expiresAt = Date.now() + 60 * 10000; // OTP expires in 10 minute
    otpStore.set(email, { otp, expiresAt });

    await sendOtpEmail(email, otp);

    res.status(200).json({ message: 'OTP sent to your email. Please verify to complete registration.' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Unable to process registration' });
  }
};

/** Verify OTP and register user */
exports.verifyOtp = async (req, res) => {

  console.log('HELLO VERIFY OTP');

  const { email, otp, username, password, githubLink, role } = req.body;
  console.log(req.body);
  const storedOtp = otpStore.get(email);
  if (!storedOtp || storedOtp.otp !== otp || Date.now() > storedOtp.expiresAt) {
    console.log('OTP Verified');
    return res.status(400).send({ error: 'Invalid or expired OTP' });
  }

  // Create user after OTP verification
  const hashedPassword = bcrypt.hashSync(password, 10);
  const newUser = new UserModel({
    username,
    email,
    password: hashedPassword,
    githubLink,
    role,
    // Add other fields as needed
  });

  try {
    await newUser.save(); // Save the user to the database
    res.status(200).json({ message: 'User registered successfully' });
  } catch (error) {
    console.error('Error during user creation:', error);
    res.status(500).json({ error: 'Registration failed' });
  }

  // Remove OTP from the store after successful verification
  otpStore.delete(email);
};

/** POST  * //localhost:8000/api/login  */
exports.login = async (req, res) => {
  try {
    console.log('Login request received:', req.body);
    const { username, password } = req.body;

    console.log('Looking for user with username:', username);
    // Check if user exists
    const user = await UserModel.findOne({ username }).exec();
    console.log('User found:', !!user);

    if (!user) {
      console.log('No user found with username:', username);
      return res.status(400).send({ error: 'Incorrect username or password' });
    }

    console.log('User found, checking password...');
    // Validate password using bcryptjs
    const passwordMatch = bcrypt.compareSync(password, user.password);
    console.log('Password match:', passwordMatch);

    if (!passwordMatch) {
      console.log('Password does not match');
      return res.status(400).send({ error: 'Incorrect username or password' });
    }

    console.log('Login successful for user:', user.username);
    res.status(200).json({
      username: user.username,
      email: user.email,
      role: user.role,
      userId: user._id
    });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).send({ error: 'Unable to login' });
  }
};



// * localhost:8000/api/logout */r

exports.logout = async (req, res) => {
  try {
    const userId = req.user.id; // Extract user ID from the verified token

    // Update the user or perform any logout-specific actions
    const user = await UserModel.findById(userId).exec();
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    // Optionally, set a loggedOutAt timestamp
    user.loggedOutAt = new Date();
    await user.save();

    res.status(200).json({ message: 'Logout successful' });
  } catch (error) {
    console.error('Error during logout:', error);
    res.status(500).json({ error: 'Unable to logout' });
  }
};

// Forgot Password (Send OTP)
exports.forgotPassword = async (req, res) => {
  try {
    const { email } = req.body;

    if (!email) return res.status(400).json({ error: 'Email is required' });

    // Check if user exists
    const user = await UserModel.findOne({ email }).exec();
    if (!user) return res.status(404).json({ error: 'User not found' });

    // Generate OTP
    const otp = otpGenerator.generate(6, { upperCaseAlphabets: false, specialChars: false });
    const expiresAt = Date.now() + 15 * 60 * 1000; // OTP expires in 15 minutes

    // Store OTP in temporary storage (otpStore)
    otpStore.set(email, { otp, expiresAt });

    // Send OTP via email
    await sendOtpEmail(email, otp);

    res.status(200).json({ message: 'OTP sent to your email' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Unable to process request' });
  }
};

// Send OTP Email Function
async function sendOtpEmail(email, otp) {
  const transporter = nodemailer.createTransport({
    service: 'Gmail',
    auth: {
      user: 'ak1096561@gmail.com', // Replace with your email
      pass: 'emhrwhhatllhjegv', // Replace with your email password or app password
    },
  });

  const mailOptions = {
    from: 'ak1096561@gmail.com',
    to: email,
    subject: 'Your OTP Code',
    text: `Your OTP code is ${otp}. It expires in 15 minutes.`,
  };

  try {
    await transporter.sendMail(mailOptions);
    console.log(`OTP sent to ${email}`);
  } catch (error) {
    console.error(`Failed to send OTP to ${email}:`, error);
    throw new Error('Failed to send OTP');
  }
}
// Reset Password (Only Check for New Password and User Existence)
exports.resetPassword = async (req, res) => {
  try {
    const { email, newPassword, confirmNewPassword } = req.body;

    // Check for all required fields
    if (!email || !newPassword || !confirmNewPassword) {
      return res.status(400).json({ error: 'All fields are required' });
    }

    // Check if the passwords match
    if (newPassword !== confirmNewPassword) {
      return res.status(400).json({ error: 'Passwords do not match' });
    }

    // Check if the user exists in the database
    const user = await UserModel.findOne({ email }).exec();
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    // Encrypt the new password
    const hashedPassword = bcrypt.hashSync(newPassword, 10);
    user.password = hashedPassword;

    // Save the updated user
    await user.save();

    res.status(200).json({ message: 'Password reset successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'Unable to reset password' });
  }
};






/** Get User Function */
