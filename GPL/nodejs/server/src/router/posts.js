const express = require("express");
const {
  getFeedPosts,
  getUserPosts,
  likePost,
  createPost,
  addComment,
  getComments,
  likeComment,
  getPostLikes,
  getSearchedFeedPosts,
} = require("../controllers/posts.js");
const { verifyToken } = require("../middleware/auth.js");

const router = express.Router();

/** Read */
router.get("/getFeedPosts", getFeedPosts);
router.get("/getSearchedPosts", getSearchedFeedPosts);
router.get("/:username/posts", getUserPosts);
router.get("/:id/comments", getComments); // Get all comments for a post
router.get("/:id/likes", getPostLikes);   // Get users who liked a post

/** Create */
router.post("/postcreate", createPost);
router.post("/:id/comments", addComment); // Add a comment to a post

/** Update */
router.patch("/:id/like", likePost);
router.patch("/:postId/comments/:commentId/like", verifyToken, likeComment); // Like/unlike a comment

module.exports = router;
