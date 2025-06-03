import 'package:flutter/material.dart';

class header extends StatefulWidget {
  var label;
  header({super.key, required this.label});

  @override
  State<header> createState() => _headerState();
}

class _headerState extends State<header> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: Theme.of(context).primaryColor,
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Icon(
            widget.label,
            color: Theme.of(context).accentColor,
            size: 45,
          )
        ],
      ),
    );
  }
}
