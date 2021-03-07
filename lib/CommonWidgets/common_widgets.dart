import 'package:flutter/material.dart';

class CommonWidgets {
  Widget commonTextField(
      TextEditingController controller, VoidCallback onPressAction) {
    return Padding(
      padding: EdgeInsets.all(25),
      child: TextFormField(
        controller: controller,
        decoration: new InputDecoration(
            labelText: "Enter new display name",
            fillColor: Colors.white,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: new BorderSide(color: Colors.purple.shade700),
            ),
            focusedBorder: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: new BorderSide(color: Colors.purple.shade700),
            ),
            errorBorder: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: new BorderSide(color: Colors.purple.shade700),
            ),
            labelStyle: TextStyle(color: Colors.purple.shade700)
            //fillColor: Colors.green
            ),
        validator: (val) {
          if (val.length == 0) {
            return "Name cannot be empty";
          } else {
            return null;
          }
        },
        onChanged: (String x) {
          onPressAction();
        },
      ),
    );
  }
}
