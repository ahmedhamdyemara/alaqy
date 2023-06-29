import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alaqy/businessChoose.dart';

import 'updateuser.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
            height: 500,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  AppBar(
                    title: const Text('alaqy'),
                    automaticallyImplyLeading: false,
                  ),
                  const Divider(),
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
                                  textStyle: TextStyle(
                                      color: Colors.deepPurple.shade400),
                                  textAlign: TextAlign.center,
                                  duration: const Duration(milliseconds: 2200),
                                  scalingFactor: 0.1),
                              ScaleAnimatedText('press here',
                                  textStyle: TextStyle(
                                      color: Colors.deepPurple.shade400),
                                  textAlign: TextAlign.center,
                                  duration: const Duration(milliseconds: 2200),
                                  scalingFactor: 0.1)
                            ],
                            repeatForever: true,
                            pause: const Duration(milliseconds: 0),
                            onTap: () async {
                              // print('switch');
                              // Navigator.pushReplacement(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => businessChoose()));
                              Navigator.of(context).pushReplacementNamed(
                                  businessChoose.routeName);
                            }),
                      )),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.exit_to_app),
                    title: const Text('Logout'),
                    onTap: () async {
                      final userdoc = await FirebaseFirestore.instance
                          .collection('customer_details')
                          .where('second_uid',
                              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                          .get();
                      if (userdoc.docs.first.exists) {
                        final userdocid = userdoc.docs.first.id;
                        FirebaseFirestore.instance
                            .collection('customer_details')
                            .doc(userdocid)
                            .update({
                          'state': 'offline',
                          'lastseen': Timestamp.now(),
                        });
                      }
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushReplacementNamed('/');
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.account_box_outlined),
                    title: const Text('My account'),
                    onTap: () {
                      Navigator.of(context).pushNamed(UpdateUser.routeName);
                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => UpdateUser()));
                    },
                  ),
                ],
              ),
            )));
  }
}
