import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alaqy/authScreenUser.dart';
import 'package:flutter_alaqy/user_main.dart';

import 'numberPhone.dart';

class userChoose extends StatelessWidget {
  static const routeName = '/userChoose';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (ctx, userSnapshotd) {
              if (userSnapshotd.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Text('Loading...'),
                );
              }
              // print(FirebaseAuth.instance.currentUser!.phoneNumber);
              // print(FirebaseAuth.instance.currentUser!.uid);
              if (userSnapshotd.hasData == false) {
                // if (FirebaseAuth.instance.currentUser!.email == 'admin@gmail.com') {
                //   if (userSnapshot.hasData) {
                //     return ChatScreen();
                //   }

                return LoginScreen('customer', false);
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
                    final chatDocs =
                        userSnapshot.hasData ? userSnapshot.data : null;
                    if (userSnapshot.hasData == true) {
                      Future.delayed(const Duration(seconds: 3), (() {
                        FirebaseFirestore.instance
                            .collection('customer_details')
                            .doc(chatDocs!.docs.first.data()['first_uid'])
                            .update({'activated': true, 'businesslast': false});
                      }));
                    }
                    if (userSnapshot.hasData == false) {
                      // if (FirebaseAuth.instance.currentUser!.email == 'admin@gmail.com') {
                      //   if (userSnapshot.hasData) {
                      //     return ChatScreen();
                      //   }
                      Future.delayed(const Duration(seconds: 3), (() {
                        return AuthScreenUser(
                            FirebaseAuth.instance.currentUser!.phoneNumber
                                .toString(),
                            FirebaseAuth.instance.currentUser!.uid,
                            true,
                            false);
                      }));
                    }

                    // print(FirebaseAuth.instance.currentUser!.phoneNumber);
                    // print(FirebaseAuth.instance.currentUser!.uid);

                    return chatDocs!.docs.isNotEmpty
                        ? const UserMain('none')
                        : AuthScreenUser(
                            FirebaseAuth.instance.currentUser!.phoneNumber
                                .toString(),
                            FirebaseAuth.instance.currentUser!.uid,
                            true,
                            false);
                    //    }
                    //        return AuthScreen();
                  });
            }));
  }
}
