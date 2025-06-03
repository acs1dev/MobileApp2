import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationpro/customerPages/partspage.dart';

class partypepage extends StatefulWidget {
  var carname;
  partypepage({super.key, required this.carname});

  @override
  State<partypepage> createState() => _partypepageState();
}

class _partypepageState extends State<partypepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 60,
          ),
          Container(
            height: 70,
            width: double.infinity,
            alignment: Alignment.center,
            color: Theme.of(context).primaryColor,
            child: Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        size: 45,
                        color: Theme.of(context).accentColor,
                      )),
                ),
                SizedBox(
                  width: 100,
                ),
                Text(
                  widget.carname,
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 70,
          ),
          Text(
            "What kind of part do you want to view ?",
            style: TextStyle(fontSize: 22),
          ),
          SizedBox(
            height: 120,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return partspage(
                    parts: "Mechanical",
                    carname: widget.carname,
                  );
                },
              ));
            },
            child: Container(
              height: 70,
              width: 320,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(80),
                    bottomRight: Radius.circular(80)),
              ),
              child: Text(
                "Mechanical Parts",
                style: TextStyle(
                    color: Theme.of(context).accentColor, fontSize: 22),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return partspage(
                    parts: "Body",
                    carname: widget.carname,
                  );
                },
              ));
            },
            child: Container(
              height: 70,
              width: 320,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(80),
                    bottomRight: Radius.circular(80)),
              ),
              child: Text(
                "Body Parts",
                style: TextStyle(
                    color: Theme.of(context).accentColor, fontSize: 22),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return partspage(
                    parts: "All",
                    carname: widget.carname,
                  );
                },
              ));
            },
            child: Container(
              height: 70,
              width: 320,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(80),
                    bottomRight: Radius.circular(80)),
              ),
              child: Text(
                "All Parts",
                style: TextStyle(
                    color: Theme.of(context).accentColor, fontSize: 22),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
