import * as admin from "firebase-admin";

export function countSong(change: any, event: any) {
  const db = admin.firestore();
  const FieldValue = require("firebase-admin").firestore.FieldValue;

  const playlistID: any = event.params.playlistID;

  const docRef = db.collection("playlist").doc(playlistID);
  if (!change.before.exists) {
    //New document
    docRef
      .update({ queued_song_count: FieldValue.increment(1) })
      .then()
      .catch();
  } else if (!change.after.exists) {
    //Delete
    docRef
      .update({ queued_song_count: FieldValue.increment(-1) })
      .then()
      .catch();
  }
}
