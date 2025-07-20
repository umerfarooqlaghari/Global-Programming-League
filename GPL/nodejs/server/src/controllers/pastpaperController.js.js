const mongoose = require('mongoose');
const PastPaper = require('../models/pastpaper.model'); // Correct the file path
const postPastpapers = async (req, res) => {
  try {
    const { kind, date, name, link } = req.body;

    const paper = new PastPaper({ kind, date, name, link });
    await paper.save();

    res.status(200).send({ msg: 'Pastpaper uploaded' });
  } catch (error) {
    console.error('Error uploading past paper:', error);

    if (error.code === 11000) {
      // Duplicate key error (usually due to unique field constraint)
      res.status(400).send({
        error: 'Duplicate entry',
        field: Object.keys(error.keyPattern)[0],
        details: error.message,
      });
    } else {
      res.status(500).send({
        error: 'Pastpaper upload failed',
        details: error.message,
      });
    }
  }
};



const getPastpaper = async (req, res) => { // Ensure function name is plural to match the route convention
    try {
      const data = await PastPaper.find().exec();
      if (!data || data.length === 0) { // Ensure an empty array doesn't return a 404
        return res.status(404).send({ error: "No past papers found" });
      }
      res.status(200).send(data);
    } catch (error) {
      console.error("Error fetching past papers:", error);
      res.status(500).send({ error: "Unable to retrieve past papers", details: error.message });
    }
  };
  
  const deletePastpaper = async (req, res) => {
    try {
      const { id } = req.params; // Get the past paper ID from request params
      const deletedPaper = await PastPaper.findByIdAndDelete(id);
      if (!deletedPaper) {
        return res.status(404).send({ error: "Pastpaper not found" });
      }
      res.status(200).send({ msg: "Pastpaper deleted successfully" });
    } catch (error) {
      console.error("Error deleting past paper:", error);
      res.status(500).send({ error: "Failed to delete past paper", details: error.message });
    }
  };

  module.exports = { postPastpapers, getPastpaper,deletePastpaper };