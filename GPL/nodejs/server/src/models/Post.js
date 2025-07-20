const mongoose = require("mongoose");
const { Schema } = mongoose;

const postSchema = new Schema(
  {
    userId: {
      type: Schema.Types.ObjectId,
      required: true,
      ref: 'User',
    },
    userName: {
      type: String,
      trim: true,
      required: true,
    },
    email: {
      type: String,
      required: true,
      trim: true,
      lowercase: true,
    },
    location: {
      type: String,
      trim: true,
    },
    description: {
      type: String,
      required: true,
      trim: true,
    },
    profilePicture: {
      type: String,
      trim: true,
    },
    userPicturePath: {
      type: String,
      trim: true,
    },
    likes: {
      type: Map,
      of: Boolean,
      default: {}, // Default empty map for likes
    },
    comments: {
      type: [
        {
          id: { type: String, required: true }, // Unique ID for each comment
          username: { type: String, required: true }, // Commenter's username
          comment: { type: String, required: true }, // Comment text
          likes: {
            type: Map,
            of: Boolean,
            default: {}, // Nested likes map for each comment
          },
        },
      ],
      default: [], // Default empty array for comments
    },
  },
  { timestamps: true }
);

const Post = mongoose.model("Post", postSchema);

module.exports = Post;
