import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyUser {
  User fbUser;
  DocumentSnapshot userInfo;
  MyUser(this.fbUser, this.userInfo);
}
