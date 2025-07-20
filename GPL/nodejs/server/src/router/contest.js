const express= require('express');
const router = express.Router();
const {createTeam, getAllTeams, checkExistingRegistration, getUserTeams}= require("../controllers/contestController.js");

router.post("/teams", createTeam);
router.get("/teams", getAllTeams);
router.post("/check-registration", checkExistingRegistration);
router.get("/user-teams/:username", getUserTeams);

module.exports= router ;
