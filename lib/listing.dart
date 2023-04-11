import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
// import 'categoriesscreen.dart';
// import 'welcome.dart';
// import 'package:intl/intl_standalone.dart';
// import 'dart:io';
// import 'package:provider/provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'auth_screen.dart';
// import 'great_places.dart';
// import 'places_list_screen.dart';
// import 'add_place_screen.dart';
// import 'place_detail_screen.dart';
// import 'auth.dart';
// import 'splash_screen.dart';

class Listing extends StatelessWidget {
  static const routeName = '/listing';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            //  mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 8,
                  ),
                  width: 120,
                  height: 40,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12)),
                    color: Colors.purple,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 2,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: 120,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12)),
                      color: Colors.white,
                    ),
                    child: AnimatedTextKit(
                        animatedTexts: [
                          ScaleAnimatedText('Switch to business account',
                              textStyle:
                                  TextStyle(color: Colors.deepPurple.shade400),
                              textAlign: TextAlign.center,
                              duration: const Duration(milliseconds: 2200),
                              scalingFactor: 0.1),
                          ScaleAnimatedText('press here',
                              textStyle:
                                  TextStyle(color: Colors.deepPurple.shade400),
                              textAlign: TextAlign.center,
                              duration: const Duration(milliseconds: 2200),
                              scalingFactor: 0.1)
                        ],
                        repeatForever: true,
                        pause: const Duration(milliseconds: 0),
                        onTap: () {}),
                  )),
            ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.messenger_outline_rounded),
        ));
  }
}
