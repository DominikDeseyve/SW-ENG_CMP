"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const admin = require("firebase-admin");
function countUser(change, event) {
    const db = admin.firestore();
    const FieldValue = require("firebase-admin").firestore.FieldValue;
    const playlistID = event.params.playlistID;
    const docRef = db.collection("playlist").doc(playlistID);
    if (!change.before.exists) {
        //New document
        docRef
            .update({ joined_user_count: FieldValue.increment(1) })
            .then()
            .catch();
    }
    else if (!change.after.exists) {
        //Delete
        docRef
            .update({ joined_user_count: FieldValue.increment(-1) })
            .then()
            .catch();
    }
}
exports.countUser = countUser;
//# sourceMappingURL=countUser.js.map