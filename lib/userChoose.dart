import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_alaqy/authScreenUser.dart';
import 'package:flutter_alaqy/business_main.dart';
import 'package:flutter_alaqy/user_main.dart';
import 'package:provider/provider.dart';
// import 'auth_screen.dart';
// import 'chat_screen.dart';
// import 'splash_screen.dart';
// import 'auth.dart';
import 'package:intl/intl_standalone.dart';
import 'dart:io';

import 'numberPhone.dart';

class userChoose extends StatelessWidget {
  static const routeName = '/userChoose';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Text('Loading...'),
                );
              }
              // print(FirebaseAuth.instance.currentUser!.phoneNumber);
              // print(FirebaseAuth.instance.currentUser!.uid);
              if (userSnapshot.hasData == false) {
                // if (FirebaseAuth.instance.currentUser!.email == 'admin@gmail.com') {
                //   if (userSnapshot.hasData) {
                //     return ChatScreen();
                //   }

                return LoginScreen('customer');
              }

              return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('customer_details')
                      .where('second_uid',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      // .doc(FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (ctx, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: Text('Loading...'),
                      );
                    }
                    final chatDocs = userSnapshot.data!;

                    // print(FirebaseAuth.instance.currentUser!.phoneNumber);
                    // print(FirebaseAuth.instance.currentUser!.uid);
                    if (userSnapshot.hasData == false) {
                      // if (FirebaseAuth.instance.currentUser!.email == 'admin@gmail.com') {
                      //   if (userSnapshot.hasData) {
                      //     return ChatScreen();
                      //   }

                      return AuthScreenUser(
                          FirebaseAuth.instance.currentUser!.phoneNumber
                              .toString(),
                          FirebaseAuth.instance.currentUser!.uid,
                          true);
                    }

                    return chatDocs.docs.isNotEmpty
                        ? UserMain()
                        : AuthScreenUser(
                            FirebaseAuth.instance.currentUser!.phoneNumber
                                .toString(),
                            FirebaseAuth.instance.currentUser!.uid,
                            true);
                    //    }
                    //        return AuthScreen();
                  });
            }));
  }
}
