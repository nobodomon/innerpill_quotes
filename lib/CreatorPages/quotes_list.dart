import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:innerpill_quotes/authentication_service.dart';
import 'package:innerpill_quotes/spinny.dart';

class QuotesList extends StatefulWidget {
  @override
  _QuotesListState createState() => _QuotesListState();
}

class _QuotesListState extends State<QuotesList> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
      future: AuthenticationService(
              FirebaseAuth.instance, FirebaseFirestore.instance)
          .getAll("QuotesLibrary"),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> listitems) {
        if (listitems.hasData) {
          return ListView.builder(
            itemCount: listitems.data.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(listitems.data.docs[index].data()["content"]),
              );
            },
          );
        } else {
          return Spinny();
        }
      },
    );
  }
}
