import * as admin from "firebase-admin";

export function voteSong(data: any, context: any) {
  const playlistID = data.playlist_id;
  const songID = data.song_id;
  const direction = data.direction;

  const db = admin.firestore();
  const songRef = db
    .collection("playlist")
    .doc(playlistID)
    .collection("queued_song")
    .doc(songID);

  return db.runTransaction(transaction => {
    return transaction.get(songRef).then(restDoc => {
      // get values
      const songData: any = restDoc.data() || "";
      let upvoteCount = songData["upvote_count"];
      let downvoteCount = songData["downvote_count"];

      switch (direction) {
        case "UP":
          upvoteCount += 1;
          break;
        case "DOWN":
          downvoteCount += 1;
          break;
        case "UP_DOWN":
          upvoteCount -= 1;
          downvoteCount += 1;
          break;
        case "DOWN_UP":
          downvoteCount -= 1;
          upvoteCount += 1;
          break;
      }

      let ranking: number;

      if (downvoteCount === upvoteCount) {
        ranking = 0;
      } else if (downvoteCount === 0) {
        ranking = upvoteCount;
      } else if (upvoteCount === 0) {
        ranking = downvoteCount * -1;
      } else if (upvoteCount > downvoteCount) {
        ranking = upvoteCount / downvoteCount;
      } else if (upvoteCount < downvoteCount) {
        ranking = (downvoteCount / upvoteCount) * -1;
      } else {
        ranking = -100000;
      }

      // Update restaurant info
      return transaction.update(songRef, {
        ranking: ranking,
        upvote_count: upvoteCount,
        downvote_count: downvoteCount
      });
    });
  });
}
