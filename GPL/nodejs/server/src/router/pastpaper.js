const express = require('express');
const router = express.Router();
const { postPastpapers, deletePastpaper} = require('..//controllers/pastpaperController.js'); 
const { getPastpaper} = require('..//controllers/pastpaperController.js'); 

// // Ensure this is correctly importing the function

router.post('/pastpaper', postPastpapers); // Ensure that 'postPastpapers' is a function
router.get('/getpastpaper',getPastpaper);
router.delete('/pastpapers/:id',deletePastpaper);

module.exports = router;
