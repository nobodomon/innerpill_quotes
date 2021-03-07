import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Quote {
  final String quote;
  final Timestamp sort;
  final String documentId;

  Quote({@required this.quote, @required this.sort, this.documentId});

  static Quote fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;
    return Quote(
        quote: map['content'], sort: map['sort'], documentId: documentId);
  }
}

class Passages {
  final String passage;
  final Timestamp sort;
  final String documentId;

  Passages({@required this.passage, @required this.sort, this.documentId});

  static Quote fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;
    return Quote(
        quote: map['content'], sort: map['sort'], documentId: documentId);
  }
}

class UserProfile {
  UserProfile({this.fbUser, this.fsUser});
  User fbUser;
  DocumentSnapshot fsUser;
}

class OperationResult {
  OperationResult({this.success, this.message});
  final bool success;
  final String message;
}
