const mongoose = require("mongoose");

const TeamSchema = new mongoose.Schema({
    createdBy: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        required: true
    },
    competitionName: {
        type: String,
        required: true
    },
    teamName: {
        type: String,
        required: true
    },
    teamMember1: {
        id: {
            type: mongoose.Schema.Types.ObjectId,
            required: true,
            ref: "User"
        },
        name: {
            type: String,
            required: true
        }
    },
    teamMember2: {
        id: {
            type: mongoose.Schema.Types.ObjectId,
            required: true,
            ref: "User"
        },
        name: {
            type: String,
            required: true
        }
    },
    teamMember1ID: {
        type: String,
        required: false
    },
    teamMember2ID: {
        type: String,
        required: false
    },
    teamMember1Name: {
        type: String,
        required: false
    },
    teamMember2Name: {
        type: String,
        required: false
    },
    date: {
        type: Date,
        required: true
    },
    location: {
        type: String,
        required: true
    },
    kind: {
        type: String,
        required: true,
        enum: ["Worldwide", "Regional", "Local"]
    }
}, { timestamps: true });

module.exports = mongoose.model("Team", TeamSchema);
