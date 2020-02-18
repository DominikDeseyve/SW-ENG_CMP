import * as admin from "firebase-admin";

export function countDownvotes(change: any, event: any) {
  const db = admin.firestore();
  const FieldValue = require("firebase-admin").firestore.FieldValue;

  const playlistID: any = event.params.playlistID;
  const songID: any = event.params.songID;

  const songRef = db
    .collection("playlist")
    .doc(playlistID)
    .collection("queued_song")
    .doc(songID);
  if (!change.before.exists) {
    //New document
    songRef
      .update({ downvote_count: FieldValue.increment(1) })
      .then()
      .catch();
  } else if (!change.after.exists) {
    //Delete
    songRef
      .update({ downvote_count: FieldValue.increment(-1) })
      .then()
      .catch();
  }
}
