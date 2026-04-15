import 'dart:io';
import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:flutter/material.dart';
import 'package:snag/view/screens/user/user_home/user_home.dart';
import 'package:snag/view/screens/user/user_my_offers/u_my_offers.dart';
import 'package:snag/view/screens/user/user_plan_meetups/user_plan_meetups.dart';
import 'package:snag/view/screens/user/user_settings/u_settings.dart';
import 'package:snag/view/screens/user/user_scan_qr/u_scan_qr.dart';

// ignore: must_be_immutable
class UserNavBar extends StatefulWidget {
  @override
  _UserNavBarState createState() => _UserNavBarState();
}

class _UserNavBarState extends State<UserNavBar> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  void _getCurrentIndex(int index) => setState(() {
    _currentIndex = index;
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> _items = [
      {'icon': Assets.imagesHome, 'label': 'Home'},
      // TODO: Uncomment to enable Explore feature
      // {'icon': Assets.imagesExplore, 'label': 'Explore'},
      // TODO: Uncomment to enable Meetup feature
      // {'icon': Assets.imagesMeetup, 'label': 'Meetup'},
      {'icon': Assets.imagesOffers, 'label': 'My Offers'},
      {'icon': Assets.imagesSettings, 'label': 'Account'},
    ];

    final List<Widget> _screens = [
      UserHome(),
      // TODO: Uncomment to enable Explore feature
      // UScanQr(),
      // TODO: Uncomment to enable Meetup feature
      // UserPlanMeetups(),
      UMyOffers(),
      USettings(),
    ];

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildNavBar(_items),
    );
  }

  Container _buildNavBar(List<Map<String, dynamic>> _items) {
    return Container(
      height: Platform.isIOS ? null : 65,
      decoration: BoxDecoration(
        color: kPrimaryColor,
        border: Border(top: BorderSide(color: kBorderColor, width: 1)),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -4),
            blurRadius: 30,
            spreadRadius: -2,
            color: kTertiaryColor.withValues(alpha: 0.10),
          ),
        ],
      ),
      child: BottomNavigationBar(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        selectedFontSize: 10,
        unselectedFontSize: 10,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        backgroundColor: Colors.transparent,
        selectedItemColor: kSecondaryColor,
        unselectedItemColor: kTertiaryColor,
        currentIndex: _currentIndex,
        onTap: (index) => _getCurrentIndex(index),
        items: List.generate(_items.length, (index) {
          var data = _items[index];
          return BottomNavigationBarItem(
            icon: Container(
              margin: EdgeInsets.only(bottom: 2),
              height: 32,
              width: 32,
              child: Center(
                child: ImageIcon(AssetImage(data["icon"]), size: 24),
              ),
            ),
            label: data["label"],
          );
        }),
      ),
    );
  }
}
