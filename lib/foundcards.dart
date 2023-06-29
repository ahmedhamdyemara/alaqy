import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'ordercarditem.dart';

class foundCards extends StatefulWidget {
  static const routeName = '/foundCards';

  const foundCards({super.key});
  // final String oppi;
//  final String oppoo;

//  Messagess(this.oppoo, this.oppi);
  @override
  State<foundCards> createState() => foundCardsState();
}

class foundCardsState extends State<foundCards> {
  final reportcontroller = TextEditingController();
  dynamic report;

  @override
  Widget build(BuildContext context) {
    final userid = FirebaseAuth.instance.currentUser!.uid;

    final fbm = FirebaseMessaging.instance;
    fbm.getToken();
    //  fbm.subscribeToTopic(notyu);
    fbm.onTokenRefresh;

    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('business_details')
                .where('second_uid', isEqualTo: userid)
                .snapshots(),
            builder: (ctx, chatSnapshottt) {
              if (chatSnapshottt.hasData == false) {
                return const Center(
                  child: Text(
                    'Loading...',
                    style: TextStyle(fontSize: 2),
                  ),
                );
              }
              if (chatSnapshottt.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (chatSnapshottt.hasData == false) {
                return const Center(
                  child: Text(
                    'Loading...',
                    style: TextStyle(fontSize: 2),
                  ),
                );
              }
              final chatDocss =
                  chatSnapshottt.hasData ? chatSnapshottt.data!.docs : null;
              final shopcity = chatDocss!.first.data()['city'];
              final shopcategory = chatDocss.first.data()['category'];
              final docid = chatDocss.first.id;
              final storename = chatDocss.first.data()['store_name'];
              final basicstorename = chatDocss.first.data()['basicstore_name'];

              return chatSnapshottt.hasData == false
                  ? const Center(
                      child: Text('loading'),
                    )
                  : StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('listing')
                          // .where('city', isEqualTo: shopcity)
                          // .where('category', isEqualTo: shopcategory)
                          //   .orderBy('createdAt', descending: true)
                          .snapshots(),
                      builder: (ctx, chatSnapshot) {
                        if (chatSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final chatDocs = chatSnapshot.hasData
                            ? chatSnapshot.data!.docs
                            : null;
                        final List<QueryDocumentSnapshot<Map<String, dynamic>>>
                            arrange = [];
                        final List<QueryDocumentSnapshot<Map<String, dynamic>>>
                            arrangex = [];
                        for (var r = 0; r < chatDocs!.length; r++) {
                          arrangex.add(chatDocs[r]);
                        }
                        arrangex.sort((a, b) =>
                            (a.data()['createdAt'] as Timestamp)
                                .compareTo(b.data()['createdAt']));
                        arrange.addAll(arrangex.reversed);
                        return chatSnapshot.hasData == false
                            ? const Center(
                                child: Text('loading'),
                              )
                            : ListView.builder(
                                reverse: false,

                                ///
                                itemCount: arrange.length,
                                itemBuilder: (ctx, index) => Column(children: [
                                      (arrange[index]
                                              .data()
                                              .containsKey(basicstorename))
                                          ? arrange[index].data()[basicstorename] ==
                                                  'closedx'
                                              ? const SizedBox()
                                              : SizedBox(
                                                  //  height: 160,
                                                  width: double.infinity,
                                                  child:
                                                      arrange[index]
                                                                  ['closed'] ==
                                                              true
                                                          ? Dismissible(
                                                              key: ValueKey(arrange[index]
                                                                  ['idstring']),
                                                              background:
                                                                  Container(
                                                                color: Theme.of(
                                                                        context)
                                                                    .errorColor,
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            20),
                                                                margin:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  horizontal:
                                                                      15,
                                                                  vertical: 4,
                                                                ),
                                                                child:
                                                                    const Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 40,
                                                                ),
                                                              ),
                                                              direction:
                                                                  DismissDirection
                                                                      .endToStart,
                                                              confirmDismiss:
                                                                  (direction) {
                                                                return showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (ctx) =>
                                                                      AlertDialog(
                                                                    title: const Text(
                                                                        'Are you sure?'),
                                                                    content:
                                                                        const Text(
                                                                      'Do you want to remove this order?',
                                                                    ),
                                                                    actions: <
                                                                        Widget>[
                                                                      TextButton(
                                                                        child: const Text(
                                                                            'No'),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(ctx)
                                                                              .pop(false);
                                                                        },
                                                                      ),
                                                                      TextButton(
                                                                        child: const Text(
                                                                            'Yes'),
                                                                        onPressed:
                                                                            () {
                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection(
                                                                                  'listing')
                                                                              .doc(arrange[index][
                                                                                  'idstring'])
                                                                              .update({
                                                                            basicstorename:
                                                                                'closedx'
                                                                          });
                                                                          Navigator.of(ctx)
                                                                              .pop(true);
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                              onDismissed:
                                                                  (direction) {
                                                                //Provider.of<Cart>(context, listen: false).removeItem(productId);
                                                              },
                                                              child: SizedBox(
                                                                  height: 100,
                                                                  width: double
                                                                      .infinity,
                                                                  child: Column(
                                                                      children: [
                                                                        Center(
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                double.infinity,
                                                                            alignment:
                                                                                Alignment.topRight,
                                                                            child: DropdownButton(
                                                                                underline: Container(),
                                                                                icon: const Icon(
                                                                                  Icons.flag_circle_rounded,
                                                                                  color: Colors.black,
                                                                                ),
                                                                                items: const [
                                                                                  DropdownMenuItem(
                                                                                    value: 'report',
                                                                                    child: Text('report'),
                                                                                  ),
                                                                                ],
                                                                                onChanged: (itemIdentifier) async {
                                                                                  if (itemIdentifier == 'report') {
                                                                                    showDialog(
                                                                                        context: context,
                                                                                        builder: (ctx) => AlertDialog(
                                                                                                title: const Text('please write the reason why you report this order'),
                                                                                                content: TextFormField(
                                                                                                  //  key: const ValueKey('username'),
                                                                                                  keyboardType: TextInputType.text,
                                                                                                  enableSuggestions: false,
                                                                                                  controller: reportcontroller,
                                                                                                  validator: (value) {
                                                                                                    if (value != null) {
                                                                                                      return (value.isEmpty) ? 'Please enter a reason' : null;
                                                                                                    }
                                                                                                  },
                                                                                                  decoration: const InputDecoration(labelText: 'report reason'),
                                                                                                  onSaved: (value) {
                                                                                                    if (value != null) {
                                                                                                      setState(() {
                                                                                                        report = value;
                                                                                                      });
                                                                                                    }
                                                                                                  },
                                                                                                ),
                                                                                                actions: <Widget>[
                                                                                                  TextButton(
                                                                                                      child: const Text('ok'),
                                                                                                      onPressed: () async {
                                                                                                        if (reportcontroller.value.text == '') {
                                                                                                          null;
                                                                                                        } else {
                                                                                                          // Future.delayed(const Duration(seconds: 2),
                                                                                                          //     (() {
                                                                                                          Navigator.of(ctx).pop(false);
                                                                                                          //  }));
                                                                                                          showDialog(
                                                                                                            context: context,
                                                                                                            builder: (ctx) => AlertDialog(
                                                                                                              title: const Text('reprt sent!'),
                                                                                                              content: const Text(
                                                                                                                'admins will justify it',
                                                                                                              ),
                                                                                                              actions: <Widget>[
                                                                                                                TextButton(
                                                                                                                  child: const Text('ok'),
                                                                                                                  onPressed: () {
                                                                                                                    Navigator.of(ctx).pop(false);

                                                                                                                    // Navigator.popAndPushNamed(
                                                                                                                    //     context, '/');
                                                                                                                  },
                                                                                                                ),
                                                                                                              ],
                                                                                                            ),
                                                                                                          );
                                                                                                        }
                                                                                                      })
                                                                                                ]));
                                                                                  }
                                                                                }),
                                                                          ),
                                                                        ),
                                                                        Center(
                                                                            child:
                                                                                Text('date:${DateFormat('dd/MM/yyyy hh:mm').format((arrange[index]['createdAt']).toDate())}', style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey))),
                                                                        const Text(
                                                                            'closed',
                                                                            style:
                                                                                TextStyle(fontStyle: FontStyle.italic, color: Colors.red)),
                                                                        AnimatedTextKit(
                                                                          animatedTexts: [
                                                                            ColorizeAnimatedText('<<<<<<<<<    swipe left to remove  the item ',
                                                                                colors: [
                                                                                  Colors.red,
                                                                                  Colors.green,
                                                                                  Colors.redAccent,
                                                                                ],
                                                                                textStyle: const TextStyle(
                                                                                  fontSize: 9,
                                                                                ),
                                                                                speed: const Duration(milliseconds: 100)),
                                                                          ],
                                                                          repeatForever:
                                                                              true,
                                                                        ),
                                                                      ])))
                                                          : Ordercarditem(
                                                              arrange[index]
                                                                  ['idstring'],
                                                              arrange[index]
                                                                  ['createdAt'],
                                                              arrange[index]
                                                                  ['title'],
                                                              arrange[index]
                                                                  ['image_url'],
                                                              arrange[index][
                                                                  'description'],
                                                              arrange[index]
                                                                  ['username'],
                                                              true,
                                                              arrange[index][
                                                                  '${basicstorename}close'],
                                                              arrange[index]
                                                                  [basicstorename],
                                                              basicstorename,
                                                              arrange[index]['${basicstorename}price'],
                                                              basicstorename,
                                                              arrange[index]['basicemail'],
                                                              arrange[index]['closed']))
                                          : const SizedBox(),
                                      (arrange[index]
                                              .data()
                                              .containsKey(basicstorename))
                                          ? arrange[index]
                                                      .data()[basicstorename] ==
                                                  'closedx'
                                              ? const SizedBox()
                                              : const Divider(
                                                  thickness: 3,
                                                  color: Colors.black)
                                          : const SizedBox()
                                    ]));
                      });
            }));
  }
}
