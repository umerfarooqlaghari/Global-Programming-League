const admin = require("../firebaseAdmin");
const UpComp = require("../models/UpComp.model.js");

const upcomingComp = async (req, res) => {
    try {
        const { title, date, location, kind } = req.body;

        const existTitle = await UpComp.findOne({ title }).exec();
        if (existTitle) {
            return res.status(400).json({ error: "Competition Already Posted" });
        }

        const comp = new UpComp({ title, date, location, kind });
        await comp.save();

        res.status(201).json({ msg: "Competition Posted Successfully" });

    } catch (error) {
        console.error("Error uploading competition:", error);
        res.status(500).json({ error: "Unable to Upload Competition", details: error.message });
    }
};


// Function to get all upcoming competitions
const getUpcomingComps = async (req, res) => {
    try {
        const competitions = await UpComp.find().exec();

        if (!competitions || competitions.length === 0) {
            return res.status(404).json({ error: "No competitions found" });
        }

        res.status(200).json(competitions);
    } catch (error) {
        console.error("Error fetching competitions:", error);
        res.status(500).json({ error: "Unable to fetch competitions", details: error.message });
    }
};

// Function to delete a competition by ID
const deleteUpcomingComp = async (req, res) => {
    try {
        const { id } = req.params; // Extract ID from URL parameters
        const deletedComp = await UpComp.findByIdAndDelete(id).exec();

        if (!deletedComp) {
            return res.status(404).json({ error: "Competition not found" });
        }

        res.status(200).json({ msg: "Competition deleted successfully" });

    } catch (error) {
        console.error("Error deleting competition:", error);
        res.status(500).json({ error: "Unable to delete competition", details: error.message });
    }
};

module.exports = {
    upcomingComp,
    getUpcomingComps,
    deleteUpcomingComp
};
