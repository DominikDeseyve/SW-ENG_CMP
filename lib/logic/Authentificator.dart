import 'dart:async';

import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentificator {
  Controller _controller;
  FirebaseAuth _firebaseAuth;
  FirebaseUser _firebaseUser;
  StreamSubscription _streamSubscription;
  User _user;

  Authentificator(Controller pController) {
    this._controller = pController;
    this._firebaseAuth = FirebaseAuth.instance;
/*
    this._streamSubscription = this._firebaseAuth.onAuthStateChanged.listen((FirebaseUser pUser) {
      print("on Auth sTate changed");
      if (pUser is FirebaseUser) {
        print(pUser.isEmailVerified);
      }
    });*/
  }

  Future<bool> signUp(String pEmail, String pPassword, User pUser) async {
    try {
      AuthResult authResult = await this._firebaseAuth.createUserWithEmailAndPassword(email: pEmail, password: pPassword);
      pUser.userID = authResult.user.uid;
      await this._controller.firebase.createUser(pUser, pEmail);
      await authResult.user.sendEmailVerification();
      return true;
    } catch (e) {
      print(e.code);
      return false;
    }
  }

  Future<bool> signIn(String pEmail, String pPassword) async {
    AuthResult authResult = await this._firebaseAuth.signInWithEmailAndPassword(email: pEmail, password: pPassword);
    if (authResult.user.isEmailVerified) {
      this._firebaseUser = authResult.user;
      await this.initializeUser();
      return true;
    } else {
      print("keine email verified");
      this.signOut();
      return false;
    }
  }

  Future<void> signOut() async {
    await this._firebaseAuth.signOut();
  }

  Future<void> delete() async {
    await this._firebaseUser.delete();
  }

  Future<bool> authentificate() async {
    FirebaseUser user = await this._firebaseAuth.currentUser();
    if (user != null) {
      this._firebaseUser = user;
      await this.initializeUser();
      return true;
    }
    return false;
  }

  Future<void> initializeUser() async {
    String userID = this._firebaseUser.uid;
    print("### USER LOGGED IN WITH ID: " + userID);
    this._user = await this._controller.firebase.getUser(userID);
    this._user.settings = await this._controller.firebase.getSettings(userID);
    Controller().localStorage.fetchValues();
    if (this._user == null) {
      print("USER NOT FOUND; TODO");
    }
  }

  Future<void> updatePasswort(String pPassword) async {
    //Pass in the password to updatePassword.
    this._firebaseUser.updatePassword(pPassword).then((_) {
      print("Succesfull changed password");
    }).catchError((error) {
      print("Password can't be changed " + error.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
    //await this._firebaseUser.updatePassword(pPassword);
  }

  Future<String> resetPasswort(String pEmail) async {
    try {
      await this._firebaseAuth.sendPasswordResetEmail(email: pEmail);
      return "";
    } catch (e) {
      return e.code;
    }
  }

  void dispose() {
    this._streamSubscription.cancel();
  }

  //***************************************************//
  //*********   GETTER
  //***************************************************//
  User get user {
    return this._user;
  }
}
