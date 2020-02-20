import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmp/models/user.dart';

class Request {
  String _requestID;
  DateTime _createdAt;
  String _status;
  User _user;

  Request(String pStatus, User pUser) {
    this._status = pStatus;
    this._user = pUser;
    this._createdAt = DateTime.now();
  }

  Request.fromFirebase(DocumentSnapshot pSnap) {
    this._requestID = pSnap.documentID;
    this._createdAt = DateTime.fromMillisecondsSinceEpoch(pSnap['created_at'].seconds * 1000);
    this._status = pSnap['status'];
    this._user = User.fromFirebase(pSnap['user']);
  }

  Map<String, dynamic> toFirebase() => {
        'status': this._status,
        'created_at': this._createdAt,
        'user': this._user.toFirebase(),
      };
  void decline() {
    this._status = 'DECLINE';
  }

  void accept() {
    this._status = 'ACCEPT';
  }

  //***************************************************//
  //*********   GETTER
  //***************************************************//
  String get requestID {
    return this._requestID;
  }

  String get status {
    return this._status;
  }

  User get user {
    return this._user;
  }

  DateTime get createdAt {
    return this._createdAt;
  }
}
