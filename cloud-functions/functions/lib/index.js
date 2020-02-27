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
exports.recursiveDelete = functions
    .runWith({
    timeoutSeconds: 540,
    memory: "2GB"
})
    .https.onCall(async (data, context) => {
    // Only allow admin users to execute this function.
    /*if (!(context.auth && context.auth.token && context.auth.token.admin)) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Must be an administrative user to initiate delete."
      );
      console.log(
      `User ${context.auth.uid} has requested to delete path ${path}`
    );
    }*/
    const path = data.playlist_id;
    const db = admin.firestore();
    const collectionRef = db.collection("playlist").doc(path);
    const batch = db.batch();
    let query = await collectionRef.collection("joined_user").get();
    query.forEach(function (doc) {
        batch.delete(doc.ref);
    });
    query = await collectionRef.collection("queued_song").get();
    query.forEach(function (doc) {
        batch.delete(doc.ref);
    });
    batch.delete(collectionRef);
    await batch.commit();
});
//# sourceMappingURL=index.js.map