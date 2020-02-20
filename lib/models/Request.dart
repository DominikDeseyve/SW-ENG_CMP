import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmp/models/user.dart';

class Request {
  String _requestID;
  String _status;
  User _user;

  Request.fromFirebase(DocumentSnapshot pSnap) {
    this._requestID = pSnap.documentID;
    this._status = pSnap['status'];
    this._user = User.fromFirebase(pSnap['user']);
  }

  Map<String, dynamic> toFirebase() => {
        'request_id': this._requestID,
        'status': this._status,
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
}
