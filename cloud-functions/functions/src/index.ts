import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

import { countUser } from "./counter/countUser.js";
import { countSong } from "./counter/countSong.js";
import { countUpvotes } from "./counter/countUpvotes.js";

import { voteSong } from "./functions/voteSong.js";

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

exports.voteSong = functions
  .region("europe-west2")
  .runWith({
    timeoutSeconds: 540,
    memory: "2GB"
  })
  .https.onCall(voteSong);

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
    query.forEach(function(doc) {
      batch.delete(doc.ref);
    });

    query = await collectionRef.collection("request").get();
    query.forEach(function(doc) {
      batch.delete(doc.ref);
    });

    query = await collectionRef.collection("queued_song").get();
    query.forEach(function(doc) {
      batch.delete(doc.ref);
    });

    batch.delete(collectionRef);

    await batch.commit();
  });
