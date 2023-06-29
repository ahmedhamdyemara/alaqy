import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'message_bubbles.dart';

class Messagess extends StatefulWidget {
  static const routeName = '/messagess';
  final String id;
  final String type;
  final String storename;
  final String username;
  final String basicstorename;
  final String basicusername;
  Messagess(
    this.id,
    this.type,
    this.storename,
    this.username,
    this.basicstorename,
    this.basicusername,
  );
  @override
  State<Messagess> createState() => _MessagessState();
}

class _MessagessState extends State<Messagess> {
  @override
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
    // final notya = cato.notifyadmin;
    // final notyu = cato.notifyuser;
    // final fbm = FirebaseMessaging();
    // fbm.getToken();
    //  fbm.subscribeToTopic(notyu);
    // fbm.onTokenRefresh;
    // return FutureBuilder(
    //   future: FirebaseAuth.instance.currentUser(),
    //   builder: (ctx, futureSnapshot) {
    //     if (futureSnapshot.connectionState == ConnectionState.waiting) {
    //       return Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     }
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .doc(widget.id)
            .collection('chatx')
            .where('combo',
                isEqualTo: '${widget.basicusername}${widget.basicstorename}')
            .orderBy(
              'createdAt',
              descending: true,
            )
            .snapshots(),
        builder: (ctx, chatSnapshottt) {
          // if (chatSnapshottt.connectionState == ConnectionState.waiting) {
          //   return chatSnapshottt.hasData
          //       ? const Center(
          //           child: CircularProgressIndicator(),
          //         )
          //       : const Center(
          //           child: Text('loading'),
          //         );
          // }
          if (chatSnapshottt.hasData == false) {
            return const Center(child: Text('start messaging'));
          }
          final chatDocs = chatSnapshottt.data!.docs;
          chatDocs.removeWhere((element) =>
              element.data()['text'] == FirebaseAuth.instance.currentUser!.uid);
          widget.type == 'business'
              ? chatDocs.removeWhere(
                  (element) => element.data()['text'] == 'loadingxcus??!!')
              : chatDocs.removeWhere(
                  (element) => element.data()['text'] == 'loadingxbus??!!');
          final username =
              widget.type == 'business' ? widget.storename : widget.username;
          return ListView.builder(
            reverse: true,
            itemCount: chatDocs.length,
            itemBuilder: (ctx, index) => MessageBubbles(
              chatDocs[index]['text'],
              chatDocs[index]['username'],
              chatDocs[index]['userimage'],
              chatDocs[index]['stroeimage'],
              chatDocs[index]['store_name'],
              chatDocs[index]['to'] == user.uid,
              widget.type,
              chatDocs[index]['to'], user.uid, chatDocs[index]['listid'],
//               key: ValueKey(chatDocs[index].id
// ),
            ),
          );
        });
  }
}
