import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alaqy/AllOrders.dart';
import 'package:flutter_alaqy/FoundOrders.dart';

import 'alaaqyProcess.dart';
import 'listing.dart';

// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'Searchprodtypeonly.dart';
// import 'bossmanageroverview.dart';
// import 'category.dart';
// import 'Listing.dart';
// import 'ordershistory.dart';
// import 'badge.dart';
// import 'cart_screen.dart';
// import 'categoriesscreen.dart';
// import 'categoryitem.dart';
// import 'package:provider/provider.dart';
// import 'app_drawer.dart';
// import 'cart.dart';
// import 'categories.dart';

class BusinessMain extends StatefulWidget {
  static const routeName = '/BusinessMain';

  @override
  BusinessMainState createState() => BusinessMainState();
}

class BusinessMainState extends State<BusinessMain> {
  List<Map<String, Object>>? _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {
        'page': AllOrders(), //
        'title': 'كل الطلبات',
      },
      {
        'page': FoundOrders(), //
        'title': 'موجود',
      },
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pages![_selectedPageIndex]['title'].toString(),
          style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
        ),
        actions: [
          DropdownButton(
            underline: Container(),
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                value: 'logout',
                child: Container(
                  child: Row(
                    children: const <Widget>[
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed('/');
              }
            },
          )
        ],
      ),
      //  drawer: AppDrawer(),
      body: _pages![_selectedPageIndex]['page'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.cyanAccent,
        currentIndex: _selectedPageIndex,
        // type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            //   backgroundColor: Colors.cyanAccent,
            icon: Icon(Icons.all_inclusive),
            label: 'كل الطلبات',
          ),
          BottomNavigationBarItem(
              //   backgroundColor: Colors.cyanAccent,
              icon: Icon(Icons.navigation),
              label: 'موجود'),
        ],
      ),
    );
  }
}
