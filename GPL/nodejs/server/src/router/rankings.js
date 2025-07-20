const express= require('express');
const {postRankings, getRankings, getAllRankings, deleteRankings}= require('../controllers/Rankings.js');


const router= express.Router();

router.post('/rankings',postRankings);
router.get('/rankings/:competitionName',getRankings);
router.get('/all-rankings', getAllRankings);
router.delete('/rankings/:competitionName', deleteRankings);


module.exports=router;