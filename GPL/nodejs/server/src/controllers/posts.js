const Post = require('../models/Post.js');
const UserModel = require("../models/User.model.js");

// Existing functions  


// * POST * //localhost:5000/api/posts/postcreate
const createPost = async (req, res) => {
  try {
    const { description, profilepicture, userId, userName } = req.body;

    //if (!mongoose.Types.ObjectId.isValid(userId)) {
    //  return res.status(400).json({ error: "Invalid userId format" });
    //}
    if (!userName || !description) {
      return res.status(400).json({ error: "Missing required fields" });
    }

    const user = await UserModel.findById(userId);
    if (!user) {
      return res.status(404).send({ error: "User not found" });
    }

    const newPost = new Post({
      userId: userId,
      userName: userName,
      email: user.email,
      description,
      likes: {},
      comments: [],
      profilePicture: profilepicture
    });

    await newPost.save();

    const posts = await Post.find().sort({ createdAt: -1});

    res.status(201).json(posts);
  } catch (err) {
    res.status(409).json({ message: err.message });
  }
};
// * GET *  localhost:8000/api/posts/getFeedPosts

const getFeedPosts = async (req, res) => {
  try {
    const posts = await Post.find().sort({ createdAt: -1 });
    res.status(200).json(posts);
  } catch (err) {
    res.status(404).json({ message: err.message });
  }
};
// * GET *   localhost:8000/api/posts/username/posts
const getUserPosts = async (req, res) => {
  try {
    const { username } = req.params;
    const posts = await Post.find({ userName: username });
    if (!posts.length) {
      return res.status(404).json({ message: "No posts found for this user." });
    }
    res.status(200).json(posts);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
 // * PATCH *  localhost:8000/api/posts/id/like
const likePost = async (req, res) => {
  try {
    const { id } = req.params;
    const { username } = req.body;
    const post = await Post.findById(id);
    const isLiked = post.likes.get(username);

    if (isLiked) {
      post.likes.delete(username);
    } else {
      post.likes.set(username, true);
    }

    const updatedPost = await Post.findByIdAndUpdate(
      id,
      { likes: post.likes },
      { new: true }
    );

    res.status(200).json(updatedPost);
  } catch (err) {
    res.status(404).json({ message: err.message });
  }
};

// New Functions

// * POST *  localhost:8000/api/posts/id/comments
const addComment = async (req, res) => {
  try {
    const { id } = req.params;
    const { username, comment } = req.body;

    if (!comment) {
      return res.status(400).json({ message: "Comment cannot be empty" });
    }

    const post = await Post.findById(id);
    if (!post) {
      return res.status(404).json({ message: "Post not found" });
    }
    //console.log(post);
    post.comments.push({ id, username, comment, createdAt: new Date() });
    //console.log(post);
    await post.save();

    res.status(200).json(post);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};


// * GET *   localhost:8000/api/posts/id/comments
const getComments = async (req, res) => {
  try {
    const { id } = req.params;
    const post = await Post.findById(id);

    if (!post) {
      return res.status(404).json({ message: "Post not found" });
    }

    res.status(200).json(post.comments);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};
// * PATCH  * //localhost:8000/api/posts/postId/comments/commentId/like
const likeComment = async (req, res) => {
  try {
    const { postId, commentId } = req.params;
    const { username } = req.body;

    const post = await Post.findById(postId);
    if (!post) {
      return res.status(404).json({ message: "Post not found" });
    }

    const comment = post.comments.id(commentId);
    if (!comment) {
      return res.status(404).json({ message: "Comment not found" });
    }

    const isLiked = comment.likes.includes(username);
    if (isLiked) {
      comment.likes = comment.likes.filter((user) => user !== username);
    } else {
      comment.likes.push(username);
    }

    await post.save();

    res.status(200).json(post);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};





// * GET * //localhost:8000/api/posts/id/likes
const getPostLikes = async (req, res) => {
  try {
    const { id } = req.params;
    const post = await Post.findById(id);

    if (!post) {
      return res.status(404).json({ message: "Post not found" });
    }

    const likes = Array.from(post.likes.keys());
    res.status(200).json(likes);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

const getSearchedFeedPosts = async (req, res) => {
  try {
    const { searchText } = req.query;  // Get search text from query parameters

    // If there's a search text, filter posts using regex to search the description
    const filter = searchText
      ? {
          description: { $regex: searchText, $options: 'i' }, // Case-insensitive search for description
        }
      : {};  // If no search text, no filter

    // Find posts with the filter and sort by createdAt
    const posts = await Post.find(filter).sort({ createdAt: -1 });
    
    res.status(200).json(posts);
  } catch (err) {
    res.status(404).json({ message: err.message });
  }
};


module.exports = {
  createPost,
  getFeedPosts,
  getUserPosts,
  likePost,
  addComment,
  getComments,
  likeComment,
  getPostLikes,
  getSearchedFeedPosts
};
