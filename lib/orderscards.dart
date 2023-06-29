import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'ordercarditem.dart';

class OrdersCards extends StatefulWidget {
  static const routeName = '/OrdersCards';

  const OrdersCards({super.key});
  // final String oppi;
//  final String oppoo;

//  Messagess(this.oppoo, this.oppi);
  @override
  State<OrdersCards> createState() => OrdersCardsState();
}

class OrdersCardsState extends State<OrdersCards> {
  dynamic report;

  @override
  // void initState() {
  //   super.initState();
  //   final fbm = FirebaseMessaging.instance;
  //   fbm.requestNotificationPermissions();
  //   fbm.configure(onMessage: (msg) {
  //     print(msg);
  //     return;
  //   }, onLaunch: (msg) {
  //     print(msg);
  //     return;
  //   }, onResume: (msg) {
  //     print(msg);
  //     return;
  //   });
  //   fbm.getToken();
  //   //  fbm.unsubscribeFromTopic('beek');
  // }
  // void initState() {
  //   super.initState();
  //   FirebaseMessaging.instance
  //       .getInitialMessage()
  //       .then((RemoteMessage message) {
  //         if (message != null) {
  //           // Navigator.pushNamed(context, '/message',
  //           //     arguments: MessageArguments(message, true));
  //         }
  //       } as FutureOr Function(RemoteMessage? value));
  // }

  Widget build(BuildContext context) {
    final userid = FirebaseAuth.instance.currentUser!.uid;
    final reportcontroller = TextEditingController();

    final fbm = FirebaseMessaging.instance;
    fbm.getToken();
    //  fbm.subscribeToTopic(notyu);
    fbm.onTokenRefresh;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('business_details')
            .where('second_uid', isEqualTo: userid)
            .snapshots(),
        builder: (ctx, chatSnapshottt) {
          if (chatSnapshottt.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final chatDocss =
              chatSnapshottt.hasData ? chatSnapshottt.data!.docs : null;
          final shopcity = chatDocss!.first.data()['city_id'];
          final shopcategory = chatDocss.first.data()['category_id'];
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
                      .where('city_id', isEqualTo: shopcity)
                      .where('category_id', isEqualTo: shopcategory)
                      //  .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (ctx, chatSnapshot) {
                    if (chatSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final chatDocs =
                        chatSnapshot.hasData ? chatSnapshot.data!.docs : null;
                    final List<QueryDocumentSnapshot<Map<String, dynamic>>>
                        arrange = [];
                    final List<QueryDocumentSnapshot<Map<String, dynamic>>>
                        arrangex = [];
                    for (var r = 0; r < chatDocs!.length; r++) {
                      arrange.add(chatDocs[r]);
                    }
                    arrange.sort((a, b) => (a.data()['createdAt'] as Timestamp)
                        .compareTo(b.data()['createdAt']));
                    arrangex.addAll(arrange.reversed);
                    //  arrange.reversed;
                    return chatSnapshot.hasData == false
                        ? const Center(
                            child: Text('loading'),
                          )
                        : ListView.builder(
                            // reverse: true,
                            itemCount: arrangex.length,
                            itemBuilder: (ctx, index) => Column(children: [
                                  (arrangex[index]
                                          .data()
                                          .containsKey(basicstorename))
                                      ? const SizedBox()
                                      : SizedBox(
                                          //  height: 160,
                                          width: double.infinity,
                                          child: arrangex[index]['closed'] ==
                                                  true
                                              ? Dismissible(
                                                  key: ValueKey(arrangex[index]
                                                      ['idstring']),
                                                  background: Container(
                                                    color: Theme.of(context)
                                                        .errorColor,
                                                    alignment:
                                                        Alignment.centerRight,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 20),
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 15,
                                                      vertical: 4,
                                                    ),
                                                    child: const Icon(
                                                      Icons.delete,
                                                      color: Colors.white,
                                                      size: 40,
                                                    ),
                                                  ),
                                                  direction: DismissDirection
                                                      .endToStart,
                                                  confirmDismiss: (direction) {
                                                    return showDialog(
                                                      context: context,
                                                      builder: (ctx) =>
                                                          AlertDialog(
                                                        title: const Text(
                                                            'Are you sure?'),
                                                        content: const Text(
                                                          'Do you want to remove this order?',
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: const Text(
                                                                'No'),
                                                            onPressed: () {
                                                              Navigator.of(ctx)
                                                                  .pop(false);
                                                            },
                                                          ),
                                                          TextButton(
                                                            child: const Text(
                                                                'Yes'),
                                                            onPressed: () {
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'listing')
                                                                  .doc(arrangex[
                                                                          index]
                                                                      [
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
                                                  onDismissed: (direction) {
                                                    //Provider.of<Cart>(context, listen: false).removeItem(productId);
                                                  },
                                                  child: SizedBox(
                                                      height: 100,
                                                      width: double.infinity,
                                                      child: Column(children: [
                                                        Container(
                                                            width:
                                                                double.infinity,
                                                            alignment: Alignment
                                                                .topRight,
                                                            child:
                                                                DropdownButton(
                                                                    underline:
                                                                        Container(),
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .flag_circle_rounded,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    items: const [
                                                                      DropdownMenuItem(
                                                                        value:
                                                                            'report',
                                                                        child: Text(
                                                                            'report'),
                                                                      ),
                                                                    ],
                                                                    onChanged:
                                                                        (itemIdentifier) async {
                                                                      if (itemIdentifier ==
                                                                          'report') {
                                                                        showDialog(
                                                                            context:
                                                                                context,
                                                                            builder: (ctx) =>
                                                                                AlertDialog(
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
                                                                                                title: const Text('report sent!'),
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

                                                                                            final lisdoc = await FirebaseFirestore.instance.collection('customer_details').where('second_uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
                                                                                            final busid = lisdoc.docs.last.id;
                                                                                            FirebaseFirestore.instance.collection('listing_report').doc(arrangex[index]['idstring']).set({
                                                                                              'time': Timestamp.now()
                                                                                            });
                                                                                            FirebaseFirestore.instance.collection('listing_report').doc(arrangex[index]['idstring']).collection('reporters').doc(busid).set({
                                                                                              'reportid': arrangex[index]['idstring'],
                                                                                              'listid': arrangex[index]['idstring'],
                                                                                              'businessid': busid,
                                                                                              'closed case': false,
                                                                                              'notes': '',
                                                                                              'reasons': reportcontroller.value.text,
                                                                                            });
                                                                                            //_report();
                                                                                          }
                                                                                        },
                                                                                      ),
                                                                                    ]));
                                                                      }
                                                                    })),
                                                        Center(
                                                            child: Text(
                                                                'date:${DateFormat('dd/MM/yyyy hh:mm').format((arrangex[index]['createdAt']).toDate())}',
                                                                style: const TextStyle(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                    color: Colors
                                                                        .grey))),
                                                        const Text('closed',
                                                            style: TextStyle(
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                color: Colors
                                                                    .red)),
                                                        AnimatedTextKit(
                                                          animatedTexts: [
                                                            ColorizeAnimatedText(
                                                                '<<<<<<<<<    swipe left to remove  the item ',
                                                                colors: [
                                                                  Colors.red,
                                                                  Colors.green,
                                                                  Colors
                                                                      .redAccent,
                                                                ],
                                                                textStyle:
                                                                    const TextStyle(
                                                                  fontSize: 9,
                                                                ),
                                                                speed: const Duration(
                                                                    milliseconds:
                                                                        100)),
                                                          ],
                                                          repeatForever: true,
                                                        ),
                                                      ])))
                                              : Ordercarditem(
                                                  arrangex[index]['idstring'],
                                                  arrangex[index]['createdAt'],
                                                  arrangex[index]['title'],
                                                  arrangex[index]['image_url'],
                                                  arrangex[index]
                                                      ['description'],
                                                  arrangex[index]['username'],
                                                  false,
                                                  false,
                                                  'off',
                                                  storename,
                                                  '',
                                                  basicstorename,
                                                  arrangex[index]['basicemail'],
                                                  arrangex[index]['closed'],
                                                ),
                                        ),
                                  (arrangex[index]
                                          .data()
                                          .containsKey(basicstorename))
                                      ? const SizedBox()
                                      : const Divider(
                                          thickness: 3, color: Colors.black)
                                ]));
                  });
        });
  }
}
