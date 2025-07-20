
const Ranking = require('../models/Ranking.model.js');

// Admin posts rankings
const postRankings= async (req, res) => {
    try {
        const { competitionName, rankings } = req.body;

        // Debug logging
        console.log('Posting rankings for competition:', competitionName);
        console.log('Rankings data received:', JSON.stringify(rankings, null, 2));

        const newRanking = new Ranking({ competitionName, rankings });
        await newRanking.save();

        console.log('Rankings saved successfully');
        res.json({ message: 'Rankings posted successfully' });
    } catch (error) {
        console.error('Error posting rankings:', error);
        res.status(500).json({ message: 'Error posting rankings' });
    }
};


// Get rankings by competition name
const getRankings = async (req, res) => {
    try {
        const { competitionName } = req.params; // Get competition name from URL
        console.log('Fetching rankings for competition:', competitionName);

        const rankings = await Ranking.findOne({ competitionName });

        if (!rankings) {
            console.log('No rankings found for competition:', competitionName);
            return res.status(404).json({ message: 'No rankings found for this competition' });
        }

        console.log('Rankings found:', JSON.stringify(rankings, null, 2));
        res.json(rankings);
    } catch (error) {
        console.error('Error fetching rankings:', error);
        res.status(500).json({ message: 'Error fetching rankings' });
    }
};

// Get all rankings from all competitions
const getAllRankings = async (req, res) => {
    try {
        const allRankings = await Ranking.find({}).sort({ competitionName: 1 });

        if (!allRankings || allRankings.length === 0) {
            return res.status(404).json({ message: 'No rankings found' });
        }

        res.json(allRankings);
    } catch (error) {
        console.error('Error fetching all rankings:', error);
        res.status(500).json({ message: 'Error fetching rankings' });
    }
};

// Delete rankings by competition name
const deleteRankings = async (req, res) => {
    try {
        const { competitionName } = req.params;
        console.log('Deleting rankings for competition:', competitionName);

        const deletedRanking = await Ranking.findOneAndDelete({ competitionName });

        if (!deletedRanking) {
            return res.status(404).json({ message: 'No rankings found for this competition' });
        }

        console.log('Rankings deleted successfully for:', competitionName);
        res.json({ message: 'Rankings deleted successfully' });
    } catch (error) {
        console.error('Error deleting rankings:', error);
        res.status(500).json({ message: 'Error deleting rankings' });
    }
};

module.exports= {postRankings, getRankings, getAllRankings, deleteRankings};