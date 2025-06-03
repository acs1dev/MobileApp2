import 'package:flutter/material.dart';

class TextBoxDesign {
  InputDecoration TextInputo(
      [String labelText = "", hintText = "", var prefixIcon = ""]) {
    return InputDecoration(
      prefixIcon: Icon(prefixIcon, color: Color.fromRGBO(0, 10, 143, 0.726)),
      labelText: labelText,
      hintText: hintText,
      // contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide:
              BorderSide(width: 2, color: Color.fromRGBO(0, 10, 143, 0.726))),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide:
              BorderSide(width: 2, color: Color.fromRGBO(0, 10, 143, 0.726))),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide: BorderSide(color: Colors.red, width: 2.0)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide: BorderSide(color: Colors.red, width: 2.0)),
    );
  }
}
