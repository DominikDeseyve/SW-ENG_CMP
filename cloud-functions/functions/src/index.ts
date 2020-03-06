import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

import { countUser } from "./counter/countUser.js";
import { countSong } from "./counter/countSong.js";
import { countUpvotes } from "./counter/countUpvotes.js";

import { voteSong } from "./functions/voteSong.js";
import { deleteUser } from "./functions/deleteUser.js";
import { deletePlaylist } from "./functions/deletePlaylist.js";

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
//***************************************************//
//***********  CALLABLE FUNCTIONS
//***************************************************//
exports.voteSong = functions
  .region("europe-west2")
  .runWith({
    timeoutSeconds: 540,
    memory: "2GB"
  })
  .https.onCall(voteSong);

exports.deleteUser = functions
  .region("europe-west2")
  .runWith({
    timeoutSeconds: 540,
    memory: "2GB"
  })
  .https.onCall(deleteUser);

exports.deletePlaylist = functions
  .region("europe-west2")
  .runWith({
    timeoutSeconds: 540,
    memory: "2GB"
  })
  .https.onCall(deletePlaylist);
