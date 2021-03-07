import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:innerpill_quotes/Model/Styles.dart';
import 'package:innerpill_quotes/Model/models.dart';
import 'package:innerpill_quotes/MyUser.dart';
import 'package:innerpill_quotes/authentication_service.dart';
import 'package:innerpill_quotes/home.dart';
import 'package:innerpill_quotes/sign_in.dart';
import 'package:innerpill_quotes/spinny.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'creator_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: Style.light(),
        darkTheme: Style.dark(),
        home: new RootPage(
            auth: new AuthenticationService(
                FirebaseAuth.instance, FirebaseFirestore.instance)));
  }
}

class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final AuthenticationService auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  UserProfile currUser;
  @override
  // ignore: must_call_super
  void initState() {
    super.initState();
    widget.auth.getCurrUserInfo().then((user) {
      setState(() {
        if (user != null) {
          currUser = user;
        } else {}
        authStatus =
            user == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void loginCallback() {
    widget.auth.getCurrUserInfo().then((user) {
      setState(() {
        currUser = user;
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      currUser = null;
      widget.auth.signOut();
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return Spinny();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new SignInPage(
          auth: widget.auth,
          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
        return FutureBuilder(
            future: widget.auth.getCurrUserInfo(),
            builder: (BuildContext context, AsyncSnapshot<UserProfile> user) {
              if (user.hasData) {
                if (currUser.fbUser.uid.length > 0 && currUser != null) {
                  print(currUser.fsUser.data()["userType"].toString() +
                      "Usertype");
                  switch (currUser.fsUser.data()["userType"]) {
                    case 0:
                      return HomePage(
                        auth: widget.auth,
                        logoutCallback: logoutCallback,
                      );
                      break;
                    case 1:
                      return CreatorHomePage(
                        auth: widget.auth,
                        logoutCallback: logoutCallback,
                      );
                      break;
                    case -1:
                      return SignInPage(
                        auth: widget.auth,
                        loginCallback: loginCallback,
                      );
                      break;
                    default:
                      logoutCallback();
                      return SignInPage(
                        auth: widget.auth,
                        loginCallback: loginCallback,
                      );
                      break;
                  }
                } else {
                  return Spinny();
                }
              } else {
                return Spinny();
              }
            });
      default:
        return Spinny();
        break;
    }
  }
}
