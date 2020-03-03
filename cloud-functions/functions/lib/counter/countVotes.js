"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const admin = require("firebase-admin");
function countVotes(change, event) {
    const db = admin.firestore();
    const FieldValue = require("firebase-admin").firestore.FieldValue;
    const playlistID = event.params.playlistID;
    const songID = event.params.songID;
    const songRef = db
        .collection("playlist")
        .doc(playlistID)
        .collection("queued_song")
        .doc(songID);
    if (!change.before.exists) {
        //New document
        songRef
            .update({ ranking: FieldValue.increment(1) })
            .then()
            .catch();
    }
    else if (!change.after.exists) {
        //Delete
        songRef
            .update({ joined_user_count: FieldValue.increment(-1) })
            .then()
            .catch();
    }
}
exports.countVotes = countVotes;
//# sourceMappingURL=countVotes.js.map