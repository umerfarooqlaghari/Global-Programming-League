const mongoose = require('mongoose');

const rankingSchema = new mongoose.Schema({
    competitionName: String,
    rankings: [
        {
            name: String,
            position: Number, // 1 for 1st, 2 for 2nd, etc.
        }
    ],
});

const Ranking = mongoose.model('Ranking', rankingSchema);

module.exports = Ranking;
