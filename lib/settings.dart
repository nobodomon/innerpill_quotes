import 'package:flutter/material.dart';
import 'package:innerpill_quotes/CommonWidgets/common_widgets.dart';
import 'package:innerpill_quotes/Model/models.dart';

import 'authentication_service.dart';

class MySettings extends StatefulWidget {
  MySettings({this.auth, this.logoutCallback});
  final AuthenticationService auth;
  final VoidCallback logoutCallback;
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<MySettings> {
  TextEditingController controller;
  GlobalKey _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  OperationResult validate() {
    if (controller.text == "" || controller.text == null) {
      return OperationResult(success: false, message: "Please enter something");
    } else {
      return OperationResult(success: true, message: "Success");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Change your name"),
        ),
        body: Form(
          autovalidateMode: AutovalidateMode.always,
          key: _formKey,
          child: ListView(
            children: [
              CommonWidgets().commonTextField(controller, () {
                setState(() {});
              }),
              Padding(
                padding: EdgeInsets.all(25),
                child: ElevatedButton(
                  child: Text("Save"),
                  onPressed: () {
                    if (validate().success) {
                      setState(() {
                        widget.auth.setUserName(
                            widget.auth.getUser(), controller.text);
                        Navigator.pop(context);
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
