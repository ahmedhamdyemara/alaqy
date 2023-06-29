import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alaqy/business_main.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'badge.dart';
import 'chat_screens.dart';
import 'ordercardsdetailsscreen.dart';

class Ordercarditem extends StatefulWidget {
  final String id;
  final Timestamp createdAt;
  final String title;
  final String imageurl;
  final String description;
  final String username;
  final bool up;
  final bool close;
  final String chatindicator;
  final String storename;
  final dynamic price;
  final String basicstorename;
  final String basicusername;
  final bool cloze;

  Ordercarditem(
      this.id,
      this.createdAt,
      this.title,
      this.imageurl,
      this.description,
      this.username,
      this.up,
      this.close,
      this.chatindicator,
      this.storename,
      this.price,
      this.basicstorename,
      this.basicusername,
      this.cloze,
      {super.key});

  @override
  State<Ordercarditem> createState() => _OrdercarditemState();
}

class _OrdercarditemState extends State<Ordercarditem> {
  int badgoo = 0;
  String? mtoken = '';
  dynamic idz;
  dynamic price;
  dynamic report;
  bool loading = false;
  bool loadingx = false;
  bool loadingxx = false;

  late String useridx;
  late String busidx;
  Future<void> _onBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp(
        // options: DefaultFirebaseOptions.currentPlatform,
        );
    debugPrint('we have received a notification ${message.notification}');
  }

  void sendpushnotification(String token, String body, String title) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'content-type': 'aplication/json',
          'Authorization':
              'key=AAAAYkVGhz8:APA91bE75B-XzSXGRP9xJ6M1Ljg7CavQe_No8g705E0XlPp1Q_QwCQ1T9o_9wjHChsWR5fpzQ1YlQ2l5D8STZGmJf9gcVuj4jRtf9lkWji79QmqOW_fwy6hg__twEGiBbooIidoVMaw-'
        },
        body: jsonEncode(<String, dynamic>{
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'Flutter_Notification_Click',
            'status': 'done',
            'body': body,
            'title': title,
          },
          "notification": <String, dynamic>{
            "title": title,
            "body": body,
            "android_channel_id": "dbfood",
          },
          "to": token,
        }),
      );
      print("herexxx push notification");
    } catch (e) {
      if (kDebugMode) {
        print("error push notification");
      }
    }
  }

  @override
  void initState() {
    // setState(() {
    //   loadingxx = false;
    // });
    super.initState();
  }

  // void requestpermission() async {
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //   NotificationSettings settings = await messaging.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );
  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     print('user granted permission');
  //   } else if (settings.authorizationStatus ==
  //       AuthorizationStatus.provisional) {
  //     print('user granted provisional permission');
  //   } else {
  //     print('user declined');
  //   }
  // }

  // void getToken() async {
  //   await FirebaseMessaging.instance.getToken().then((token) {
  //     setState(() {
  //       mtoken = token;
  //       print('my token is $mtoken');
  //     });
  //   });
  // }
  final userx = FirebaseAuth.instance.currentUser!.uid;
  void routex(busid2x) async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => ChatScreens(
            widget.id,
            widget.username,
            widget.storename,
            'business',
            busidx,
            busid2x,
            useridx,
            widget.basicstorename,
            widget.basicusername)));
  }

  void routez() async {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => OrderCardsDetailsScreen(
            widget.id,
            widget.createdAt,
            widget.title,
            widget.imageurl,
            widget.description,
            widget.username,
            widget.chatindicator,
            widget.storename,
            widget.basicstorename,
            widget.basicusername)));
  }

  void foundsentseen() async {
    final useri = await FirebaseFirestore.instance
        .collection('business_details')
        .where('second_uid', isEqualTo: userx)
        .get();
    final idx = useri.docs.first.id;
    final sent = useri.docs.first.data()['foundsent'];
    final seen = useri.docs.first.data()['foundseen'];

    final upnum = useri.docs.first.data()['upnum'];
    final upnumseen = useri.docs.first.data()['upnumseen'];

    final storenameb = useri.docs.first.data()['basicstore_name'];
    final listcont =
        await FirebaseFirestore.instance.collection('listing').get();
    List<DocumentSnapshot<Map<String, dynamic>>> sentx = [];
    List<int> foundsentsx = [];
    List<int> foundseenx = [];
    // print(listcont.docs.length);
    // print(storenameb);
    // foundsentsx.add(upnum);
    // foundseenx.add(upnumseen);
    for (var z = 0; z < listcont.docs.length; z++) {
      if (listcont.docs[z].data().containsKey(storenameb)) {
        if (listcont.docs[z].data()[storenameb] == 'on') {
          foundsentsx.add(listcont.docs[z]
              .data()['post_owner_reply_to_business$storenameb']);
          foundseenx.add(listcont.docs[z]
              .data()['post_owner_seen_by_business$storenameb']);
          print(foundsentsx);
          print(foundseenx);
          print(seen);
          print(sent);
        }
      }
    }
    final mustaddedsent = foundsentsx.fold(
        0, (previousValue, element) => previousValue + element);
    final mustaddedseen =
        foundseenx.fold(0, (previousValue, element) => previousValue + element);

    FirebaseFirestore.instance
        .collection('business_details')
        .doc(idx)
        .update({'foundsent': mustaddedsent, 'foundseen': mustaddedseen});
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(const Duration(seconds: 3), (() {
    //   setState(() {
    //     loadingxx = false;
    //   });
    // }));
    final useruid = FirebaseAuth.instance.currentUser!.uid;

    // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    //     FlutterLocalNotificationsPlugin();

    // @override
    // void initState() {
    //   super.initState();
    //   FirebaseMessaging.instance
    //       .getInitialMessage()
    //       .then((RemoteMessage? message) {
    //     if (message != null) {
    //       Navigator.pushNamed(
    //         context, '/',
    //         //  arguments: MessageArguments(message, true)
    //       );
    //     }
    //   });

    //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //     RemoteNotification? notification = message.notification;
    //     AndroidNotification? android = message.notification?.android;

    //     if (notification != null && android != null) {
    //       flutterLocalNotificationsPlugin.show(
    //           notification.hashCode,
    //           notification.title,
    //           notification.body,
    //           NotificationDetails(
    //             android: AndroidNotificationDetails(
    //               widget.id,
    //               widget.storename,
    //               //  widget.description,
    //               // TODO add a proper drawable resource to android, for now using
    //               //      one that already exists in example app.
    //               icon: 'launch_background',
    //             ),
    //           ));
    //     }
    //   });

    //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //     print('A new onMessageOpenedApp event was published!');
    //     Navigator.pushNamed(
    //       context, '/',
    //       //  arguments: MessageArguments(message, true)
    //     );
    //   });
    // }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.messageId}');
      }
    });
    final pricecontroller = TextEditingController();
    final reportcontroller = TextEditingController();
    final _transformationController = TransformationController();
    TapDownDetails? _doubleTapDetails;
    final userx = FirebaseAuth.instance.currentUser!.uid;

    void _handleDoubleTapDown(TapDownDetails details) {
      _doubleTapDetails = details;
    }

    void _handleDoubleTap() {
      if (_transformationController.value != Matrix4.identity()) {
        _transformationController.value = Matrix4.identity();
      } else {
        final position = _doubleTapDetails!.localPosition;
        // For a 3x zoom
        _transformationController.value = Matrix4.identity()
          ..translate(-position.dx * 2, -position.dy * 2)
          ..scale(3.0);
        // Fox a 2x zoom
        // ..translate(-position.dx, -position.dy)
        // ..scale(2.0);
      }
    }

    final fbm = FirebaseMessaging.instance;
    fbm.getToken();
    fbm.subscribeToTopic('chat');
    fbm.subscribeToTopic('listing');
    fbm.subscribeToTopic('notify');
    final busid2x = FirebaseAuth.instance.currentUser!.uid;
    final user = FirebaseAuth.instance.currentUser;
    user!.getIdToken();
    fbm.onTokenRefresh;

    return loadingxx == true
        ? const Center(
            child: CircularProgressIndicator(),
          )
        :

//  Dismissible(
//             key: ValueKey(widget.id),
//             background: Container(
//               color: Theme.of(context).errorColor,
//               alignment: Alignment.centerRight,
//               padding: const EdgeInsets.only(right: 20),
//               margin: const EdgeInsets.symmetric(
//                 horizontal: 15,
//                 vertical: 4,
//               ),
//               child: const Icon(
//                 Icons.delete,
//                 color: Colors.white,
//                 size: 40,
//               ),
//             ),
//             direction: DismissDirection.endToStart,
//             confirmDismiss: (direction) {
//               return showDialog(
//                 context: context,
//                 builder: (ctx) => AlertDialog(
//                   title: const Text('Are you sure?'),
//                   content: const Text(
//                     'Do you want to remove this order?',
//                   ),
//                   actions: <Widget>[
//                     TextButton(
//                       child: const Text('No'),
//                       onPressed: () {
//                         Navigator.of(ctx).pop(false);
//                       },
//                     ),
//                     TextButton(
//                       child: const Text('Yes'),
//                       onPressed: () {
//                         FirebaseFirestore.instance
//                             .collection('listing')
//                             .doc(widget.id.toString())
//                             .update({widget.basicstorename: 'closedx'});
//                         Navigator.of(ctx).pop(true);
//                       },
//                     ),
//                   ],
//                 ),
//               );
//             },
//             onDismissed: (direction) {
//             },
        SizedBox(
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
                    Container(
                        width: double.infinity,
                        alignment: Alignment.topRight,
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
                                            title: const Text(
                                                'please write the reason why you report this order'),
                                            content: TextFormField(
                                              //  key: const ValueKey('username'),
                                              keyboardType: TextInputType.text,
                                              enableSuggestions: false,
                                              controller: reportcontroller,
                                              validator: (value) {
                                                if (value != null) {
                                                  return (value.isEmpty)
                                                      ? 'Please enter a reason'
                                                      : null;
                                                }
                                              },
                                              decoration: const InputDecoration(
                                                  labelText: 'report reason'),
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
                                                  if (reportcontroller
                                                          .value.text ==
                                                      '') {
                                                    null;
                                                  } else {
                                                    // Future.delayed(const Duration(seconds: 2),
                                                    //     (() {
                                                    Navigator.of(ctx)
                                                        .pop(false);
                                                    //  }));
                                                    showDialog(
                                                      context: context,
                                                      builder: (ctx) =>
                                                          AlertDialog(
                                                        title: const Text(
                                                            'reprt sent!'),
                                                        content: const Text(
                                                          'admins will justify it',
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: const Text(
                                                                'ok'),
                                                            onPressed: () {
                                                              Navigator.of(ctx)
                                                                  .pop(false);

                                                              // Navigator.popAndPushNamed(
                                                              //     context, '/');
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    );

                                                    final lisdoc =
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'customer_details')
                                                            .where('second_uid',
                                                                isEqualTo:
                                                                    FirebaseAuth
                                                                        .instance
                                                                        .currentUser!
                                                                        .uid)
                                                            .get();
                                                    final busid =
                                                        lisdoc.docs.last.id;
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            'listing_report')
                                                        .doc(widget.id
                                                            .toString())
                                                        .set({
                                                      'time': Timestamp.now()
                                                    });
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            'listing_report')
                                                        .doc(widget.id
                                                            .toString())
                                                        .collection('reporters')
                                                        .doc(busid)
                                                        .set({
                                                      'reportid': widget.id,
                                                      'listid': widget.id,
                                                      'businessid': busid,
                                                      'closed case': false,
                                                      'notes': '',
                                                      'reasons':
                                                          reportcontroller
                                                              .value.text,
                                                    });
                                                    //_report();
                                                  }
                                                },
                                              ),
                                            ]));
                              }
                            })),
                    GestureDetector(
                        onTap: () async {
                          setState(() {
                            loadingxx = true;
                          });

                          routez();
                          Future.delayed(const Duration(seconds: 3), (() {
                            setState(() {
                              loadingxx = false;
                            });
                          }));
                          final busdocs = await FirebaseFirestore.instance
                              .collection('business_details')
                              .where('second_uid',
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser!.uid)
                              .get();
                          final busdoc = busdocs.docs.first;
                          final fird = busdoc.id;
                          final loui = busdoc.data()['upnumseen'];
                          final bussub = await FirebaseFirestore.instance
                              .collection('business_details')
                              .doc(fird)
                              .collection('mylistsx')
                              .doc(widget.id.toString())
                              .get();
                          final mix = !bussub.exists
                              ? false
                              : bussub.data()![widget.id.toString()];
                          if (mix == true) {
                            FirebaseFirestore.instance
                                .collection('business_details')
                                .doc(fird)
                                .collection('mylistsx')
                                .doc(widget.id.toString())
                                .update({widget.id.toString(): false});

                            FirebaseFirestore.instance
                                .collection('business_details')
                                .doc(fird)
                                .update({'upnumseen': loui + 1});
                            foundsentseen();
                          }
                        },
                        child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 8,
                            ),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12)),
                              color: Colors.cyan,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 2,
                              horizontal: 2,
                            ),
                            child: Card(
                                elevation: 30,
                                shadowColor: Colors.cyan,
                                //  color: Colors.cyanAccent,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                  vertical: 2,
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    // child: SizedBox(
                                    //     height: 150,

                                    child: Column(children: [
                                      GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              loadingxx = true;
                                            });

                                            routez();
                                            Future.delayed(
                                                const Duration(seconds: 3),
                                                (() {
                                              setState(() {
                                                loadingxx = false;
                                              });
                                            }));
                                            final busdocs =
                                                await FirebaseFirestore.instance
                                                    .collection(
                                                        'business_details')
                                                    .where('second_uid',
                                                        isEqualTo: FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                    .get();
                                            final busdoc = busdocs.docs.first;
                                            final fird = busdoc.id;
                                            final loui =
                                                busdoc.data()['upnumseen'];
                                            final bussub =
                                                await FirebaseFirestore.instance
                                                    .collection(
                                                        'business_details')
                                                    .doc(fird)
                                                    .collection('mylistsx')
                                                    .doc(widget.id.toString())
                                                    .get();
                                            final mix = !bussub.exists
                                                ? false
                                                : bussub.data()![
                                                    widget.id.toString()];
                                            if (mix == true) {
                                              FirebaseFirestore.instance
                                                  .collection(
                                                      'business_details')
                                                  .doc(fird)
                                                  .collection('mylistsx')
                                                  .doc(widget.id.toString())
                                                  .update({
                                                widget.id.toString(): false
                                              });

                                              FirebaseFirestore.instance
                                                  .collection(
                                                      'business_details')
                                                  .doc(fird)
                                                  .update(
                                                      {'upnumseen': loui + 1});
                                              foundsentseen();
                                            }
                                          },
                                          child: SizedBox(
                                              width: double.infinity,
                                              child: Center(
                                                  widthFactor: double.infinity,
                                                  child: Text(
                                                    'title:${widget.title}',
                                                    style: const TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.blue),
                                                  )))),
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
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    fullscreenDialog: true,
                                                    builder: (ctx) =>
                                                        GestureDetector(
                                                          onDoubleTapDown:
                                                              _handleDoubleTapDown,
                                                          onDoubleTap:
                                                              _handleDoubleTap,
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Center(
                                                            child:
                                                                InteractiveViewer(
                                                              transformationController:
                                                                  _transformationController,
                                                              /* ... */
                                                              child:
                                                                  Image.network(
                                                                widget.imageurl,
                                                                // fit: BoxFit.fill,
                                                              ),
                                                            ),
                                                          ),
                                                        )));
                                          },
                                          child: FittedBox(
                                            child: Image.network(
                                              widget.imageurl,
                                              // fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              loadingxx = true;
                                            });

                                            routez();
                                            Future.delayed(
                                                const Duration(seconds: 3),
                                                (() {
                                              setState(() {
                                                loadingxx = false;
                                              });
                                            }));
                                            final busdocs =
                                                await FirebaseFirestore.instance
                                                    .collection(
                                                        'business_details')
                                                    .where('second_uid',
                                                        isEqualTo: FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                    .get();
                                            final busdoc = busdocs.docs.first;
                                            final fird = busdoc.id;
                                            final loui =
                                                busdoc.data()['upnumseen'];
                                            final bussub =
                                                await FirebaseFirestore.instance
                                                    .collection(
                                                        'business_details')
                                                    .doc(fird)
                                                    .collection('mylistsx')
                                                    .doc(widget.id.toString())
                                                    .get();
                                            final mix = !bussub.exists
                                                ? false
                                                : bussub.data()![
                                                    widget.id.toString()];
                                            if (mix == true) {
                                              FirebaseFirestore.instance
                                                  .collection(
                                                      'business_details')
                                                  .doc(fird)
                                                  .collection('mylistsx')
                                                  .doc(widget.id.toString())
                                                  .update({
                                                widget.id.toString(): false
                                              });

                                              FirebaseFirestore.instance
                                                  .collection(
                                                      'business_details')
                                                  .doc(fird)
                                                  .update(
                                                      {'upnumseen': loui + 1});
                                              foundsentseen();
                                            }
                                          },
                                          child: const SizedBox(
                                            width: double.infinity,
                                            height: 4,
                                          )),
                                      GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              loadingxx = true;
                                            });

                                            routez();
                                            Future.delayed(
                                                const Duration(seconds: 3),
                                                (() {
                                              setState(() {
                                                loadingxx = false;
                                              });
                                            }));
                                            final busdocs =
                                                await FirebaseFirestore.instance
                                                    .collection(
                                                        'business_details')
                                                    .where('second_uid',
                                                        isEqualTo: FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                    .get();
                                            final busdoc = busdocs.docs.first;
                                            final fird = busdoc.id;
                                            final loui =
                                                busdoc.data()['upnumseen'];
                                            final bussub =
                                                await FirebaseFirestore.instance
                                                    .collection(
                                                        'business_details')
                                                    .doc(fird)
                                                    .collection('mylistsx')
                                                    .doc(widget.id.toString())
                                                    .get();
                                            final mix = !bussub.exists
                                                ? false
                                                : bussub.data()![
                                                    widget.id.toString()];
                                            if (mix == true) {
                                              FirebaseFirestore.instance
                                                  .collection(
                                                      'business_details')
                                                  .doc(fird)
                                                  .collection('mylistsx')
                                                  .doc(widget.id.toString())
                                                  .update({
                                                widget.id.toString(): false
                                              });

                                              FirebaseFirestore.instance
                                                  .collection(
                                                      'business_details')
                                                  .doc(fird)
                                                  .update(
                                                      {'upnumseen': loui + 1});
                                              foundsentseen();
                                            }
                                          },
                                          child: SizedBox(
                                              width: double.infinity,
                                              child: Center(
                                                  widthFactor: double.infinity,
                                                  child: Text(
                                                    widget.description,
                                                    style: const TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color: Colors.blue),
                                                  )))),
                                      GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              loadingxx = true;
                                            });

                                            routez();
                                            Future.delayed(
                                                const Duration(seconds: 3),
                                                (() {
                                              setState(() {
                                                loadingxx = false;
                                              });
                                            }));
                                            final busdocs =
                                                await FirebaseFirestore.instance
                                                    .collection(
                                                        'business_details')
                                                    .where('second_uid',
                                                        isEqualTo: FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                    .get();
                                            final busdoc = busdocs.docs.first;
                                            final fird = busdoc.id;
                                            final loui =
                                                busdoc.data()['upnumseen'];
                                            final bussub =
                                                await FirebaseFirestore.instance
                                                    .collection(
                                                        'business_details')
                                                    .doc(fird)
                                                    .collection('mylistsx')
                                                    .doc(widget.id.toString())
                                                    .get();
                                            final mix = !bussub.exists
                                                ? false
                                                : bussub.data()![
                                                    widget.id.toString()];
                                            if (mix == true) {
                                              FirebaseFirestore.instance
                                                  .collection(
                                                      'business_details')
                                                  .doc(fird)
                                                  .collection('mylistsx')
                                                  .doc(widget.id.toString())
                                                  .update({
                                                widget.id.toString(): false
                                              });

                                              FirebaseFirestore.instance
                                                  .collection(
                                                      'business_details')
                                                  .doc(fird)
                                                  .update(
                                                      {'upnumseen': loui + 1});
                                              foundsentseen();
                                            }
                                          },
                                          child: const SizedBox(
                                            width: double.infinity,
                                            height: 4,
                                          )),
                                      GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              loadingxx = true;
                                            });

                                            routez();
                                            Future.delayed(
                                                const Duration(seconds: 3),
                                                (() {
                                              setState(() {
                                                loadingxx = false;
                                              });
                                            }));
                                            final busdocs =
                                                await FirebaseFirestore.instance
                                                    .collection(
                                                        'business_details')
                                                    .where('second_uid',
                                                        isEqualTo: FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                    .get();
                                            final busdoc = busdocs.docs.first;
                                            final fird = busdoc.id;
                                            final loui =
                                                busdoc.data()['upnumseen'];
                                            final bussub =
                                                await FirebaseFirestore.instance
                                                    .collection(
                                                        'business_details')
                                                    .doc(fird)
                                                    .collection('mylistsx')
                                                    .doc(widget.id.toString())
                                                    .get();
                                            final mix = !bussub.exists
                                                ? false
                                                : bussub.data()![
                                                    widget.id.toString()];
                                            if (mix == true) {
                                              FirebaseFirestore.instance
                                                  .collection(
                                                      'business_details')
                                                  .doc(fird)
                                                  .collection('mylistsx')
                                                  .doc(widget.id.toString())
                                                  .update({
                                                widget.id.toString(): false
                                              });

                                              FirebaseFirestore.instance
                                                  .collection(
                                                      'business_details')
                                                  .doc(fird)
                                                  .update(
                                                      {'upnumseen': loui + 1});
                                              foundsentseen();
                                            }
                                          },
                                          child: SizedBox(
                                              width: double.infinity,
                                              child: Center(
                                                  widthFactor: double.infinity,
                                                  child: Text(
                                                    'user name:${(widget.username).trim().replaceAll(RegExp(r'_'), ' ')}',
                                                    style: const TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )))),
                                      GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              loadingxx = true;
                                            });

                                            routez();
                                            Future.delayed(
                                                const Duration(seconds: 3),
                                                (() {
                                              setState(() {
                                                loadingxx = false;
                                              });
                                            }));
                                            final busdocs =
                                                await FirebaseFirestore.instance
                                                    .collection(
                                                        'business_details')
                                                    .where('second_uid',
                                                        isEqualTo: FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                    .get();
                                            final busdoc = busdocs.docs.first;
                                            final fird = busdoc.id;
                                            final loui =
                                                busdoc.data()['upnumseen'];
                                            final bussub =
                                                await FirebaseFirestore.instance
                                                    .collection(
                                                        'business_details')
                                                    .doc(fird)
                                                    .collection('mylistsx')
                                                    .doc(widget.id.toString())
                                                    .get();
                                            final mix = !bussub.exists
                                                ? false
                                                : bussub.data()![
                                                    widget.id.toString()];
                                            if (mix == true) {
                                              FirebaseFirestore.instance
                                                  .collection(
                                                      'business_details')
                                                  .doc(fird)
                                                  .collection('mylistsx')
                                                  .doc(widget.id.toString())
                                                  .update({
                                                widget.id.toString(): false
                                              });

                                              FirebaseFirestore.instance
                                                  .collection(
                                                      'business_details')
                                                  .doc(fird)
                                                  .update(
                                                      {'upnumseen': loui + 1});
                                              foundsentseen();
                                            }
                                          },
                                          child: const SizedBox(
                                            width: double.infinity,
                                            height: 4,
                                          )),
                                      GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              loadingxx = true;
                                            });

                                            routez();
                                            Future.delayed(
                                                const Duration(seconds: 3),
                                                (() {
                                              setState(() {
                                                loadingxx = false;
                                              });
                                            }));
                                            final busdocs =
                                                await FirebaseFirestore.instance
                                                    .collection(
                                                        'business_details')
                                                    .where('second_uid',
                                                        isEqualTo: FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                    .get();
                                            final busdoc = busdocs.docs.first;
                                            final fird = busdoc.id;
                                            final loui =
                                                busdoc.data()['upnumseen'];
                                            final bussub =
                                                await FirebaseFirestore.instance
                                                    .collection(
                                                        'business_details')
                                                    .doc(fird)
                                                    .collection('mylistsx')
                                                    .doc(widget.id.toString())
                                                    .get();
                                            final mix = !bussub.exists
                                                ? false
                                                : bussub.data()![
                                                    widget.id.toString()];
                                            if (mix == true) {
                                              FirebaseFirestore.instance
                                                  .collection(
                                                      'business_details')
                                                  .doc(fird)
                                                  .collection('mylistsx')
                                                  .doc(widget.id.toString())
                                                  .update({
                                                widget.id.toString(): false
                                              });

                                              FirebaseFirestore.instance
                                                  .collection(
                                                      'business_details')
                                                  .doc(fird)
                                                  .update(
                                                      {'upnumseen': loui + 1});
                                              foundsentseen();
                                            }
                                          },
                                          child: SizedBox(
                                              width: double.infinity,
                                              child: Center(
                                                widthFactor: double.infinity,
                                                child: Text(
                                                    'date:${DateFormat('dd/MM/yyyy hh:mm').format(widget.createdAt.toDate())}',
                                                    style: const TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color: Colors.grey)),
                                              ))),
                                      StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('business_details')
                                              .where('second_uid',
                                                  isEqualTo: FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid)
                                              // .doc(FirebaseAuth.instance.currentUser!.uid)
                                              .snapshots(),
                                          builder: (ctx, userSnapshotg) {
                                            if (userSnapshotg.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                child: Text('Loading...'),
                                              );
                                            }
                                            final chatDocsg =
                                                userSnapshotg.data;
                                            final fird =
                                                chatDocsg!.docs.first.id;
                                            final loui = chatDocsg.docs.first
                                                .data()['upnumseen'];
                                            return chatDocsg.docs.isEmpty
                                                ? const SizedBox()
                                                : StreamBuilder(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            'business_details')
                                                        .doc(fird)
                                                        .collection('mylistsx')
                                                        .doc(widget.id
                                                            .toString())
                                                        .snapshots(),
                                                    builder:
                                                        (ctx, userSnapshot) {
                                                      if (userSnapshot
                                                              .connectionState ==
                                                          ConnectionState
                                                              .waiting) {
                                                        return const Center(
                                                          child: Text(
                                                              'Loading...'),
                                                        );
                                                      }
                                                      final chatDocs =
                                                          userSnapshot.data;
                                                      final mix = !chatDocs!
                                                              .exists
                                                          ? false
                                                          : chatDocs.data()![
                                                              widget.id
                                                                  .toString()];
                                                      return mix == false
                                                          ? const SizedBox()
                                                          : GestureDetector(
                                                              onTap: () async {
                                                                setState(() {
                                                                  loadingxx =
                                                                      true;
                                                                });

                                                                routez();
                                                                Future.delayed(
                                                                    const Duration(
                                                                        seconds:
                                                                            3),
                                                                    (() {
                                                                  setState(() {
                                                                    loadingxx =
                                                                        false;
                                                                  });
                                                                }));
                                                                final busdocs = await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'business_details')
                                                                    .where(
                                                                        'second_uid',
                                                                        isEqualTo: FirebaseAuth
                                                                            .instance
                                                                            .currentUser!
                                                                            .uid)
                                                                    .get();
                                                                final busdoc =
                                                                    busdocs.docs
                                                                        .first;
                                                                final fird =
                                                                    busdoc.id;
                                                                final loui = busdoc
                                                                        .data()[
                                                                    'upnumseen'];
                                                                final bussub = await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'business_details')
                                                                    .doc(fird)
                                                                    .collection(
                                                                        'mylistsx')
                                                                    .doc(widget
                                                                        .id
                                                                        .toString())
                                                                    .get();
                                                                final mix = !bussub
                                                                        .exists
                                                                    ? false
                                                                    : bussub.data()![
                                                                        widget
                                                                            .id
                                                                            .toString()];
                                                                if (mix ==
                                                                    true) {
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'business_details')
                                                                      .doc(fird)
                                                                      .collection(
                                                                          'mylistsx')
                                                                      .doc(widget
                                                                          .id
                                                                          .toString())
                                                                      .update({
                                                                    widget.id
                                                                            .toString():
                                                                        false
                                                                  });

                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'business_details')
                                                                      .doc(fird)
                                                                      .update({
                                                                    'upnumseen':
                                                                        loui + 1
                                                                  });
                                                                  foundsentseen();
                                                                }
                                                              },
                                                              child: const Text(
                                                                'updated     ⤵️',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                            );
                                                    });
                                          })
                                    ]))))),
                    widget.chatindicator == 'on'
                        ? StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('listing')
                                .doc(widget.id.toString())
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
                                final badgo1 = chatDocs!.data()![
                                    'post_owner_reply_to_business${widget.basicstorename}'];
                                final badgo2 = chatDocs.data()![
                                    'post_owner_seen_by_business${widget.basicstorename}'];

                                badgoo = badgo1 - badgo2;
                              }

                              return badgoo != 0
                                  ? Badgee(
                                      value: badgoo.toString(),
                                      color: const Color.fromARGB(
                                          176, 244, 67, 54),
                                      child: IconButton(
                                        // need gesturedetecture  for doubletap
                                        icon:
                                            const Icon(Icons.messenger_outline),
                                        onPressed: () async {
                                          setState(() {
                                            loadingxx = true;
                                          });

                                          final targ = await FirebaseFirestore
                                              .instance
                                              .collection('listing')
                                              .doc(widget.id.toString())
                                              .get();
                                          final repto = targ.data()![
                                              'post_owner_reply_to_business${widget.basicstorename}'];
                                          final userid = targ.data()!['userid'];
                                          FirebaseFirestore.instance
                                              .collection('listing')
                                              .doc(widget.id.toString())
                                              .update({
                                            'post_owner_seen_by_business${widget.basicstorename}':
                                                repto
                                          });
                                          foundsentseen();

                                          final chox = await FirebaseFirestore
                                              .instance
                                              .collection('business_details')
                                              .where('second_uid',
                                                  isEqualTo: FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid)
                                              .get();
                                          final busid = chox.docs.last
                                              .data()['first_uid'];
                                          final busid2 = FirebaseAuth
                                              .instance.currentUser!.uid;

                                          routex(busid2x);
                                          Future.delayed(
                                              const Duration(seconds: 3), (() {
                                            setState(() {
                                              loadingxx = false;
                                            });
                                          }));
                                        },
                                      ),
                                    )
                                  : IconButton(
                                      // need gesturedetecture  for doubletap
                                      icon: const Icon(Icons.messenger_outline),
                                      onPressed: () async {
                                        setState(() {
                                          loadingxx = true;
                                        });

                                        final targ = await FirebaseFirestore
                                            .instance
                                            .collection('listing')
                                            .doc(widget.id.toString())
                                            .get();
                                        final repto = targ.data()![
                                            'post_owner_reply_to_business${widget.basicstorename}'];
                                        final userid = targ.data()!['userid'];
                                        FirebaseFirestore.instance
                                            .collection('listing')
                                            .doc(widget.id.toString())
                                            .update({
                                          'post_owner_seen_by_business${widget.basicstorename}':
                                              repto
                                        });
                                        foundsentseen();

                                        final chox = await FirebaseFirestore
                                            .instance
                                            .collection('business_details')
                                            .where('second_uid',
                                                isEqualTo: FirebaseAuth
                                                    .instance.currentUser!.uid)
                                            .get();
                                        final busid =
                                            chox.docs.last.data()['first_uid'];
                                        final busid2 = FirebaseAuth
                                            .instance.currentUser!.uid;

                                        routex(busid2x);
                                        Future.delayed(
                                            const Duration(seconds: 3), (() {
                                          setState(() {
                                            loadingxx = false;
                                          });
                                        }));
                                      },
                                    );
                            })
                        : const SizedBox(),
                    widget.up
                        ? GestureDetector(
                            onTap: () async {
                              if (widget.chatindicator == 'on') {
                                setState(() {
                                  loadingxx = true;
                                });

                                final targ = await FirebaseFirestore.instance
                                    .collection('listing')
                                    .doc(widget.id.toString())
                                    .get();
                                final repto = targ.data()![
                                    'post_owner_reply_to_business${widget.basicstorename}'];
                                final userid = targ.data()!['userid'];
                                FirebaseFirestore.instance
                                    .collection('listing')
                                    .doc(widget.id.toString())
                                    .update({
                                  'post_owner_seen_by_business${widget.basicstorename}':
                                      repto
                                });
                                foundsentseen();

                                final chox = await FirebaseFirestore.instance
                                    .collection('business_details')
                                    .where('second_uid',
                                        isEqualTo: FirebaseAuth
                                            .instance.currentUser!.uid)
                                    .get();
                                final busid =
                                    chox.docs.last.data()['first_uid'];
                                final busid2 =
                                    FirebaseAuth.instance.currentUser!.uid;

                                routex(busid2x);
                                Future.delayed(const Duration(seconds: 3), (() {
                                  setState(() {
                                    loadingxx = false;
                                  });
                                }));
                              } else {
                                null;
                              }
                            },
                            child: Text('price:  ${widget.price}     EGP'))
                        : GestureDetector(
                            onTap: () async {
                              if (widget.chatindicator == 'on') {
                                setState(() {
                                  loadingxx = true;
                                });

                                final targ = await FirebaseFirestore.instance
                                    .collection('listing')
                                    .doc(widget.id.toString())
                                    .get();
                                final repto = targ.data()![
                                    'post_owner_reply_to_business${widget.basicstorename}'];
                                final userid = targ.data()!['userid'];
                                FirebaseFirestore.instance
                                    .collection('listing')
                                    .doc(widget.id.toString())
                                    .update({
                                  'post_owner_seen_by_business${widget.basicstorename}':
                                      repto
                                });
                                foundsentseen();

                                final chox = await FirebaseFirestore.instance
                                    .collection('business_details')
                                    .where('second_uid',
                                        isEqualTo: FirebaseAuth
                                            .instance.currentUser!.uid)
                                    .get();
                                final busid =
                                    chox.docs.last.data()['first_uid'];
                                final busid2 =
                                    FirebaseAuth.instance.currentUser!.uid;

                                routex(busid2x);
                                Future.delayed(const Duration(seconds: 3), (() {
                                  setState(() {
                                    loadingxx = false;
                                  });
                                }));
                              } else {
                                null;
                              }
                            },
                            child: const SizedBox()),
                    TextButton(
                        onPressed: () {
                          if (widget.close) {
                            null;
                          } else {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                // actionsOverflowAlignment:
                                //     OverflowBarAlignment.start,
                                title: widget.up
                                    ? const Text(
                                        'you can update the price only one more time')
                                    : const Text(
                                        'if you have this product ,please put a price for it!'),
                                content: TextFormField(
                                  //  key: const ValueKey('username'),
                                  keyboardType: TextInputType.number,
                                  enableSuggestions: false,
                                  controller: pricecontroller,
                                  validator: (value) {
                                    if (value != null) {
                                      return (value.isEmpty)
                                          ? 'Please enter a value'
                                          : null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                      // labelText: 'price',
                                      label: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                        Text('price'),
                                        Text(
                                          'EGP',
                                          style: TextStyle(fontSize: 8),
                                        )
                                      ])),
                                  onSaved: (value) {
                                    if (value != null) {
                                      setState(() {
                                        price = double.parse(value);
                                      });
                                    }
                                  },
                                ),
                                actions: <Widget>[
                                  TextButton(
                                      child: const Text('ok'),
                                      onPressed: () async {
                                        if (pricecontroller.value.text == '') {
                                          null;
                                        } else {
                                          setState(() {
                                            loading = true;
                                          });

                                          Navigator.of(ctx).pop(false);

                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      const BusinessMain(
                                                          'none')));

                                          showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: const Text('in progress!'),
                                              content:
                                                  const CircularProgressIndicator(),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: AnimatedTextKit(
                                                    animatedTexts: [
                                                      TyperAnimatedText(
                                                        '',
                                                        textStyle:
                                                            const TextStyle(
                                                          fontSize: 20,
                                                          color:
                                                              Colors.cyanAccent,
                                                          overflow: TextOverflow
                                                              .visible,
                                                        ),
                                                        speed: const Duration(
                                                            milliseconds: 200),
                                                      )
                                                    ],
                                                    // totalRepeatCount: 2,
                                                    repeatForever: true,
                                                    onNext: (p0, p1) {
                                                      Navigator.of(ctx)
                                                          .pop(false);
                                                    },
                                                  ),
                                                  onPressed: () {},
                                                ),
                                              ],
                                            ),
                                          );

                                          FirebaseMessaging messaging =
                                              FirebaseMessaging.instance;

                                          NotificationSettings settings =
                                              await messaging.requestPermission(
                                            alert: true,
                                            announcement: false,
                                            badge: true,
                                            carPlay: false,
                                            criticalAlert: false,
                                            provisional: false,
                                            sound: true,
                                          );
                                          FirebaseMessaging.onBackgroundMessage(
                                              _onBackgroundMessage);

                                          await FirebaseMessaging.instance
                                              .setForegroundNotificationPresentationOptions(
                                            alert: true,
                                            badge: false,
                                            sound: true,
                                          );
                                          print(
                                              'User granted permission: ${settings.authorizationStatus}');
                                          String? fcmToken =
                                              await fbm.getToken();

                                          final userid = FirebaseAuth
                                              .instance.currentUser!.uid;

                                          final userdoc =
                                              await FirebaseFirestore.instance
                                                  .collection(
                                                      'business_details')
                                                  .where('second_uid',
                                                      isEqualTo: userid)
                                                  .get();
                                          final docid = userdoc.docs.first.id;
                                          final storename = userdoc.docs.first
                                              .data()['store_name'];
                                          final foundsent = userdoc.docs.first
                                              .data()['foundsent'];
                                          final foundseen = userdoc.docs.first
                                              .data()['foundseen'];

                                          final storenamebasic = userdoc
                                              .docs.first
                                              .data()['basicstore_name'];
                                          final storeimage = userdoc.docs.first
                                              .data()['image_url'];
                                          final busid = userdoc.docs.first
                                              .data()['first_uid'];
                                          final crowd = await FirebaseFirestore
                                              .instance
                                              .collection('listing')
                                              .doc(widget.id.toString())
                                              .get();
                                          final cusid = crowd.data()!['userid'];
                                          final lisid = crowd.data()!['id'];

                                          final cusentx =
                                              await FirebaseFirestore
                                                  .instance
                                                  .collection(
                                                      'customer_details')
                                                  .doc(cusid)
                                                  .get();
                                          final cusent =
                                              cusentx.data()!['sent'];
                                          List storeidz = crowd
                                              .data()!['storesidz'] as List;
                                          storeidz.add(docid);
                                          final sentx = crowd.data()!['sent'];
                                          final seenx = crowd.data()!['seen'];
                                          final mylist = await FirebaseFirestore
                                              .instance
                                              .collection('business_details')
                                              .doc(docid)
                                              .collection('mylists')
                                              .doc(cusid)
                                              .get();
                                          mylist.exists
                                              ? FirebaseFirestore.instance
                                                  .collection(
                                                      'business_details')
                                                  .doc(docid)
                                                  .collection('mylists')
                                                  .doc(cusid)
                                                  .update({
                                                  '${lisid.toString()}${cusid}update':
                                                      false
                                                })
                                              : FirebaseFirestore.instance
                                                  .collection(
                                                      'business_details')
                                                  .doc(docid)
                                                  .collection('mylists')
                                                  .doc(cusid)
                                                  .set({
                                                  '${lisid.toString()}${cusid}update':
                                                      false
                                                });
                                          final mylistx =
                                              await FirebaseFirestore
                                                  .instance
                                                  .collection(
                                                      'business_details')
                                                  .doc(docid)
                                                  .collection('mylistsx')
                                                  .doc(lisid.toString())
                                                  .get();
                                          mylistx.exists
                                              ? FirebaseFirestore.instance
                                                  .collection(
                                                      'business_details')
                                                  .doc(docid)
                                                  .collection('mylistsx')
                                                  .doc(lisid.toString())
                                                  .update({
                                                  lisid.toString(): false,
                                                  'id': docid
                                                })
                                              : FirebaseFirestore.instance
                                                  .collection(
                                                      'business_details')
                                                  .doc(docid)
                                                  .collection('mylistsx')
                                                  .doc(lisid.toString())
                                                  .set({
                                                  lisid.toString(): false,
                                                  'id': docid
                                                });

                                          widget.up
                                              ? seenx != sentx
                                                  ? await FirebaseFirestore
                                                      .instance
                                                      .collection('listing')
                                                      .doc(widget.id.toString())
                                                      .update({
                                                      '${storenamebasic}price':
                                                          pricecontroller
                                                              .value.text,
                                                      //  storename: 'off',
                                                      '${storenamebasic}close':
                                                          true,
                                                      '${storenamebasic}closex':
                                                          false,
                                                      'createdAt':
                                                          Timestamp.now(),
                                                      //  'storesidz': storeidz
                                                    })
                                                  : await FirebaseFirestore
                                                      .instance
                                                      .collection('listing')
                                                      .doc(widget.id.toString())
                                                      .update({
                                                      '${storenamebasic}price':
                                                          pricecontroller
                                                              .value.text,
                                                      //   storename: 'off',
                                                      '${storenamebasic}close':
                                                          true,
                                                      '${storenamebasic}closex':
                                                          false,

                                                      'sent': sentx + 1,
                                                    })
                                              : await FirebaseFirestore.instance
                                                  .collection('listing')
                                                  .doc(widget.id.toString())
                                                  .update({
                                                  '${storenamebasic}price':
                                                      pricecontroller
                                                          .value.text,
                                                  storenamebasic: 'off', //
                                                  '${storenamebasic}close':
                                                      false,
                                                  '${storenamebasic}closex':
                                                      false,
                                                  'storesidz': storeidz,
                                                  'sent': sentx + 1,
                                                  '${storenamebasic}messages':
                                                      0,
                                                  '${storenamebasic}messagesseen':
                                                      0,
                                                  '${storenamebasic}image':
                                                      storeimage,
                                                  'createdAt': Timestamp.now(),
                                                });
                                          !widget.up
                                              ? await FirebaseFirestore.instance
                                                  .collection(
                                                      'customer_details')
                                                  .doc(cusid)
                                                  .update({'sent': cusent + 1})
                                              : seenx == sentx
                                                  ? await FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                          'customer_details')
                                                      .doc(cusid)
                                                      .update(
                                                          {'sent': cusent + 1})
                                                  : null;

                                          final getlength =
                                              await FirebaseFirestore.instance
                                                  .collection('reply_comment')
                                                  .orderBy(
                                                    'createdAt',
                                                  )
                                                  .get();
                                          var length = getlength.docs.length;
                                          final indexx = getlength.docs.length;
                                          print(indexx);
                                          print('$fcmToken cxcxcxcxc');

                                          //   setState(() {
                                          idz = indexx + 1;
                                          //      });
                                          await FirebaseFirestore.instance
                                              .collection('reply_comment')
                                              .doc(lisid.toString())
                                              .set({'num': 3});
                                          await FirebaseFirestore.instance
                                              .collection('reply_comment')
                                              .doc(lisid.toString())
                                              .collection('reply')
                                              .doc(busid)
                                              .set({
                                            'replyid': busid,
                                            'listid': lisid,
                                            'businessid': busid,
                                            'replydate': Timestamp.now(),
                                            'storname': storename,
                                            'price': pricecontroller.value.text
                                          });
                                          await FirebaseFirestore.instance
                                              .collection('notify')
                                              .doc()
                                              .set({
                                            'customerid': cusid,
                                            'businessid': busid,
                                            'listid': widget.id,
                                            'createdAt': Timestamp.now(),
                                            'to$cusid': true,
                                            'to$busid': false,
                                            'text': pricecontroller.value.text
                                                .toString(),
                                            'target': cusid,
                                            'store_name': storename
                                          });
                                          final custo = await FirebaseFirestore
                                              .instance
                                              .collection('customer_details')
                                              .doc(cusid)
                                              .collection('tokens')
                                              //   .doc().
                                              //   .doc(fcmToken)
                                              .get();
                                          final tokenx = custo.docs.first
                                              .data()['registrationTokens'];
                                          print(pricecontroller.value.text);
                                          print(tokenx);
                                          print(cusid);

                                          sendpushnotification(
                                              tokenx,
                                              pricecontroller.value.text,
                                              storename);

                                          setState(() {
                                            loading = false;
                                          });
                                        }
                                      }),
                                ],
                              ),
                            );
                          }
                        },
                        child: widget.up
                            ? const Text('update price')
                            : const Text('I Have')),
                    (loading)
                        ? const CircularProgressIndicator()
                        : const SizedBox(),
                    AnimatedTextKit(
                      animatedTexts: [
                        TyperAnimatedText(
                          '',
                          textStyle: const TextStyle(
                              fontStyle: FontStyle.italic, fontSize: 13),
                          speed: const Duration(milliseconds: 200),
                        )
                      ],
                      totalRepeatCount: 1,
                      onNext: (p0, p1) async {
                        if (loadingx == false) {
                          final targ = await FirebaseFirestore.instance
                              .collection('listing')
                              .doc(widget.id.toString())
                              .get();
                          final chox = await FirebaseFirestore.instance
                              .collection('business_details')
                              .where('second_uid',
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser!.uid)
                              .get();
                          final busid = chox.docs.last.data()['first_uid'];

                          setState(() {
                            busidx = chox.docs.first.data()['first_uid'];
                            useridx = targ.data()!['userid'];
                            loadingx = true;
                          });
                        }
                      },
                    ),
                  ])),
            ),
//        )
          );
  }
}
