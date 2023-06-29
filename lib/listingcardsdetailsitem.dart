import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'badge.dart';
import 'chat_screens.dart';

class ListingCardsDetailsItem extends StatefulWidget {
  final String id;
  final String listid;
  final bool filter;
  final String area;

  const ListingCardsDetailsItem(this.id, this.listid, this.filter, this.area,
      {super.key});

  @override
  State<ListingCardsDetailsItem> createState() =>
      _ListingCardsDetailsItemState();
}

class _ListingCardsDetailsItemState extends State<ListingCardsDetailsItem> {
  int badgoo = 0;
  bool loadingxx = false;

  void routex(busid2x, username, storename, busidx, useridx, basicstorename,
      basicusername) async {
    Navigator.of(context).push(MaterialPageRoute(
//  widget
//                                                                             .listid,
//                                                                         username,
//                                                                         store_name,
//                                                                         'customer',
//                                                                         busid,
//                                                                         busid2,
//                                                                         cusid,
//                                                                         basicstore_name,
//                                                                         basicusername
        builder: (ctx) => ChatScreens(
            widget.listid,
            username,
            storename,
            'customer',
            busidx,
            busid2x,
            useridx,
            basicstorename,
            basicusername)));
  }

  @override
  Widget build(BuildContext context) {
    final userx = FirebaseAuth.instance.currentUser!.uid;
    print(widget.id);
    print(widget.listid);
    print('xxxxxxxxxxxxxxxx');

    return Dismissible(
        key: ValueKey(widget.id),
        background: Container(
          color: Theme.of(context).errorColor,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          margin: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 4,
          ),
          child: const Icon(
            Icons.delete,
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
                'Do you want to remove the item from the cart?',
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
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('business_details')
                .doc(widget.id.toString())
                .snapshots(),
            builder: (ctx, chatSnapshottt) {
              if (chatSnapshottt.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatDocs =
                  chatSnapshottt.hasData ? chatSnapshottt.data : null;
              final store_name = chatDocs!.data()!['store_name'];
              final basicstore_name = chatDocs.data()!['basicstore_name'];

              final busid = chatDocs.data()!['first_uid'];
              final busid2 = chatDocs.data()!['second_uid'];
              final area_id = chatDocs.data()!['area_id'];

// final kobry = await FirebaseFirestore.instance
//                     .collection('business_details')
//                     .doc(id.toString()).get();
              return chatSnapshottt.hasData == false
                  ? const Center(
                      child: Text('no valid orders yet'),
                    )
                  : StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('listing')
                          .doc(widget.listid.toString())
                          .snapshots(),
                      builder: (ctx, chatSnapshot) {
                        if (chatSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final chatDocss =
                            chatSnapshot.hasData ? chatSnapshot.data : null;
                        final store_nameprice =
                            chatDocss!.data()!['${basicstore_name}price'];
                        final store_messagesIndicator =
                            chatDocss.data()!['$basicstore_name'];
                        final store_messages =
                            chatDocss.data()!['${basicstore_name}messages'];
                        final store_messagesseen =
                            chatDocss.data()!['${basicstore_name}messagesseen'];
                        final cusid = chatDocss.data()!['userid'];
                        final messbaqy = store_messages - store_messagesseen;
                        final messages = chatDocss.data()!['messages'];
                        final messages_seen =
                            chatDocss.data()!['messages_seen'];
                        final sent = chatDocss.data()!['sent'];
                        final seen = chatDocss.data()!['seen'];
                        final sentminseen = sent - seen;
                        final username = chatDocss.data()!['username'];
                        final basicusername = chatDocss.data()!['basicemail'];
                        final area_id_list = chatDocss.data()!['area_id'];

// final kobry = await FirebaseFirestore.instance
//                     .collection('business_details')
//                     .doc(id.toString()).get();
                        return chatSnapshottt.hasData == false
                            ? const Center(
                                child: Text('no valid orders yet'),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  final seendoc = await FirebaseFirestore
                                      .instance
                                      .collection('listing')
                                      .doc(widget.listid.toString())
                                      .get();
                                  final seen = seendoc.data()!['seen'];
                                  await FirebaseFirestore.instance
                                      .collection('listing')
                                      .doc(widget.listid.toString())
                                      .update({
                                    'seen': sentminseen == 0
                                        ? seen
                                        : seen + messbaqy,
                                    'messages_seen': messages_seen + messbaqy,
                                    '${basicstore_name}messagesseen':
                                        store_messages
                                  });
                                },
                                child: !widget.filter
                                    ? Card(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 4,
                                        ),
                                        child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            // child: SizedBox(
                                            //     height: 150,
                                            child: Column(children: [
                                              Center(
                                                  child: Text(
                                                '🏭   $store_name',
                                                style: const TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue),
                                              )),
                                              loadingxx == true
                                                  ? const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    )
                                                  : GestureDetector(
                                                      onTap: () async {
                                                        setState(() {
                                                          loadingxx = true;
                                                        });
                                                        final cusiddoc =
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'listing')
                                                                .doc(widget
                                                                    .listid
                                                                    .toString())
                                                                .get();
                                                        final cusid = cusiddoc
                                                            .data()!['userid'];
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'listing')
                                                            .doc(widget.listid
                                                                .toString())
                                                            .update({
                                                          'seen': sentminseen ==
                                                                  0
                                                              ? seen
                                                              : seen + messbaqy,
                                                          'messages_seen':
                                                              messages_seen +
                                                                  messbaqy,
                                                          '${basicstore_name}messagesseen':
                                                              store_messages
                                                        });
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder: (ctx) => ChatScreens(
                                                                    widget
                                                                        .listid,
                                                                    username,
                                                                    store_name,
                                                                    'customer',
                                                                    busid,
                                                                    busid2,
                                                                    cusid,
                                                                    basicstore_name,
                                                                    basicusername)));
                                                        routex(
                                                            busid2,
                                                            username,
                                                            store_name,
                                                            busid,
                                                            cusid,
                                                            basicstore_name,
                                                            basicusername);
                                                        Future.delayed(
                                                            const Duration(
                                                                seconds: 3),
                                                            (() {
                                                          setState(() {
                                                            loadingxx = false;
                                                          });
                                                        }));
                                                      },
//
                                                      child: StreamBuilder(
                                                          stream:
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'listing')
                                                                  .doc(widget
                                                                      .listid
                                                                      .toString())
                                                                  .snapshots(),
                                                          builder: (ctx,
                                                              userSnapshot) {
                                                            if (userSnapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .waiting) {
                                                              return const Center(
                                                                child: Text(
                                                                  'Loading...',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          2),
                                                                ),
                                                              );
                                                            }
                                                            final chatDocs =
                                                                userSnapshot
                                                                        .hasData
                                                                    ? userSnapshot
                                                                        .data
                                                                    : null;

                                                            if (userSnapshot
                                                                    .hasData ==
                                                                true) {
                                                              final badgo1 = chatDocs!
                                                                      .data()![
                                                                  '${basicstore_name}messages'];
                                                              final badgo2 = chatDocs
                                                                      .data()![
                                                                  '${basicstore_name}messagesseen'];

                                                              badgoo = badgo1 -
                                                                  badgo2;
                                                            }

                                                            return badgoo != 0
                                                                ? Badgee(
                                                                    value: badgoo
                                                                        .toString(),
                                                                    color: const Color
                                                                            .fromARGB(
                                                                        176,
                                                                        244,
                                                                        67,
                                                                        54),
                                                                    child:
                                                                        IconButton(
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .messenger_outline),
                                                                      onPressed:
                                                                          () async {
                                                                        setState(
                                                                            () {
                                                                          loadingxx =
                                                                              true;
                                                                        });
                                                                        await FirebaseFirestore
                                                                            .instance
                                                                            .collection('listing')
                                                                            .doc(widget.listid.toString())
                                                                            .update({
                                                                          'seen': sentminseen == 0
                                                                              ? seen
                                                                              : seen + messbaqy,
                                                                          'messages_seen':
                                                                              messages_seen + messbaqy,
                                                                          '${basicstore_name}messagesseen':
                                                                              store_messages
                                                                        });
                                                                        routex(
                                                                            busid2,
                                                                            username,
                                                                            store_name,
                                                                            busid,
                                                                            cusid,
                                                                            basicstore_name,
                                                                            basicusername);
                                                                        Future.delayed(
                                                                            const Duration(seconds: 3),
                                                                            (() {
                                                                          setState(
                                                                              () {
                                                                            loadingxx =
                                                                                false;
                                                                          });
                                                                        }));
                                                                      },
                                                                    ),
                                                                  )
                                                                : IconButton(
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .messenger_outline),
                                                                    onPressed:
                                                                        () async {
                                                                      setState(
                                                                          () {
                                                                        loadingxx =
                                                                            true;
                                                                      });
                                                                      final targ = await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'listing')
                                                                          .doc(widget
                                                                              .listid
                                                                              .toString())
                                                                          .get();
                                                                      final userid =
                                                                          targ.data()![
                                                                              'userid'];

                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'listing')
                                                                          .doc(widget
                                                                              .listid
                                                                              .toString())
                                                                          .update({
                                                                        '${basicstore_name}messagesseen':
                                                                            store_messages
                                                                      });
                                                                      // Navigator.of(context).push(MaterialPageRoute(
                                                                      //     builder: (ctx) => ChatScreens(
                                                                      //         widget
                                                                      //             .listid,
                                                                      //         username,
                                                                      //         store_name,
                                                                      //         'customer',
                                                                      //         busid,
                                                                      //         busid2,
                                                                      //         userid,
                                                                      //         basicstore_name,
                                                                      //         basicusername)));
                                                                      routex(
                                                                          busid2,
                                                                          username,
                                                                          store_name,
                                                                          busid,
                                                                          cusid,
                                                                          basicstore_name,
                                                                          basicusername);
                                                                      Future.delayed(
                                                                          const Duration(
                                                                              seconds: 3),
                                                                          (() {
                                                                        setState(
                                                                            () {
                                                                          loadingxx =
                                                                              false;
                                                                        });
                                                                      }));
                                                                    },
                                                                  );
                                                          })),
                                              Text(
                                                '$store_nameprice  EGP',
                                                style: const TextStyle(
                                                    fontStyle: FontStyle.italic,
                                                    color: Colors.blue),
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              // Center(
                                              //   child: Text(
                                              //       'date:${DateFormat('dd/MM/yyyy hh:mm').format(createdAt.toDate())}',
                                              //       style: const TextStyle(
                                              //           fontStyle: FontStyle.italic,
                                              //           color: Colors.grey)),
                                              // ),
                                            ])),
                                      )
                                    : area_id == widget.area
                                        ? Card(
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                              vertical: 4,
                                            ),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                // child: SizedBox(
                                                //     height: 150,
                                                child: Column(children: [
                                                  Center(
                                                      child: Text(
                                                    '🏭   $store_name',
                                                    style: const TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.blue),
                                                  )),

                                                  GestureDetector(
                                                      onTap: () async {
                                                        final cusiddoc =
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'listing')
                                                                .doc(widget
                                                                    .listid
                                                                    .toString())
                                                                .get();
                                                        final cusid = cusiddoc
                                                            .data()!['userid'];
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'listing')
                                                            .doc(widget.listid
                                                                .toString())
                                                            .update({
                                                          'seen': sentminseen ==
                                                                  0
                                                              ? seen
                                                              : seen + messbaqy,
                                                          'messages_seen':
                                                              messages_seen +
                                                                  messbaqy,
                                                          '${basicstore_name}messagesseen':
                                                              store_messages
                                                        });
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder: (ctx) => ChatScreens(
                                                                    widget
                                                                        .listid,
                                                                    username,
                                                                    store_name,
                                                                    'customer',
                                                                    busid,
                                                                    busid2,
                                                                    cusid,
                                                                    basicstore_name,
                                                                    basicusername)));
                                                        routex(
                                                            busid2,
                                                            username,
                                                            store_name,
                                                            busid,
                                                            cusid,
                                                            basicstore_name,
                                                            basicusername);
                                                        Future.delayed(
                                                            const Duration(
                                                                seconds: 3),
                                                            (() {
                                                          setState(() {
                                                            loadingxx = false;
                                                          });
                                                        }));
                                                      },
//
                                                      child: StreamBuilder(
                                                          stream:
                                                              FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'listing')
                                                                  .doc(widget
                                                                      .listid
                                                                      .toString())
                                                                  .snapshots(),
                                                          builder: (ctx,
                                                              userSnapshot) {
                                                            if (userSnapshot
                                                                    .connectionState ==
                                                                ConnectionState
                                                                    .waiting) {
                                                              return const Center(
                                                                child: Text(
                                                                  'Loading...',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          2),
                                                                ),
                                                              );
                                                            }
                                                            final chatDocs =
                                                                userSnapshot
                                                                        .hasData
                                                                    ? userSnapshot
                                                                        .data
                                                                    : null;

                                                            if (userSnapshot
                                                                    .hasData ==
                                                                true) {
                                                              final badgo1 = chatDocs!
                                                                      .data()![
                                                                  '${basicstore_name}messages'];
                                                              final badgo2 = chatDocs
                                                                      .data()![
                                                                  '${basicstore_name}messagesseen'];

                                                              badgoo = badgo1 -
                                                                  badgo2;
                                                            }

                                                            return badgoo != 0
                                                                ? Badgee(
                                                                    value: badgoo
                                                                        .toString(),
                                                                    color: const Color
                                                                            .fromARGB(
                                                                        176,
                                                                        244,
                                                                        67,
                                                                        54),
                                                                    child:
                                                                        IconButton(
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .messenger_outline),
                                                                      onPressed:
                                                                          () async {
                                                                        setState(
                                                                            () {
                                                                          loadingxx ==
                                                                              true;
                                                                        });
                                                                        await FirebaseFirestore
                                                                            .instance
                                                                            .collection('listing')
                                                                            .doc(widget.listid.toString())
                                                                            .update({
                                                                          'seen': sentminseen == 0
                                                                              ? seen
                                                                              : seen + messbaqy,
                                                                          'messages_seen':
                                                                              messages_seen + messbaqy,
                                                                          '${basicstore_name}messagesseen':
                                                                              store_messages
                                                                        });
                                                                        routex(
                                                                            busid2,
                                                                            username,
                                                                            store_name,
                                                                            busid,
                                                                            cusid,
                                                                            basicstore_name,
                                                                            basicusername);
                                                                        Future.delayed(
                                                                            const Duration(seconds: 3),
                                                                            (() {
                                                                          setState(
                                                                              () {
                                                                            loadingxx =
                                                                                false;
                                                                          });
                                                                        }));
                                                                      },
                                                                    ),
                                                                  )
                                                                : IconButton(
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .messenger_outline),
                                                                    onPressed:
                                                                        () async {
                                                                      setState(
                                                                          () {
                                                                        loadingxx ==
                                                                            true;
                                                                      });
                                                                      final targ = await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'listing')
                                                                          .doc(widget
                                                                              .listid
                                                                              .toString())
                                                                          .get();
                                                                      final userid =
                                                                          targ.data()![
                                                                              'userid'];

                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'listing')
                                                                          .doc(widget
                                                                              .listid
                                                                              .toString())
                                                                          .update({
                                                                        '${basicstore_name}messagesseen':
                                                                            store_messages
                                                                      });
                                                                      // Navigator.of(context).push(MaterialPageRoute(
                                                                      //     builder: (ctx) => ChatScreens(
                                                                      //         widget.listid,
                                                                      //         username,
                                                                      //         store_name,
                                                                      //         'customer',
                                                                      //         busid,
                                                                      //         busid2,
                                                                      //         userid,
                                                                      //         basicstore_name,
                                                                      //         basicusername)));
                                                                      routex(
                                                                          busid2,
                                                                          username,
                                                                          store_name,
                                                                          busid,
                                                                          cusid,
                                                                          basicstore_name,
                                                                          basicusername);
                                                                      Future.delayed(
                                                                          const Duration(
                                                                              seconds: 3),
                                                                          (() {
                                                                        setState(
                                                                            () {
                                                                          loadingxx =
                                                                              false;
                                                                        });
                                                                      }));
                                                                    },
                                                                  );
                                                          })),
                                                  Text(
                                                    '$store_nameprice  EGP',
                                                    style: const TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color: Colors.blue),
                                                  ),
                                                  const SizedBox(
                                                    height: 4,
                                                  ),
                                                  // Center(
                                                  //   child: Text(
                                                  //       'date:${DateFormat('dd/MM/yyyy hh:mm').format(createdAt.toDate())}',
                                                  //       style: const TextStyle(
                                                  //           fontStyle: FontStyle.italic,
                                                  //           color: Colors.grey)),
                                                  // ),
                                                ])),
                                          )
                                        : const SizedBox());
//        )
                      });
            }));
  }
}
