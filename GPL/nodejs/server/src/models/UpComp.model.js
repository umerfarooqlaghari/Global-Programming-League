const mongoose = require("mongoose");

const UpCompSchema = new mongoose.Schema({
    title: {
        type: String,
        required: [true, "Please provide unique title"],
        unique: [true, "Title Exists"]
    },
    
    date: {
        type: Date,
        required: [true, "Please provide date"],
        unique: false,
    },
    location: {
        type: String,
        required: [true, "Please provide location"],
        unique: false,
    },
    kind: {
        type: String,
        required: [true, "Please provide kind"],
        unique: false,
    }
});

module.exports = mongoose.model("UpComp", UpCompSchema);
