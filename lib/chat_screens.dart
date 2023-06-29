import 'dart:convert';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alaqy/businessChoose.dart';
import 'package:flutter_alaqy/userChoose.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'messagess.dart';
import 'new_messages.dart';

class ChatScreens extends StatefulWidget {
  static const routeName = '/chatcreens';
  final String id;

  final String username;
  final String storename;
  final String type;
  final String busid;
  final String busid2;
  final String cusid;
  final String basicstorename;
  final String basicusername;
  ChatScreens(this.id, this.username, this.storename, this.type, this.busid,
      this.busid2, this.cusid, this.basicstorename, this.basicusername,
      {super.key});

  @override
  _ChatScreensState createState() => _ChatScreensState();
}

class _ChatScreensState extends State<ChatScreens> {
  final reportcontroller = TextEditingController();
  dynamic report;
  String? banner;
  void onoff() async {
    final opp = widget.type == 'customer' ? widget.busid : widget.cusid;
    final typedoc = await FirebaseFirestore.instance //my typing
        .collection('customer_details')
        .where('first_uid', isEqualTo: opp)
        .get();
    final state = typedoc.docs.first.data()['state'];
    Timestamp lastseen = typedoc.docs.first.data()['lastseen'];
    final lastx =
        'lastseen:${DateFormat('dd/MM/yyyy hh:mm').format(lastseen.toDate())}';

    if (state == 'online') {
      setState(() {
        banner = 'online';
      });
    }
    if (state == 'offline') {
      setState(() {
        banner = lastx;
      });
    }
  }

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.messageId}');
      }
    });

    final pricecontroller = TextEditingController();
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

    final user = FirebaseAuth.instance.currentUser;
    user!.getIdToken();
    fbm.onTokenRefresh;

    // final oppa = Provider.of<Auth>(context, listen: false).userId;
    // final cato = ModalRoute.of(context).settings.arguments as ScreenArguments;
    // final sharko = cato.oppaa;
    // final kitty = cato.titleofcatt;
    // final zuzu = cato.zozo;

    // Firestore.instance
    //     .collection('chato')
    //     .document(oppa)
    //     .updateData({'pokeuser': 'x'});
    // Firestore.instance
    //     .collection('chato')
    //     .document(oppa + 'x')
    //     .updateData({'pokeuser': 'x'});

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            title: widget.type == 'customer'
                ? Text('${widget.storename} -chat')
                : Text(
                    '${(widget.username).trim().replaceAll(RegExp(r'_'), ' ')} -chat',
                  ),
            actions: [
              IconButton(
                  onPressed: () => widget.type == 'customer'
                      ? Navigator.of(context)
                          .pushReplacementNamed(userChoose.routeName)
                      : Navigator.of(context)
                          .pushReplacementNamed(businessChoose.routeName),
                  icon: const Icon(Icons.home)),
              DropdownButton(
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
                                    'please write the reason why you report this chat'),
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

                                        final lisdoc = await FirebaseFirestore
                                            .instance
                                            .collection('customer_details')
                                            .where('second_uid',
                                                isEqualTo: FirebaseAuth
                                                    .instance.currentUser!.uid)
                                            .get();
                                        final reporter =
                                            widget.type != 'customer'
                                                ? lisdoc.docs.last.id
                                                : (widget.cusid + widget.busid);
                                        FirebaseFirestore.instance
                                            .collection('chat_report')
                                            .doc(widget.id.toString())
                                            .set({'time': Timestamp.now()});
                                        FirebaseFirestore.instance
                                            .collection('chat_report')
                                            .doc(widget.id.toString())
                                            .collection('reporters')
                                            .doc(reporter)
                                            .set({
                                          'reportid': widget.id,
                                          'listid': widget.id,
                                          'reporter': reporter,
                                          'reported': widget.type == 'customer'
                                              ? widget.busid
                                              : widget.cusid,
                                          'closed case': false,
                                          'notes': '',
                                          'reasons':
                                              reportcontroller.value.text,
                                        });
                                        //_report();
                                      }
                                    },
                                  ),
                                ]));
                  }
                },
              )
            ]),
        body: Container(
            child: SingleChildScrollView(
          child: SizedBox(
            height: 700,
            child: Column(
              children: <Widget>[
                AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText(
                        banner.toString() == 'null'
                            ? 'online'
                            : banner.toString(),
                        colors: [
                          banner == 'online' ? Colors.tealAccent : Colors.grey,
                          Colors.deepPurple,
                          banner == 'online' ? Colors.cyanAccent : Colors.grey,
                        ],
                        textStyle: const TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                        speed: const Duration(milliseconds: 100)),
                  ],
                  repeatForever: true,
                ),
                Expanded(
                  child: Messagess(
                      widget.id,
                      widget.type,
                      widget.storename,
                      widget.username,
                      widget.basicstorename,
                      widget.basicusername),
                ),
                NewMessages(
                    widget.id,
                    widget.type,
                    widget.storename,
                    widget.username,
                    widget.busid,
                    widget.busid2,
                    widget.cusid,
                    widget.basicstorename,
                    widget.basicusername),
                AnimatedTextKit(
                  animatedTexts: [
                    TyperAnimatedText(
                      '',
                      textStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.cyanAccent,
                        overflow: TextOverflow.visible,
                      ),
                      speed: const Duration(seconds: 4),
                    )
                  ],
                  // totalRepeatCount: 2,
                  repeatForever: true,
                  onNext: (p0, p1) {
                    onoff();
                  },
                  onNextBeforePause: (p0, p1) {
                    onoff();
                  },
                ),
              ],
            ),
          ),
        )));
  }
}
