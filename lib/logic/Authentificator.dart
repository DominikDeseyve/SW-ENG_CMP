import 'package:cmp/logic/Controller.dart';
import 'package:cmp/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentificator {
  Controller _controller;
  FirebaseAuth _firebaseAuth;
  FirebaseUser _firebaseUser;
  User _user;

  Authentificator(Controller pController) {
    this._controller = pController;
    this._firebaseAuth = FirebaseAuth.instance;
  }

  Future<void> signUp(String pEmail, String pPassword) async {
    try {
      AuthResult authResult = await this._firebaseAuth.createUserWithEmailAndPassword(email: pEmail, password: pPassword);
      await authResult.user.sendEmailVerification();
    } catch (e) {
      print(e.code);
    }
  }

  Future<bool> signIn(String pEmail, String pPassword) async {
    AuthResult authResult = await this._firebaseAuth.signInWithEmailAndPassword(email: pEmail, password: pPassword);
    if (authResult.user.isEmailVerified) {
      this._firebaseUser = authResult.user;
      await this.initializeUser();
      return true;
    }
    return false;
  }

  Future<void> signOut() async {
    await this._firebaseAuth.signOut();
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
    if (this._user == null) {
      print("USER NOT FOUND; TODO");
    }
  }

  //***************************************************//
  //*********   GETTER
  //***************************************************//
  User get user {
    return this._user;
  }
}
