"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const countUser_js_1 = require("./counter/countUser.js");
const countSong_js_1 = require("./counter/countSong.js");
const countUpvotes_js_1 = require("./counter/countUpvotes.js");
const voteSong_js_1 = require("./functions/voteSong.js");
const deleteUser_js_1 = require("./functions/deleteUser.js");
const deletePlaylist_js_1 = require("./functions/deletePlaylist.js");
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
//***************************************************//
//***********  CALLABLE FUNCTIONS
//***************************************************//
exports.voteSong = functions
    .region("europe-west2")
    .runWith({
    timeoutSeconds: 540,
    memory: "2GB"
})
    .https.onCall(voteSong_js_1.voteSong);
exports.deleteUser = functions
    .region("europe-west2")
    .runWith({
    timeoutSeconds: 540,
    memory: "2GB"
})
    .https.onCall(deleteUser_js_1.deleteUser);
exports.deletePlaylist = functions
    .region("europe-west2")
    .runWith({
    timeoutSeconds: 540,
    memory: "2GB"
})
    .https.onCall(deletePlaylist_js_1.deletePlaylist);
//# sourceMappingURL=index.js.map