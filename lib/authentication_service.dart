import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:innerpill_quotes/MyUser.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

import 'Model/models.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  AuthenticationService(this._firebaseAuth, this._firebaseFirestore);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<UserProfile> signIn({String email, String password}) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      DocumentSnapshot fsUser =
          await _firebaseFirestore.collection("Users").doc(email).get();
      return UserProfile(fbUser: result.user, fsUser: fsUser);
    } catch (e) {
      return null;
    }
  }

  User getUser() {
    return _firebaseAuth.currentUser;
  }

  Future<String> signUp({String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      await createFireStoreUser(_firebaseAuth.currentUser);
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<UserProfile> getCurrUserInfo() async {
    try {
      User user = _firebaseAuth.currentUser;
      if (user == null) {
        return null;
      }
      DocumentSnapshot fsUser =
          await _firebaseFirestore.collection("Users").doc(user.uid).get();
      return new UserProfile(fbUser: user, fsUser: fsUser);
    } catch (e) {
      return null;
    }
  }

  Future<DocumentSnapshot> createFireStoreUser(User user) async {
    return _firebaseFirestore.collection("Users").doc(user.uid).set({
      "userType": 0,
      "email": user.email,
      "name": user.displayName,
    }).then((value) {
      return _firebaseFirestore.collection("Users").doc(user.uid).get();
    });
  }

  Future<OperationResult> setUserName(User user, String name) async {
    if (name == null) {
      return OperationResult(success: false, message: "Please enter something");
    } else {
      try {
        return _firebaseFirestore
            .collection("Users")
            .doc(user.uid)
            .set({"name": name}, SetOptions(merge: true)).then((value) {
          return OperationResult(success: true, message: "Success");
        });
      } catch (e) {
        return OperationResult(success: false, message: e.toString());
      }
    }
  }

  Future<String> getUserName(User user) async {
    try {
      String name = await _firebaseFirestore
          .collection("Users")
          .doc(user.uid)
          .get()
          .then((value) {
        return value.data()["name"];
      });
      name == null ? name = user.email.split("@")[0] : name = name;
      return name;
    } catch (e) {
      return e.toString();
    }
  }

  void signOut() {
    _firebaseAuth.signOut();
    _firebaseFirestore.terminate();
  }

  Future<String> submitNew(String content, String whichCollection) async {
    await _firebaseFirestore
        .collection(whichCollection)
        .add({"content": content, "sort": FieldValue.serverTimestamp()});
    return "Success";
  }

  Future<QuerySnapshot> getAll(String whichCollection) {
    return _firebaseFirestore.collection(whichCollection).get();
  }

  Future<DocumentSnapshot> getByID(String id, String whichCollection) async {
    return await _firebaseFirestore.collection(whichCollection).doc(id).get();
  }

  Stream<QuerySnapshot> search(String searchQuery, String whichCollection) {
    Stream<QuerySnapshot> searchResult =
        _firebaseFirestore.collection(whichCollection).snapshots();
    searchResult.forEach((elements) {
      elements.docs.retainWhere((element) =>
          element.data()["content"].toString().contains(searchQuery));
    });
    return searchResult;
  }

  Future<QuerySnapshot> getLatest(String whichCollection) async {
    return await _firebaseFirestore
        .collection(whichCollection)
        .orderBy("sort")
        .get();
  }

  Future<void> addToFavourites(
      String userID, String id, String whichCollection) async {
    return await _firebaseFirestore
        .collection("Users")
        .doc(userID)
        .collection(whichCollection)
        .doc(id)
        .set({"quoteID": id});
  }

  Future<void> removeFromFavourites(
      String userID, String id, String whichCollection) async {
    return await _firebaseFirestore
        .collection("Users")
        .doc(userID)
        .collection(whichCollection)
        .doc(id)
        .delete();
  }

  Future<QuerySnapshot> getFavourites(String userID, String whichCollection) {
    return _firebaseFirestore
        .collection("Users")
        .doc(userID)
        .collection(whichCollection)
        .get();
  }

  Future<bool> checkIfLiked(
      String userID, String quoteID, String whichCollection) {
    return _firebaseFirestore
        .collection("Users")
        .doc(userID)
        .collection(whichCollection)
        .doc(quoteID)
        .get()
        .then((value) {
      if (value.exists) {
        print(true);
        return true;
      } else {
        print(false);
        return false;
      }
    });
  }
}
