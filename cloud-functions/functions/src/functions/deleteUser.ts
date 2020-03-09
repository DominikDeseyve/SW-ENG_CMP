import * as admin from "firebase-admin";

export async function deleteUser(data: any, context: any) {
  const userID = data.user_id;
  const db = admin.firestore();
  const bucket = admin.storage().bucket();
  const batch = db.batch();

  let query = await db
    .collection("user")
    .doc(userID)
    .collection("joined_playlist")
    .get();
  query.forEach(function(doc) {
    batch.delete(doc.ref);
  });

  batch.delete(db.collection("user").doc(userID));

  //delete all playlist where user was creator
  query = await db
    .collection("playlist")
    .where("creator.user_id", "==", userID)
    .get();
  query.forEach(function(doc) {
    //TODO: Call deleteplaylist();
    batch.delete(doc.ref);
  });

  query = await db
    .collectionGroup("joined_user")
    .where("user_id", "==", userID)
    .get();
  query.forEach(function(doc) {
    batch.delete(doc.ref);
  });

  query = await db
    .collectionGroup("request")
    .where("user.user_id", "==", userID)
    .get();
  query.forEach(function(doc) {
    batch.delete(doc.ref);
  });

  //delete settings
  batch.delete(db.collection("settings").doc(userID));

  await batch.commit();

  //delete image
  const hasImage: [boolean] = await bucket.file("user/" + userID).exists();
  if (hasImage[0]) {
    await bucket.file("user/" + userID).delete();
  }
}
