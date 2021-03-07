import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:innerpill_quotes/UserPages/save_quote.dart';
import 'package:innerpill_quotes/authentication_service.dart';
import 'package:provider/provider.dart';

class Daily extends StatefulWidget {
  Daily(
      {this.auth,
      this.logoutCallback,
      this.whichCollection,
      this.whichFavouriteCollection});
  final AuthenticationService auth;
  final VoidCallback logoutCallback;
  final String whichCollection;
  final String whichFavouriteCollection;
  @override
  _DailyState createState() => _DailyState();
}

class _DailyState extends State<Daily> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 350));
    _animation = Tween(begin: 0.0, end: 100.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
        future: widget.auth.getLatest(widget.whichCollection),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> info) {
          if (info.hasData) {
            return Scaffold(
                body: GestureDetector(
                    onDoubleTap: () {
                      widget.auth.addToFavourites(
                          widget.auth.getUser().uid,
                          info.data.docs.last.id,
                          widget.whichFavouriteCollection);
                      _animationController.forward().then((value) =>
                          _animationController.animateBack(0.0,
                              curve: Curves.easeInToLinear));
                      setState(() {});
                    },
                    child: Stack(children: [
                      Scaffold(
                        body: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            margin: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 50),
                            child: Scaffold(
                              backgroundColor: Colors.transparent,
                              appBar: AppBar(
                                title: Text(
                                  info.data.docs.last["sort"]
                                      .toDate()
                                      .toString()
                                      .split(' ')[0],
                                  style: TextStyle(fontSize: 12),
                                ),
                                actions: [
                                  FutureBuilder(
                                      future: widget.auth.checkIfLiked(
                                          widget.auth.getUser().uid,
                                          info.data.docs.first.id,
                                          widget.whichFavouriteCollection),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<bool> favourited) {
                                        if (favourited.hasData) {
                                          if (favourited.data) {
                                            return IconButton(
                                                onPressed: () {
                                                  widget.auth.removeFromFavourites(
                                                      widget.auth.getUser().uid,
                                                      info.data.docs.last.id,
                                                      widget
                                                          .whichFavouriteCollection);
                                                  setState(() {});
                                                },
                                                icon: Icon(
                                                  Icons.favorite,
                                                  color: Colors.red,
                                                ));
                                          } else {
                                            return IconButton(
                                                onPressed: () {
                                                  widget.auth.addToFavourites(
                                                      widget.auth.getUser().uid,
                                                      info.data.docs.last.id,
                                                      widget
                                                          .whichFavouriteCollection);
                                                  setState(() {});
                                                },
                                                icon: Icon(Icons
                                                    .favorite_border_outlined));
                                          }
                                        } else {
                                          return CircularProgressIndicator();
                                        }
                                      }),
                                ],
                              ),
                              body: Center(
                                child: Text(info.data.docs.last["content"]),
                              ),
                              floatingActionButtonLocation:
                                  FloatingActionButtonLocation.endFloat,
                              floatingActionButton: FloatingActionButton(
                                backgroundColor: Colors.purple.shade100,
                                foregroundColor: Colors.purpleAccent.shade700,
                                child: Icon(Icons.save_alt_outlined),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SaveQuote(
                                                content: info
                                                    .data.docs.last["content"],
                                                id: info.data.docs.last.id,
                                              )));
                                },
                              ),
                            )),
                      ),
                      Center(
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: _animation.value,
                        ),
                      )
                    ])));
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
