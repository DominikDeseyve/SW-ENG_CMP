"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const admin = require("firebase-admin");
function countUpvotes(change, event) {
    const db = admin.firestore();
    const FieldValue = require("firebase-admin").firestore.FieldValue;
    const playlistID = event.params.playlistID;
    const songID = event.params.songID;
    const typeUserID = event.params.typeUserID;
    const type = typeUserID.split("_")[0];
    const songRef = db
        .collection("playlist")
        .doc(playlistID)
        .collection("queued_song")
        .doc(songID);
    if (!change.before.exists) {
        //New document
        if (type === "UP") {
            songRef
                .update({ upvote_count: FieldValue.increment(1) })
                .then()
                .catch();
        }
        else {
            songRef
                .update({ downvote_count: FieldValue.increment(1) })
                .then()
                .catch();
        }
    }
    else if (change.after.exists && change.before.exists) {
        //Update document
        if (type === "UP") {
            songRef
                .update({
                upvote_count: FieldValue.increment(1),
                downvote_count: FieldValue.increment(-1)
            })
                .then()
                .catch();
        }
        else {
            songRef
                .update({
                upvote_count: FieldValue.increment(-1),
                downvote_count: FieldValue.increment(1)
            })
                .then()
                .catch();
        }
    }
    else if (!change.after.exists) {
        //Delete
        if (type === "UP") {
            songRef
                .update({ upvote_count: FieldValue.increment(-1) })
                .then()
                .catch();
        }
        else {
            songRef
                .update({ downvote_count: FieldValue.increment(-1) })
                .then()
                .catch();
        }
    }
    // Update aggregations in a transaction
    return db.runTransaction(transaction => {
        return transaction.get(songRef).then(restDoc => {
            // Compute new number of ratings
            const data = restDoc.data() || "";
            const upvoteCount = data["upvote_count"];
            const downvoteCount = data["downvote_count"];
            let ranking;
            if (downvoteCount === upvoteCount) {
                ranking = 0;
            }
            else if (downvoteCount === 0) {
                ranking = upvoteCount;
            }
            else if (upvoteCount === 0) {
                ranking = downvoteCount * -1;
            }
            else {
                ranking = upvoteCount / downvoteCount;
            }
            // Update restaurant info
            return transaction.update(songRef, {
                ranking: ranking
            });
        });
    });
}
exports.countUpvotes = countUpvotes;
//# sourceMappingURL=countUpvotes.js.map