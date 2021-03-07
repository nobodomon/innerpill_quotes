import 'package:flutter/material.dart';
import 'package:innerpill_quotes/UserPages/daily.dart';
import 'package:innerpill_quotes/UserPages/favourite.dart';
import 'package:innerpill_quotes/UserPages/Search.dart';
import 'package:innerpill_quotes/authentication_service.dart';
import 'package:innerpill_quotes/common_split_tabs.dart';
import 'package:innerpill_quotes/settings.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomePage extends StatefulWidget {
  HomePage({
    this.auth,
    this.logoutCallback,
  });
  final AuthenticationService auth;
  final VoidCallback logoutCallback;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: 0);
    // TODO: implement build
    return Scaffold(
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
            viewportFraction: 0.8,
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
          CommonSplitTabs(
            auth: widget.auth,
            logoutCallback: widget.logoutCallback,
            viewportFraction: 1,
            pages: [
              Favourite(
                auth: widget.auth,
                logoutCallback: widget.logoutCallback,
                whichCollection: "PassagesLibrary",
                whichFavouriteCollection: "FavouritePassages",
              ),
              Favourite(
                auth: widget.auth,
                logoutCallback: widget.logoutCallback,
                whichCollection: "PassagesLibrary",
                whichFavouriteCollection: "FavouritePassages",
              )
            ],
          ),
          Search(
            auth: widget.auth,
            logoutCallback: widget.logoutCallback,
          )
        ],
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: currentIndex,
        unselectedItemColor: Colors.purple.shade100,
        selectedItemColor: Colors.purpleAccent[700],
        items: itemList,
        onTap: (index) => setState(() {
          currentIndex = index;
          controller.animateToPage(currentIndex,
              duration: Duration(milliseconds: 5), curve: Curves.easeInCubic);
        }),
        //other params
      ),
    );
  }

  List<SalomonBottomBarItem> itemList = [
    SalomonBottomBarItem(
      icon: Icon(Icons.lightbulb),
      title: Text("Daily"),
    ),
    SalomonBottomBarItem(
      icon: Icon(Icons.favorite),
      title: Text("Favourites"),
    ),
    SalomonBottomBarItem(
      icon: Icon(Icons.search),
      title: Text("Search"),
    ),
  ];
}
