import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innerpill_quotes/Model/models.dart';
import 'package:innerpill_quotes/UserPages/save_quote.dart';
import 'package:innerpill_quotes/authentication_service.dart';

import '../spinny.dart';

class Search extends StatefulWidget {
  Search({
    this.auth,
    this.logoutCallback,
  });
  final AuthenticationService auth;
  final VoidCallback logoutCallback;

  _SearchState createState() => _SearchState();
}

enum WhichLibrary { QuotesLibrary, PassagesLibrary }

class _SearchState extends State<Search> {
  TextEditingController controller = TextEditingController();
  String searchType;
  String searchString;

  bool _isRadioSelected = true;
  @override
  void initState() {
    searchString = "";
    searchType = "QuotesLibrary";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            PopupMenuButton<int>(
              icon: Icon(
                Icons.dns,
                color: Colors.purple,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: RadioListTile(
                    groupValue: _isRadioSelected,
                    dense: true,
                    title: Text("Search Quotes"),
                    value: true,
                    onChanged: (bool x) {
                      setState(() {
                        searchType = "QuotesLibrary";
                        _isRadioSelected = x;
                        Navigator.pop(context);
                      });
                    },
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child: RadioListTile(
                    groupValue: _isRadioSelected,
                    dense: true,
                    title: Text("Search Passages"),
                    value: false,
                    onChanged: (bool x) {
                      setState(() {
                        searchType = "PassagesLibrary";
                        _isRadioSelected = x;
                        Navigator.pop(context);
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
          title: TextField(
            decoration: InputDecoration(
              focusColor: Colors.deepPurple,
            ),
            controller: controller,
            onChanged: (String x) {
              setState(() {
                searchString = x;
              });
            },
          ),
        ),
        body: searchPane());
  }

  Widget searchPane() {
    if (searchString == "" || searchString == null) {
      return Scaffold(
        body: Center(
          child: Text("Please enter something in the search bar."),
        ),
      );
    } else {
      return StreamBuilder(
        stream: widget.auth.search(searchString, searchType),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> list) {
          if (list.hasData) {
            List<QueryDocumentSnapshot> reversedlist =
                list.data.docs.reversed.toList();
            print(reversedlist.length);
            return ListView.builder(
              itemCount: reversedlist.length,
              itemBuilder: (BuildContext context, int index) {
                Quote quote = Quote(
                    quote: reversedlist[index].data()["content"],
                    sort: reversedlist[index].data()["sort"],
                    documentId: reversedlist[index].id);
                return ListTile(
                  title: Text(
                    reversedlist[index].data()["content"],
                    maxLines: 1,
                    softWrap: true,
                  ),
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
        },
      );
    }
  }
}
