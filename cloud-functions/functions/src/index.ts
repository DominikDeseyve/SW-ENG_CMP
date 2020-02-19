import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

import { countUser } from "./counter/countUser.js";
import { countSong } from "./counter/countSong.js";
import { countUpvotes } from "./counter/countUpvotes.js";
//import { countDownvotes } from "./counter/countDownvotes.js";

admin.initializeApp(functions.config().firebase);

//***************************************************//
//***********  COUNTER
//***************************************************//
exports.countJoinedUser = functions
  .region("europe-west2")
  .firestore.document("playlist/{playlistID}/joined_user/{userID}")
  .onWrite(countUser);

exports.countQueuedSong = functions
  .region("europe-west2")
  .firestore.document("playlist/{playlistID}/queued_song/{songID}")
  .onWrite(countSong);

exports.countUpvotes = functions
  .region("europe-west2")
  .firestore.document(
    "playlist/{playlistID}/queued_song/{songID}/votes/{typeUserID}"
  )
  .onWrite(countUpvotes);
/*
exports.countDownvotes = functions
  .region("europe-west2")
  .firestore.document(
    "playlist/{playlistID}/queued_song/{songID}/downvotes/{userID}"
  )
  .onWrite(countDownvotes);
*/
