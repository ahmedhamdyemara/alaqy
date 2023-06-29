import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'badge.dart';
import 'listingcardsdetailsscreen.dart';

class ListingCardsItem extends StatelessWidget {
  final String id;
  final Timestamp createdAt;
  final String title;
  final String imageurl;
  final String description;
  const ListingCardsItem(
      this.id, this.createdAt, this.title, this.imageurl, this.description,
      {super.key});

  @override
  Widget build(BuildContext context) {
    int badgoo = 0;

    return GestureDetector(
        onTap: () async {
          final sub = await FirebaseFirestore.instance
              .collection('listing')
              .doc(id.toString())
              .get();
          final see = sub.data()!['seen'];
          final mee = sub.data()!['messages'];
          final sen = sub.data()!['sent'];
          final stz = (([sub.data()!['storesidz']].length) - 1);
          final sti = [sub.data()!['storesi']];

          final subx = sen - mee;
          final seenx = see - subx;
          FirebaseFirestore.instance
              .collection('listing')
              .doc(id.toString())
              .update({'seen': sen, 'storesi': stz});
          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => ListingCardsDetailsScreen(
                  id, createdAt, title, imageurl, description)));
        },
        child: Dismissible(
          key: ValueKey(id),
          background: Container(
            color: Theme.of(context).errorColor,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 4,
            ),
            child: const Icon(
              Icons.close_outlined,
              color: Colors.white,
              size: 40,
            ),
          ),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) {
            return showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Are you sure?'),
                content: const Text(
                  'Do you want to close this order?',
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('No'),
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                    },
                  ),
                  TextButton(
                    child: const Text('Yes'),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('listing')
                          .doc(id.toString())
                          .update({'closed': true});
                      FirebaseFirestore.instance
                          .collection('listdetails')
                          .doc(id.toString())
                          .update({'closed': true});
                      Navigator.of(ctx).pop(true);
                    },
                  ),
                ],
              ),
            );
          },
          onDismissed: (direction) {
            //Provider.of<Cart>(context, listen: false).removeItem(productId);
          },
          child: Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 4,
            ),
            child: Padding(
                padding: const EdgeInsets.all(8),
                // child: SizedBox(
                //     height: 150,
                child: Column(children: [
                  // Container(
                  //     width: double.infinity,
                  //     alignment: Alignment.topRight,
                  //     child: DropdownButton(
                  //       underline: Container(),
                  //       icon: const Icon(
                  //         Icons.flag_circle_rounded,
                  //         color: Colors.black,
                  //       ),
                  //       items: const [
                  //         DropdownMenuItem(
                  //           value: 'report',
                  //           child: Text('report'),
                  //         ),
                  //       ],
//                         onChanged: (itemIdentifier) async {
//                           if (itemIdentifier == 'report') {
//                             final lisdoc = await FirebaseFirestore.instance
//                       .collection('customer_details')
//                       .where('second_uid',
//                           isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//                                 .get();
//                             final busid = lisdoc.docs.last.id;
//                             FirebaseFirestore.instance
//                                 .collection('reportlisting')
//                                 .doc(id.toString())
//                                 .set({
//                               'reportid': id,
//                               'listid': id,
// 'businessid': busid,
// 'closed case': false,'notes': '','reasons':'',
//                             });
//                             //_report();
//                           }
//                         },
                  //  )),
                  Center(
                      child: Text(
                    'title:$title',
                    style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  )),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('listing')
                                .doc(id.toString())
                                .snapshots(),
                            builder: (ctx, userSnapshot) {
                              if (userSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: Text(
                                    'Loading...',
                                    style: TextStyle(fontSize: 2),
                                  ),
                                );
                              }
                              final chatDocs = userSnapshot.hasData
                                  ? userSnapshot.data
                                  : null;

                              if (userSnapshot.hasData == true) {
                                final badgo1 =
                                    ([chatDocs!.data()!['storesidz']].length) -
                                        1;
                                final badgo2 =
                                    (chatDocs.data()!['storesi']) as num;

                                badgoo = badgo1 - badgo2.toInt();
                              }
                              final lito = [];
                              //final List<String> items = [];
                              for (var i = 0;
                                  i <
                                      [chatDocs!.data()!['storesidz']]
                                          .toList()
                                          .length;
                                  i++) {
                                lito.add([chatDocs.data()!['storesidz']][i]);
                              }

                              return
// bads != 0
//                                   ?

                                  StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('reply_comment')
                                          .doc(id.toString())
                                          .snapshots(),
                                      builder: (ctx, chatSnapshottt) {
                                        if (chatSnapshottt.connectionState ==
                                            ConnectionState.waiting) {
                                          return chatSnapshottt.hasData
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : const Center(
                                                  child: Text('loading'),
                                                );
                                        }

                                        final chatDocs = chatSnapshottt.data!;
                                        return chatDocs.exists
                                            ? StreamBuilder(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('reply_comment')
                                                    .doc(id.toString())
                                                    .collection('reply')
                                                    .snapshots(),
                                                builder: (ctx, chatSnapshotfx) {
                                                  if (chatSnapshotfx
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return chatSnapshotfx
                                                            .hasData
                                                        ? const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          )
                                                        : const Center(
                                                            child:
                                                                Text('loading'),
                                                          );
                                                  }

                                                  final chatDocsfx =
                                                      chatSnapshotfx.data!.docs;
                                                  final number =
                                                      chatDocsfx.length;
                                                  //                       return Badgee(
                                                  //                         value: number.toString(),
                                                  //                         color: Colors.black12,
                                                  //                         child: const Icon(
                                                  //                           Icons.store_outlined,
                                                  //                           color: Colors.cyanAccent,
                                                  //                         ),
                                                  //                       );
                                                  //                     })
                                                  //                 : const Icon(
                                                  //                     Icons.store_outlined,
                                                  //                     color: Colors.blueGrey,
                                                  //                   );
                                                  //           });
                                                  // }),
                                                  return StreamBuilder(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection('listing')
                                                          .doc(id.toString())
                                                          .snapshots(),
                                                      builder:
                                                          (ctx, userSnapshot) {
                                                        if (userSnapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return const Center(
                                                            child: Text(
                                                              'Loading...',
                                                              style: TextStyle(
                                                                  fontSize: 2),
                                                            ),
                                                          );
                                                        }
                                                        final chatDocs =
                                                            userSnapshot.hasData
                                                                ? userSnapshot
                                                                    .data
                                                                : null;

                                                        if (userSnapshot
                                                                .hasData ==
                                                            true) {
                                                          final badgo1 =
                                                              chatDocs!.data()![
                                                                  'sent'];
                                                          final badgo2 =
                                                              chatDocs.data()![
                                                                  'seen'];
                                                          final badgox =
                                                              chatDocs.data()![
                                                                  'messages'];
                                                          final badgoxx = chatDocs
                                                                  .data()![
                                                              'messages_seen'];

                                                          badgoo = (badgo1 -
                                                                  badgox) -
                                                              (badgo2 -
                                                                  badgoxx);
                                                        }
                                                        print(
                                                            '$badgoo xxxxxxxx');
                                                        print(
                                                            '$number  cccccccc');
                                                        return number != 0
                                                            ? Badgee(
                                                                value: number
                                                                    .toString(),
                                                                color: badgoo !=
                                                                        0.0
                                                                    ? const Color
                                                                            .fromARGB(
                                                                        176,
                                                                        244,
                                                                        67,
                                                                        54)
                                                                    : Colors
                                                                        .black12,
                                                                child:
                                                                    const Icon(
                                                                  Icons
                                                                      .store_outlined,
                                                                  color: Colors
                                                                      .cyanAccent,
                                                                ),
                                                              )
                                                            : const Icon(
                                                                Icons
                                                                    .store_outlined,
                                                                color: Colors
                                                                    .blueGrey,
                                                              );
                                                      });
                                                })
                                            : const Icon(
                                                Icons.store_outlined,
                                                color: Colors.blueGrey,
                                              );
                                      });
                            }),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('listing')
                                .doc(id.toString())
                                .snapshots(),
                            builder: (ctx, userSnapshot) {
                              if (userSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: Text(
                                    'Loading...',
                                    style: TextStyle(fontSize: 2),
                                  ),
                                );
                              }
                              final chatDocs = userSnapshot.hasData
                                  ? userSnapshot.data
                                  : null;

                              if (userSnapshot.hasData == true) {
                                final badgo1 = chatDocs!.data()!['messages'];
                                final badgo2 =
                                    chatDocs.data()!['messages_seen'];

                                badgoo = badgo1 - badgo2;
                              }

                              return badgoo != 0
                                  ? Badgee(
                                      value: badgoo.toString(),
                                      color: const Color.fromARGB(
                                          176, 244, 67, 54),
                                      child: const Icon(
                                        Icons.messenger_outline_sharp,
                                        color: Colors.cyanAccent,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.messenger_outline_sharp,
                                      color: Colors.blueGrey,
                                    );
                            })
                      ]),
                  Container(
                    width: double.infinity,
                    height: 60,
                    margin: const EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: FittedBox(
                      child: Image.network(
                        imageurl,
                        // fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.blue),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Center(
                    child: Text(
                        'date:${DateFormat('dd/MM/yyyy hh:mm').format(createdAt.toDate())}',
                        style: const TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.grey)),
                  ),
                  AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText(
                          '<<<<<<<<<    swipe left to remove  the item ',
                          colors: [
                            Colors.red,
                            Colors.greenAccent,
                            Colors.redAccent,
                          ],
                          textStyle: const TextStyle(
                            fontSize: 9,
                          ),
                          speed: const Duration(milliseconds: 100)),
                    ],
                    repeatForever: true,
                  ),
                ])),
          ),
//        )
        ));
  }
}
