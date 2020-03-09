import * as admin from "firebase-admin";

export function countSong(change: any, event: any) {
  const db = admin.firestore();
  const FieldValue = require("firebase-admin").firestore.FieldValue;

  const playlistID: any = event.params.playlistID;
  //const songID: any = event.params.songID;

  const docRef = db.collection("playlist").doc(playlistID);
  if (!change.before.exists) {
    //New document
    docRef
      .update({ queued_song_count: FieldValue.increment(1) })
      .then()
      .catch();
  } else if (change.before.exists && change.after.exists) {
    //update
    /*const songRef = db
      .collection("playlist")
      .doc(playlistID)
      .collection("queued_song")
      .doc(songID);*/
    const data = change.after.data();
    console.log(data);
  } else if (!change.after.exists) {
    //Delete
    docRef
      .update({ queued_song_count: FieldValue.increment(-1) })
      .then()
      .catch();
  }
}
