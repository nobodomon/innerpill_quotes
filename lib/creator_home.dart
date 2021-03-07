import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:innerpill_quotes/CreatorPages/quotes_list.dart';
import 'package:innerpill_quotes/CreatorPages/submit.dart';
import 'package:innerpill_quotes/CreatorPages/submit_new_passage.dart';
import 'package:innerpill_quotes/CreatorPages/submit_new_quote.dart';
import 'package:innerpill_quotes/authentication_service.dart';
import 'package:innerpill_quotes/common_split_tabs.dart';
import 'package:innerpill_quotes/settings.dart';
import 'package:provider/provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import 'UserPages/daily.dart';

class CreatorHomePage extends StatefulWidget {
  CreatorHomePage({
    this.auth,
    this.logoutCallback,
  });
  final AuthenticationService auth;
  final VoidCallback logoutCallback;
  @override
  _CreatorHomePageState createState() => _CreatorHomePageState();
}

class _CreatorHomePageState extends State<CreatorHomePage> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: 0);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        child: IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CommonSplitTabs(
                            auth: widget.auth,
                            logoutCallback: widget.logoutCallback,
                            pages: [
                              Submit(whichLibrary: "QuotesLibrary"),
                              Submit(whichLibrary: "PassagesLibrary")
                            ],
                          )));
            }),
      ),
      appBar: AppBar(
          title: FutureBuilder(
              future: widget.auth.getUserName(widget.auth.getUser()),
              builder: (BuildContext context, AsyncSnapshot<String> name) {
                if (name.hasData) {
                  return TextButton(
                    child: Text(name.data),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MySettings(
                                    auth: widget.auth,
                                    logoutCallback: widget.logoutCallback,
                                  )));
                    },
                  );
                } else {
                  return LinearProgressIndicator();
                }
              }),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            PopupMenuButton<int>(
              itemBuilder: (context) => [
                PopupMenuItem(
                    value: 1,
                    child: TextButton(
                      child: Text("Sign Out"),
                      onPressed: () {
                        widget.logoutCallback();
                        Navigator.pop(context);
                      },
                    )),
              ],
            ),
          ]),
      body: PageView(
        onPageChanged: (int x) {
          setState(() {
            currentIndex = x;
            controller.animateToPage(x,
                duration: Duration(milliseconds: 5), curve: Curves.easeInCubic);
          });
        },
        controller: controller,
        children: [
          CommonSplitTabs(
            auth: widget.auth,
            logoutCallback: widget.logoutCallback,
            viewportFraction: 1,
            pages: [
              Daily(
                auth: widget.auth,
                logoutCallback: widget.logoutCallback,
                whichCollection: "QuotesLibrary",
                whichFavouriteCollection: "FavouriteQuotes",
              ),
              Daily(
                auth: widget.auth,
                logoutCallback: widget.logoutCallback,
                whichCollection: "PassagesLibrary",
                whichFavouriteCollection: "FavouritePassages",
              )
            ],
          ),
          QuotesList()
        ],
      ),
      bottomNavigationBar: SalomonBottomBar(
          onTap: (int x) {
            setState(() {
              currentIndex = x;
              controller.animateToPage(x,
                  duration: Duration(milliseconds: 5),
                  curve: Curves.easeInCubic);
            });
          },
          unselectedItemColor: Colors.purple.shade100,
          selectedItemColor: Colors.purpleAccent,
          currentIndex: currentIndex,
          items: itemList),
    );
  }

  List<SalomonBottomBarItem> itemList = [
    SalomonBottomBarItem(
      icon: Icon(Icons.lightbulb),
      title: Text("Daily"),
    ),
    SalomonBottomBarItem(
      icon: Icon(Icons.list),
      title: Text("Favourite"),
    ),
  ];
}
