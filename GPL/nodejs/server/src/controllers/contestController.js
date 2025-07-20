const TeamModel = require("../models/contest.model.js");
const UserModel = require('../models/User.model');

async function createTeam(req, res) {
  try {
    const userId = req.headers.authorization;
    if (!userId) {
      return res.status(401).send({ error: "Unauthorized user" });
    }

    const loggedInUser = await UserModel.findById(userId);
    if (!loggedInUser) {
      return res.status(401).send({ error: "Unauthorized user" });
    }

    const { competitionName, teamName, teamMember1ID, teamMember2ID, teamMember1Name, teamMember2Name, date, location, kind } = req.body;

    // Validate team members exist and fetch their IDs
    const member1 = await UserModel.findOne({ username: teamMember1Name }).select('_id username');
    const member2 = await UserModel.findOne({ username: teamMember2Name }).select('_id username');

    // Check if both team members were found
    if (!member1 || !member2) {
      return res.status(400).send({ error: "One or more team member names are invalid" });
    }

    // Check if any of the team members are already registered for this competition
    const existingTeam = await TeamModel.findOne({
      competitionName,
      $or: [
        { 'teamMember1.id': member1._id },
        { 'teamMember2.id': member1._id },
        { 'teamMember1.id': member2._id },
        { 'teamMember2.id': member2._id }
      ]
    });

    if (existingTeam) {
      return res.status(400).send({
        error: "One or more team members are already registered for this competition. Please check registered teams or use different team members."
      });
    }

    // Create and save team
    const team = new TeamModel({
      createdBy: loggedInUser._id,
      competitionName,
      teamName,
      teamMember1: { id: member1._id, name: teamMember1Name },
      teamMember2: { id: member2._id, name: teamMember2Name },
      teamMember1ID: teamMember1ID,
      teamMember2ID: teamMember2ID,
      teamMember1Name: teamMember1Name,
      teamMember2Name: teamMember2Name,
      date,
      location,
      kind
    });

    await team.save();

    res.status(200).send({ message: "Team created successfully", team });
  } catch (error) {
    console.error(error);
    res.status(500).send({ error: "An error occurred while creating the team." });
  }
}

async function getAllTeams(req, res) {
  try {
    const teams = await TeamModel.find()
      .populate('createdBy', 'username')
      .populate('teamMember1.id', 'username')
      .populate('teamMember2.id', 'username')
      .sort({ createdAt: -1 });

    if (!teams || teams.length === 0) {
      return res.status(404).send({ error: "No teams found" });
    }

    res.status(200).send(teams);
  } catch (error) {
    console.error(error);
    res.status(500).send({ error: "An error occurred while fetching teams." });
  }
}

async function checkExistingRegistration(req, res) {
  try {
    const { competitionName, teamMember1Name, teamMember2Name } = req.body;

    // Find users by their names
    const member1 = await UserModel.findOne({ username: teamMember1Name }).select('_id');
    const member2 = await UserModel.findOne({ username: teamMember2Name }).select('_id');

    if (!member1 || !member2) {
      return res.status(200).send({ exists: false, message: "One or more team members not found" });
    }

    // Check if any of the team members are already registered for this competition
    const existingTeam = await TeamModel.findOne({
      competitionName,
      $or: [
        { 'teamMember1.id': member1._id },
        { 'teamMember2.id': member1._id },
        { 'teamMember1.id': member2._id },
        { 'teamMember2.id': member2._id }
      ]
    });

    if (existingTeam) {
      return res.status(200).send({
        exists: true,
        message: "One or more team members are already registered for this competition",
        existingTeam: {
          teamName: existingTeam.teamName,
          teamMember1Name: existingTeam.teamMember1.name,
          teamMember2Name: existingTeam.teamMember2.name
        }
      });
    }

    res.status(200).send({ exists: false, message: "No existing registration found" });
  } catch (error) {
    console.error(error);
    res.status(500).send({ error: "An error occurred while checking registration." });
  }
}

async function getUserTeams(req, res) {
  try {
    const { username } = req.params;

    // Find user by username
    const user = await UserModel.findOne({ username }).select('_id');
    if (!user) {
      return res.status(404).send({ error: "User not found" });
    }

    // Find all teams where the user is either team member 1 or team member 2
    const teams = await TeamModel.find({
      $or: [
        { 'teamMember1.id': user._id },
        { 'teamMember2.id': user._id }
      ]
    }).sort({ createdAt: -1 });

    res.status(200).send(teams);
  } catch (error) {
    console.error(error);
    res.status(500).send({ error: "An error occurred while fetching user teams." });
  }
}

module.exports = { createTeam, getAllTeams, checkExistingRegistration, getUserTeams };
