import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

class FoundOrdersx extends StatelessWidget {
  static const routeName = '/FoundOrdersx';
  final userx = FirebaseAuth.instance.currentUser!.uid;
  void _selectPage() async {
    final useri = await FirebaseFirestore.instance
        .collection('business_details')
        .where('second_uid', isEqualTo: userx)
        .get();
    final idx = useri.docs.first.id;
    final sen = useri.docs.first.data()['foundsent'];
    FirebaseFirestore.instance
        .collection('business_details')
        .doc(idx)
        .update({'foundseen': sen});
  }

  @override
  Widget build(BuildContext context) {
    // _selectPage();
    final size = MediaQuery.of(context).size;
    final heightx = size.height;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          SizedBox(height: heightx - 150, child: const SizedBox()),

          // AnimatedTextKit(
          //   animatedTexts: [
          //     TyperAnimatedText(
          //       '',
          //       textStyle: const TextStyle(
          //         fontSize: 20,
          //         color: Colors.cyanAccent,
          //         overflow: TextOverflow.visible,
          //       ),
          //       speed: const Duration(seconds: 5),
          //     )
          //   ],
          //   // totalRepeatCount: 2,
          //   repeatForever: true,
          //   onNext: (p0, p1) {
          //     _selectPage();
          //   },
          // ),
        ])),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.messenger_outline_rounded),
        ));
  }
}
