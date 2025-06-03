import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:graduationpro/adminPages/addappointmentspage.dart';
import 'package:graduationpro/adminPages/addcar.dart';
import 'package:graduationpro/adminPages/careditpartpage.dart';
import 'package:graduationpro/adminPages/dashboardpage.dart';
import 'package:graduationpro/adminPages/edit.dart';
import 'package:graduationpro/adminPages/editcustomers.dart';
import 'package:graduationpro/adminPages/editndltappage.dart';
import 'package:graduationpro/adminPages/editndltpage.dart';
import 'package:graduationpro/customerPages/cartpage.dart';
import 'package:graduationpro/customerPages/homepage.dart';

class adminbottombar extends StatefulWidget {
  const adminbottombar({super.key});

  @override
  State<adminbottombar> createState() => _adminbottombarState();
}

class _adminbottombarState extends State<adminbottombar> {
  int index = 0;
  final pages = [dashboardpage(), careditpartpage(), editndltappage(), edit()];
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
                text: "Dashboard",
              ),
              GButton(
                icon: Icons.handyman_rounded,
                text: "Parts",
              ),
              GButton(
                icon: CupertinoIcons.calendar_badge_plus,
                text: "Appointments",
              ),
              GButton(
                icon: CupertinoIcons.car_detailed,
                text: "Cars",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
