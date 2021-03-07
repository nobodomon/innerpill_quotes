import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:innerpill_quotes/authentication_service.dart';

class SubmitNewPassage extends StatefulWidget {
  @override
  _SubmitNewPassageState createState() => _SubmitNewPassageState();
}

class _SubmitNewPassageState extends State<SubmitNewPassage> {
  TextEditingController quote = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(15.0),
            child: TextField(
              controller: quote,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await AuthenticationService(
                      FirebaseAuth.instance, FirebaseFirestore.instance)
                  .submitNew(quote.text, "PassagesLibrary")
                  .then((value) {
                if (value == "Success") {
                  Navigator.pop(context);
                } else {
                  debugPrint(value);
                }
              });
            },
            child: Text("Submit"),
          )
        ],
      ),
    );
  }
}
