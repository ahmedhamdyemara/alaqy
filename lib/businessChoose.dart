import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alaqy/business_main.dart';
import 'package:flutter_alaqy/userToBusinessScreen.dart';

import 'numberPhone.dart';

class businessChoose extends StatelessWidget {
  static const routeName = '/businessChoose';

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

                return LoginScreen('business', false);
              }

              return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('business_details')
                      .where('second_uid',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      // .doc(FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (ctx, userSnapshot) {
                    if (userSnapshot.hasData == true) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: Text('Loading...'),
                        );
                      }
                    }
                    if (userSnapshot.hasData == false) {
                      return StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('customer_details')
                              .where('second_uid',
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser!.uid)
                              // .doc(FirebaseAuth.instance.currentUser!.uid)
                              .snapshots(),
                          builder: (ctx, userSnapshot) {
                            if (userSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: Text('Loading...'),
                              );
                            }
                            final chatDocss = userSnapshot.data;

                            // print(FirebaseAuth.instance.currentUser!.phoneNumber);
                            // print(FirebaseAuth.instance.currentUser!.uid);
                            // if (userSnapshot.hasData == false) {
                            // if (FirebaseAuth.instance.currentUser!.email == 'admin@gmail.com') {
                            //   if (userSnapshot.hasData) {
                            //     return ChatScreen();
                            //   }

                            //   return AuthScreenBusiness(
                            //       FirebaseAuth
                            //           .instance.currentUser!.phoneNumber
                            //           .toString(),
                            //       FirebaseAuth.instance.currentUser!.uid,
                            //       true,
                            //       '');
                            // }

                            return chatDocss!.docs.isEmpty
                                ? LoginScreen('business', false)
//  AuthScreenBusiness(
//                                       FirebaseAuth
//                                           .instance.currentUser!.phoneNumber
//                                           .toString(),
//                                       FirebaseAuth.instance.currentUser!.uid,
//                                       true,
//                                       '')
                                : UserToBusinessScreen(
                                    chatDocss.docs.first.data()['phone_num'],
                                    chatDocss.docs.first.data()['first_uid'],
                                    chatDocss.docs.first.data()['second_uid'],
                                    chatDocss.docs.first.data()['username'],
                                  );
                            //    }
                            //        return AuthScreen();
                          });
                    }

                    final chatDocs =
                        userSnapshot.hasData ? userSnapshot.data : null;
                    final keyid = chatDocs!.docs.isNotEmpty
                        ? chatDocs.docs.first.id
                        : null;

                    chatDocs.docs.isNotEmpty
                        ? FirebaseFirestore.instance
                            .collection('customer_details')
                            .doc(keyid)
                            .update({'businesslast': true})
                        : null;
                    return chatDocs.docs.isNotEmpty
                        ? const BusinessMain('none')
                        : StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('customer_details')
                                .where('second_uid',
                                    isEqualTo:
                                        FirebaseAuth.instance.currentUser!.uid)
                                // .doc(FirebaseAuth.instance.currentUser!.uid)
                                .snapshots(),
                            builder: (ctx, userSnapshot) {
                              if (userSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: Text('Loading...'),
                                );
                              }
                              final chatDocss = userSnapshot.data;

                              // print(FirebaseAuth.instance.currentUser!.phoneNumber);
                              // print(FirebaseAuth.instance.currentUser!.uid);
                              // if (userSnapshot.hasData == false) {
                              // if (FirebaseAuth.instance.currentUser!.email == 'admin@gmail.com') {
                              //   if (userSnapshot.hasData) {
                              //     return ChatScreen();
                              //   }

                              //   return AuthScreenBusiness(
                              //       FirebaseAuth
                              //           .instance.currentUser!.phoneNumber
                              //           .toString(),
                              //       FirebaseAuth.instance.currentUser!.uid,
                              //       true,
                              //       '');
                              // }

                              return chatDocss!.docs.isEmpty
                                  ? LoginScreen('business', false)
//  AuthScreenBusiness(
//                                       FirebaseAuth
//                                           .instance.currentUser!.phoneNumber
//                                           .toString(),
//                                       FirebaseAuth.instance.currentUser!.uid,
//                                       true,
//                                       '')
                                  : UserToBusinessScreen(
                                      chatDocss.docs.first.data()['phone_num'],
                                      chatDocss.docs.first.data()['first_uid'],
                                      chatDocss.docs.first.data()['second_uid'],
                                      chatDocss.docs.first.data()['username'],
                                    );
                              //    }
                              //        return AuthScreen();
                            });
                  });
            }));
  }
}
