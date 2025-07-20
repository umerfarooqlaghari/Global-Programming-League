const mongoose = require("mongoose");

const pastPaperSchema = new mongoose.Schema({
    name: {
        type: String,
        required: [true, "Please provide unique title"],
        unique: false
    },
    link: {
        type: String,
        required: [true, "Please provide link"],
        unique: true,
    },
    date: {
        type: Date,
        required: false,
        unique: false,
    },
    kind: {
        type: String,
        required: [true, "Please provide type"],
        unique: false,
    }
});

module.exports = mongoose.models.pastPaper || mongoose.model('pastPaper', pastPaperSchema);
