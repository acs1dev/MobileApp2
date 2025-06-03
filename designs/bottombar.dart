import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:graduationpro/customerPages/cartpage.dart';
import 'package:graduationpro/customerPages/homepage.dart';
import 'package:graduationpro/customerPages/profile.dart';
import 'package:graduationpro/customerPages/reservationpage.dart';

class bottombar extends StatefulWidget {
  const bottombar({super.key});

  @override
  State<bottombar> createState() => _bottombarState();
}

class _bottombarState extends State<bottombar> {
  int index = 0;
  final pages = [homepage(), cartpage(), reservationpage(), profile()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: Container(
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GNav(
            backgroundColor: Theme.of(context).primaryColor,
            color: Theme.of(context).accentColor,
            activeColor: Theme.of(context).accentColor,
            tabBackgroundColor: Color.fromARGB(255, 2, 1, 63),
            padding: EdgeInsets.all(18),
            gap: 10,
            // ignore: prefer_const_literals_to_create_immutables
            onTabChange: (index) => setState(() => this.index = index),
            tabs: [
              GButton(
                icon: CupertinoIcons.home,
                text: "Home",
              ),
              GButton(
                icon: CupertinoIcons.cart_fill,
                text: "Cart",
              ),
              GButton(
                icon: CupertinoIcons.clock_fill,
                text: "Reservation",
              ),
              GButton(
                icon: CupertinoIcons.profile_circled,
                text: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
