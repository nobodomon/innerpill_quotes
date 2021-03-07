import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:innerpill_quotes/authentication_service.dart';

class Submit extends StatefulWidget {
  Submit({
    this.whichLibrary,
  });
  final String whichLibrary;
  @override
  _SubmitState createState() => _SubmitState();
}

class _SubmitState extends State<Submit> {
  TextEditingController quote = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Column(
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
                    .submitNew(quote.text, "QuotesLibrary")
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
      ),
    );
  }
}
