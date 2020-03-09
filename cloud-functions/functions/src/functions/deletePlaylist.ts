import * as admin from "firebase-admin";
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

export async function deletePlaylist(data: any, context: any) {
  const playlistID = data.playlist_id;
  const db = admin.firestore();
  const bucket = admin.storage().bucket();
  const batch = db.batch();

  const playlistRef = db.collection("playlist").doc(playlistID);

  let query = await playlistRef.collection("joined_user").get();
  query.forEach(function(doc) {
    batch.delete(doc.ref);
  });

  query = await playlistRef.collection("request").get();
  query.forEach(function(doc) {
    batch.delete(doc.ref);
  });

  query = await playlistRef.collection("queued_song").get();
  query.forEach(function(doc) {
    batch.delete(doc.ref);
  });

  query = await db
    .collectionGroup("joined_playlist")
    .where("playlist_id", "==", playlistID)
    .get();
  query.forEach(function(doc) {
    batch.delete(doc.ref);
  });

  batch.delete(playlistRef);

  await batch.commit();

  //delete image
  const hasImage: [boolean] = await bucket
    .file("playlist/" + playlistID)
    .exists();
  if (hasImage[0]) {
    await bucket.file("playlist/" + playlistID).delete();
  }
}
