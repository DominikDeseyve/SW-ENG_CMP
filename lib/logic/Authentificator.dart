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

  Future<bool> signUp(String pEmail, String pPassword, User pUser) async {
    try {
      AuthResult authResult = await this._firebaseAuth.createUserWithEmailAndPassword(email: pEmail, password: pPassword);
      pUser.userID = authResult.user.uid;
      this._controller.firebase.createUser(pUser);
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
    }
    print("keine email verified");
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
    this._user.settings = await this._controller.firebase.getSettings(userID);
    print('fetch settings');
    print(this._user.settings);
    if (this._user == null) {
      print("USER NOT FOUND; TODO");
    }
  }

  Future<void> updatePasswort(String pPassword) async {
    await this._firebaseUser.updatePassword(pPassword);
  }

  Future<void> resetPasswort(String pEmail) async {
    await this._firebaseAuth.sendPasswordResetEmail(email: pEmail);
  }

  //***************************************************//
  //*********   GETTER
  //***************************************************//
  User get user {
    return this._user;
  }
}
