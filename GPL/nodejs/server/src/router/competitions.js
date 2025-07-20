const express= require('express');
const { upcomingComp, getUpcomingComps, deleteUpcomingComp } = require("../controllers/upcomingComp.js");
const { sendNotification } = require("../controllers/notificationController.js");

const router= express.Router();

router.post('/competitions', upcomingComp);
router.get('/competitions',getUpcomingComps);
router.delete('/competitions/:id',deleteUpcomingComp);
router.post("/send-notification", sendNotification);

module.exports= router;







