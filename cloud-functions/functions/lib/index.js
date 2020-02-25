"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const countUser_js_1 = require("./counter/countUser.js");
const countSong_js_1 = require("./counter/countSong.js");
const countUpvotes_js_1 = require("./counter/countUpvotes.js");
//import { countDownvotes } from "./counter/countDownvotes.js";
admin.initializeApp(functions.config().firebase);
//***************************************************//
//***********  COUNTER
//***************************************************//
exports.countJoinedUser = functions
    .region("europe-west2")
    .firestore.document("playlist/{playlistID}/joined_user/{userID}")
    .onWrite(countUser_js_1.countUser);
exports.countQueuedSong = functions
    .region("europe-west2")
    .firestore.document("playlist/{playlistID}/queued_song/{songID}")
    .onWrite(countSong_js_1.countSong);
exports.countUpvotes = functions
    .region("europe-west2")
    .firestore.document("playlist/{playlistID}/queued_song/{songID}/votes/{typeUserID}")
    .onWrite(countUpvotes_js_1.countUpvotes);
/*
exports.countDownvotes = functions
  .region("europe-west2")
  .firestore.document(
    "playlist/{playlistID}/queued_song/{songID}/downvotes/{userID}"
  )
  .onWrite(countDownvotes);
*/
//# sourceMappingURL=index.js.map