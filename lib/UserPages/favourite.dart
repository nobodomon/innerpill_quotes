import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innerpill_quotes/Model/models.dart';
import 'package:innerpill_quotes/UserPages/save_quote.dart';
import 'package:innerpill_quotes/authentication_service.dart';

import '../spinny.dart';

class Favourite extends StatefulWidget {
  Favourite(
      {this.auth,
      this.logoutCallback,
      this.whichCollection,
      this.whichFavouriteCollection});
  final AuthenticationService auth;
  final VoidCallback logoutCallback;
  final String whichCollection;
  final String whichFavouriteCollection;
  _FavouriteState createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.auth.getFavourites(
            widget.auth.getUser().uid, widget.whichFavouriteCollection),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> list) {
          return FutureBuilder(
              future: widget.auth.getAll(widget.whichCollection),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> quoteDetails) {
                if (list.hasData) {
                  List<QueryDocumentSnapshot> reversedlist =
                      list.data.docs.reversed.toList();
                  return ListView.builder(
                    itemCount: reversedlist.length,
                    itemBuilder: (BuildContext context, int index) {
                      Quote quote = Quote(
                          quote: quoteDetails.data.docs
                              .firstWhere((element) =>
                                  element.id == reversedlist[index].id)
                              .data()["content"],
                          sort: quoteDetails.data.docs
                              .firstWhere((element) =>
                                  element.id == reversedlist[index].id)
                              .data()["sort"],
                          documentId: quoteDetails.data.docs
                              .firstWhere((element) =>
                                  element.id == reversedlist[index].id)
                              .id);
                      return ListTile(
                        title: Text(quote.quote),
                        trailing: TextButton(
                          child: Icon(Icons.navigate_next),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SaveQuote(
                                          content: quote.quote,
                                          id: quote.documentId,
                                        )));
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return Spinny();
                }
              });
        });
  }
}
