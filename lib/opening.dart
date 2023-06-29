import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alaqy/business_main.dart';
import 'package:flutter_alaqy/main.dart';
import 'package:flutter_alaqy/user_main.dart';

import 'SPLASHSCREEN.dart';

class opening extends StatelessWidget {
  static const routeName = '/opening';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('customer_details')
                .where('second_uid',
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                // .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (ctx, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return
// const Center(
//                   child: Text('Loading...'),
//                 );
                    SplashScreen();
              }
              final chatDocs = userSnapshot.data!;

              // print(FirebaseAuth.instance.currentUser!.phoneNumber);
              // print(FirebaseAuth.instance.currentUser!.uid);
              if (userSnapshot.hasData == false) {
                // if (FirebaseAuth.instance.currentUser!.email == 'admin@gmail.com') {
                //   if (userSnapshot.hasData) {
                //     return ChatScreen();
                //   }
                //  Navigator.popAndPushNamed(context, userChoose.routeName);
                return const MyHomePage(title: 'Alaqy');
                //  return userChoose();
              }

              return chatDocs.docs.isNotEmpty
                  ? chatDocs.docs.first.data()['activated'] == false
                      ? const BusinessMain('none')
                      : chatDocs.docs.first.data()['businesslast'] == true
                          ? const BusinessMain('none')
                          : const UserMain('none')
                  : const MyHomePage(title: 'Alaqy');
              // : AuthScreenUser(
              //     FirebaseAuth.instance.currentUser!.phoneNumber.toString(),
              //     FirebaseAuth.instance.currentUser!.uid,
              //     true);
              //    }
              //        return AuthScreen();
            }));
  }
}
