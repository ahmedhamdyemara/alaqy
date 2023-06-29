import 'dart:convert';
import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'barpictrans.dart';

class NewMessages extends StatefulWidget {
  static const routeName = '/newmessages';
  final String id;
  final String type;
  final String storename;
  final String username;
  final String busid;
  final String busid2;
  final String cusidd;
  final String basicstorename;
  final String basicusername;
  NewMessages(this.id, this.type, this.storename, this.username, this.busid,
      this.busid2, this.cusidd, this.basicstorename, this.basicusername);

  @override
  _NewMessagesState createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  final _controller = new TextEditingController();
  var _enteredMessage = '';
  var blovsunblo = 'block';
  var block = 'unchain';
  var repan = 'active';

  final reportcontroller = TextEditingController();
  dynamic report;
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

  final _controllernode = FocusNode();

  @override
  void initState() {
    _controllernode.addListener(_meskey);
    super.initState();
  }

  @override
  void dispose() {
    _controllernode.removeListener(_meskey);
    super.dispose();
  }

  void _meskey() {
    if (!_controllernode.hasFocus) {
      //   if ((!_imageUrlController.text.startsWith('http') &&
      //         !_imageUrlController.text.startsWith('https')) ||
      //   (!_imageUrlController.text.endsWith('.png') &&
      //     !_imageUrlController.text.endsWith('.jpg') &&
      //   !_imageUrlController.text.endsWith('.jpeg'))) {
      // return;
      //   }
      setState(() {});
    }
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
    void _typingdelete() async {
      final typedoc = await FirebaseFirestore.instance //my typing
          .collection('chat')
          .doc(widget.id.toString())
          .collection('chatx')
          .doc('${widget.basicusername}${widget.basicstorename}typ')
          .get();
      final typedocbus = await FirebaseFirestore.instance //my typing
          .collection('chat')
          .doc(widget.id.toString())
          .collection('chatx')
          .doc('${widget.basicusername}bus${widget.basicstorename}typ')
          .get();
      if (widget.type == 'customer') {
        typedoc.exists
            ? await FirebaseFirestore.instance //my typing
                .collection('chat')
                .doc(widget.id.toString())
                .collection('chatx')
                .doc('${widget.basicusername}${widget.basicstorename}typ')
                .update({'combo': 'xxx'})
            : null;
      }
      if (widget.type == 'business') {
        typedocbus.exists
            ? await FirebaseFirestore.instance //my typing
                .collection('chat')
                .doc(widget.id.toString())
                .collection('chatx')
                .doc('${widget.basicusername}bus${widget.basicstorename}typ')
                .update({'combo': 'xxx'})
            : null;
      }
    }

    void _typing() async {
      print('typing');
      final listdoc = await FirebaseFirestore.instance
          .collection('listing')
          .doc(widget.id.toString())
          .get();
      final store_nameprice = listdoc.data()!['${widget.basicstorename}price'];
      final store_messagesIndicator = listdoc.data()![widget.basicstorename];
      final store_messages =
          listdoc.data()!['${widget.basicstorename}messages'];
      final store_messagesseen =
          listdoc.data()!['${widget.basicstorename}messagesseen'];
      final cusid = listdoc.data()!['userid'];
      final storeimage = listdoc.data()!['${widget.basicstorename}image'];
      final userimage = listdoc.data()!['userimage'];
      final messbaqy = store_messages - store_messagesseen;
      final messages = listdoc.data()!['messages'];
      final messages_seen = listdoc.data()!['messages_seen'];
      final sent = listdoc.data()!['sent'];
      final seen = listdoc.data()!['seen'];
      final userid2 = listdoc.data()!['userid2'];

      final sentminseen = sent - seen;
      widget.type == 'customer'
          ? await FirebaseFirestore.instance //my typing
              .collection('chat')
              .doc(widget.id.toString())
              .collection('chatx')
              .doc('${widget.basicusername}${widget.basicstorename}typ')
              .set({
              'customerid': cusid,
              'businessid': widget.busid,
              'listid': 'flag for typing',
              'createdAt': Timestamp.now(),
              'to$cusid': false,
              'to${widget.busid}': true,
              'text': FirebaseAuth.instance.currentUser!.uid,
              'to': userid2,
              'store_name': widget.storename,
              'basicstore_name': widget.basicstorename,
              'basicusername': widget.basicusername,
              'stroeimage': storeimage,
              'userimage': userimage,
              'username': widget.username,
              'combo': '${widget.basicusername}${widget.basicstorename}'
            })
          : await FirebaseFirestore.instance //my typing
              .collection('chat')
              .doc(widget.id.toString())
              .collection('chatx')
              .doc('${widget.username}bus${widget.storename}typ')
              .set({
              'customerid': cusid,
              'businessid': widget.busid,
              'listid': 'flag for typing',
              'createdAt': Timestamp.now(),
              'to$cusid': true,
              'to${widget.busid}': false,
              'text': FirebaseAuth.instance.currentUser!.uid,
              'to': widget.busid2,
              'store_name': widget.storename,
              'basicstore_name': widget.basicstorename,
              'basicusername': widget.basicusername,
              'stroeimage': storeimage,
              'userimage': userimage,
              'username': widget.username,
              'combo': '${widget.basicusername}${widget.basicstorename}'
            });
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
      final mustaddedseen = foundseenx.fold(
          0, (previousValue, element) => previousValue + element);

      FirebaseFirestore.instance
          .collection('business_details')
          .doc(idx)
          .update({'foundsent': mustaddedsent, 'foundseen': mustaddedseen});
    }

    void _seen() async {
      final lastchat = widget.type == 'business'
          ? await FirebaseFirestore.instance //my typing
              .collection('chat')
              .doc(widget.id.toString())
              .collection('chatx')
              .where('basicstore_name', isEqualTo: widget.basicstorename)
              .get()
          : await FirebaseFirestore.instance //my typing
              .collection('chat')
              .doc(widget.id.toString())
              .collection('chatx')
              .where('basicusername', isEqualTo: widget.basicusername)
              .get();
      final lastchatwho = lastchat.docs.last.id;
      // last.data()['to'];
      final zzz = await FirebaseFirestore.instance //my typing
          .collection('chat')
          .doc(widget.id.toString())
          .collection('chatx')
          .doc(lastchatwho)
          .get();
      final whho = zzz.data()!['to'];

      final listdoc = await FirebaseFirestore.instance
          .collection('listing')
          .doc(widget.id.toString())
          .get();

      final store_nameprice = listdoc.data()!['${widget.basicstorename}price'];
      final store_messagesIndicator = listdoc.data()![widget.basicstorename];
      final store_messages =
          listdoc.data()!['${widget.basicstorename}messages'];
      final store_messagesseen =
          listdoc.data()!['${widget.basicstorename}messagesseen'];
      final cusid = listdoc.data()!['userid'];
      final storeimage = listdoc.data()!['${widget.basicstorename}image'];
      final userimage = listdoc.data()!['userimage'];
      final messbaqy = store_messages - store_messagesseen;
      final messages = listdoc.data()!['messages'];
      final messages_seen = listdoc.data()!['messages_seen'];
      final sent = listdoc.data()!['sent'];
      final seen = listdoc.data()!['seen'];
      final userid2 = listdoc.data()!['userid2'];

      final sentminseen = sent - seen;
      final repto = listdoc
          .data()!['post_owner_reply_to_business${widget.basicstorename}'];
      //  if (whho == FirebaseAuth.instance.currentUser!.uid) {
      widget.type == 'customer'
          ? await FirebaseFirestore.instance
              .collection('listing')
              .doc(widget.id.toString())
              .update({
              'seen': sentminseen == 0 ? seen : seen + messbaqy,
              'messages_seen': messages_seen + messbaqy,
              '${widget.basicstorename}messagesseen': store_messages
            })
          : await FirebaseFirestore.instance
              .collection('listing')
              .doc(widget.id.toString())
              .update({
              'post_owner_seen_by_business${widget.basicstorename}': repto
            });
      // final persondocs = await FirebaseFirestore.instance
      //     .collection('customer_details')
      //     .where('second_uid',
      //         isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      //     .get();
      // final state = persondocs.docs.last.data()['state'];
      // final lastdoc = await FirebaseFirestore.instance //my typing
      //     .collection('chat')
      //     .doc(widget.id.toString())
      //     .collection('chatx')
      //     .get();
      // final lastlen = lastdoc.docs.length + 1;
      // final lastcox = await FirebaseFirestore.instance
      //     .collection('chat')
      //     .doc(widget.id.toString())
      //     .collection('chatx')
      //     .doc(lastlen.toString())
      //     .get();
      // final lastdox = lastcox.data()!['to'];
      // print(lastlen);
      // print(userx);

      //   if (lastdox != userx) {
      //   }
      final lastsent = await FirebaseFirestore.instance
          .collection('chat')
          .doc(widget.id.toString())
          .collection('chatx')
          .doc(widget.busid + widget.cusidd)
          .get();
      final lastsentx =
          lastsent.exists ? lastsent.data()!['lastsent'] : 'customer';
      if (widget.type == 'customer' && lastsentx == 'business') {
        final chatxx = await FirebaseFirestore.instance
            .collection('chat')
            .doc(widget.id.toString())
            .collection('chatx')
            .doc('${widget.basicusername}bus${widget.basicstorename}')
            .get();
        chatxx.exists
            ? await FirebaseFirestore.instance
                .collection('chat')
                .doc(widget.id.toString())
                .collection('chatx')
                .doc('${widget.basicusername}bus${widget.basicstorename}')
                .update({'combo': 'xxx'})
            : null;
        await FirebaseFirestore.instance //my typing
            .collection('chat')
            .doc(widget.id.toString())
            .collection('chatx')
            .doc('${widget.basicusername}${widget.basicstorename}')
            .set({
          'customerid': cusid,
          'businessid': widget.busid,
          'listid': widget.id,
          'createdAt': Timestamp.now(),
          'to$cusid': false,
          'to${widget.busid}': true,
          'text': FirebaseAuth.instance.currentUser!.uid,
          'to': userid2,
          'store_name': widget.storename,
          'basicstore_name': widget.basicstorename,
          'basicusername': widget.basicusername,
          'stroeimage': storeimage,
          'userimage': userimage,
          'username': widget.username,
          'combo': '${widget.basicusername}${widget.basicstorename}'
        });
      }
      if (widget.type == 'business' && lastsentx == 'customer') {
        final chatxx = await FirebaseFirestore.instance
            .collection('chat')
            .doc(widget.id.toString())
            .collection('chatx')
            .doc('${widget.basicusername}${widget.basicstorename}')
            .get();
        chatxx.exists
            ? await FirebaseFirestore.instance
                .collection('chat')
                .doc(widget.id.toString())
                .collection('chatx')
                .doc('${widget.basicusername}${widget.basicstorename}')
                .update({'combo': 'xxx'})
            : null;
        await FirebaseFirestore.instance //my typing
            .collection('chat')
            .doc(widget.id.toString())
            .collection('chatx')
            .doc('${widget.basicusername}bus${widget.basicstorename}')
            .set({
          'customerid': cusid,
          'businessid': widget.busid,
          'listid': widget.id,
          'createdAt': Timestamp.now(),
          'to$cusid': true,
          'to${widget.busid}': false,
          'text': FirebaseAuth.instance.currentUser!.uid,
          'to': widget.busid2,
          'store_name': widget.storename,
          'stroeimage': storeimage,
          'userimage': userimage,
          'username': widget.username,
          'combo': '${widget.basicusername}${widget.basicstorename}',
          'basicstore_name': widget.basicstorename,
          'basicusername': widget.basicusername,
        });
      }
      foundsentseen();
    }

    void _sendMessagecustomer() async {
      print('luck');
      final chatxx = await FirebaseFirestore.instance
          .collection('chat')
          .doc(widget.id.toString())
          .collection('chatx')
          .doc('${widget.basicusername}${widget.basicstorename}')
          .get();
      chatxx.exists
          ? await FirebaseFirestore.instance
              .collection('chat')
              .doc(widget.id.toString())
              .collection('chatx')
              .doc('${widget.basicusername}${widget.basicstorename}')
              .update({'combo': 'xxx'})
          : null;
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: false,
        sound: true,
      );
      print('User granted permission: ${settings.authorizationStatus}');
      String? fcmToken = await fbm.getToken();
      _controller.clear();

      final listdoc = await FirebaseFirestore.instance
          .collection('listing')
          .doc(widget.id.toString())
          .get();
      final store_nameprice = listdoc.data()!['${widget.basicstorename}price'];
      final store_messagesIndicator = listdoc.data()![widget.basicstorename];
      final store_messages =
          listdoc.data()!['${widget.basicstorename}messages'];
      final store_messagesseen =
          listdoc.data()!['${widget.basicstorename}messagesseen'];
      final cusid = listdoc.data()!['userid'];
      final storeimage = listdoc.data()!['${widget.basicstorename}image'];
      final userimage = listdoc.data()!['userimage'];
      final messbaqy = store_messages - store_messagesseen;
      final messages = listdoc.data()!['messages'];
      final messages_seen = listdoc.data()!['messages_seen'];
      final sent = listdoc.data()!['sent'];
      final seen = listdoc.data()!['seen'];

      final sentminseen = sent - seen;
      await FirebaseFirestore.instance
          .collection('listing')
          .doc(widget.id.toString())
          .update({
        'seen': sentminseen == 0 ? seen : seen + messbaqy,
        'messages_seen': messages_seen + messbaqy,
        '${widget.basicstorename}messagesseen': store_messages,
        'createdAt': Timestamp.now(),
      });
      if (store_messagesIndicator == 'off') {
        await FirebaseFirestore.instance
            .collection('listing')
            .doc(widget.id.toString())
            .update({
          widget.storename: 'on',
          'post_owner_reply_to_business${widget.basicstorename}': 1,
          'post_owner_seen_by_business${widget.basicstorename}': 0,
          'createdAt': Timestamp.now(),
        });
        await FirebaseFirestore.instance
            .collection('chat')
            .doc(widget.id.toString())
            .set({
          'customerid': cusid,
          widget.basicstorename: widget.storename,
          'listid': widget.id,
          'last shop link': Timestamp.now(),
        });
        await FirebaseFirestore.instance
            .collection('chat')
            .doc(widget.id.toString())
            .collection('chatx')
            .doc('1')
            .set({
          'customerid': cusid,
          'businessid': widget.busid,
          'listid': widget.id,
          'createdAt': Timestamp.now(),
          'to$cusid': false,
          'to${widget.busid}': true,
          'text': _enteredMessage,
          'to': widget.busid2,
          'store_name': widget.storename,
          'basicstore_name': widget.basicstorename,
          'basicusername': widget.basicusername,
          'stroeimage': storeimage,
          'userimage': userimage,
          'username': widget.username,
          'combo': '${widget.basicusername}${widget.basicstorename}'
        });
//  await FirebaseFirestore.instance //my seen
//             .collection('chat')
//             .doc(widget.id.toString())
//             .collection('chatx')
//             .doc(FirebaseAuth.instance.currentUser!.uid)
//             .set({
//           'customerid': cusid,
//           'businessid': widget.busid,
//           'listid': widget.id,
//           'createdAt': Timestamp.now(),
//           'to$cusid': false,
//           'to${widget.busid}': true,
//           'text':FirebaseAuth.instance.currentUser!.uid,
//           'to': widget.busid2,
//           'store_name': widget.storename,
//           'stroeimage': storeimage,
//           'userimage': userimage,
//           'username': widget.username,
//         });
// await FirebaseFirestore.instance //my typing
//             .collection('chat')
//             .doc(widget.id.toString())
//             .collection('chatx')
//             .doc(FirebaseAuth.instance.currentUser!.email)
//             .set({
//           'customerid': cusid,
//           'businessid': widget.busid,
//           'listid': 'flag for typing',
//           'createdAt': Timestamp.now(),
//           'to$cusid': false,
//           'to${widget.busid}': true,
//           'text':FirebaseAuth.instance.currentUser!.uid,
//           'to': widget.busid2,
//           'store_name': widget.storename,
//           'stroeimage': storeimage,
//           'userimage': userimage,
//           'username': widget.username,
//         });
      }
      if (store_messagesIndicator == 'on') {
        final owner = await FirebaseFirestore.instance
            .collection('listing')
            .doc(widget.id.toString())
            .get();
        final owrep = owner
            .data()!['post_owner_reply_to_business${widget.basicstorename}'];
        final owseen = owner
            .data()!['post_owner_seen_by_business${widget.basicstorename}'];
        await FirebaseFirestore.instance
            .collection('listing')
            .doc(widget.id.toString())
            .update({
          'post_owner_reply_to_business${widget.basicstorename}': owrep + 1,
          //     'post_owner_seen': 0,
        });
        final chatxdocs = await FirebaseFirestore.instance
            .collection('chat')
            .doc(widget.id.toString())
            .collection('chatx')
            .get();
        final lastdocid = chatxdocs.docs.length;
        final lastdocidnum = lastdocid;
        final newdocid = lastdocidnum + 1;
        await FirebaseFirestore.instance
            .collection('chat')
            .doc(widget.id.toString())
            .collection('chatx')
            .doc(newdocid.toString())
            .set({
          'customerid': cusid,
          'businessid': widget.busid,
          'listid': widget.id,
          'createdAt': Timestamp.now(),
          'to$cusid': false,
          'to${widget.busid}': true,
          'text': _enteredMessage,
// 'businessid2':busid2,
// 'customerid2':userx,
          'to': widget.busid2,
          //  'target': cusid,
          'store_name': widget.storename,
          'basicstore_name': widget.basicstorename,
          'basicusername': widget.basicusername,
          'stroeimage': storeimage,
          'userimage': userimage,
          'username': widget.username,
          'combo': '${widget.basicusername}${widget.basicstorename}'
        });
        await FirebaseFirestore.instance
            .collection('chat')
            .doc(widget.id.toString())
            .collection('chatx')
            .doc(widget.cusidd + widget.busid)
            .collection('chatxx')
            .add({
          'customerid': cusid,
          'businessid': widget.busid,
          'listid': widget.id,
          'createdAt': Timestamp.now(),
          'to$cusid': false,
          'to${widget.busid}': true,
          'text': _enteredMessage,
// 'businessid2':busid2,
// 'customerid2':userx,
          'to': widget.busid2,
          //  'target': cusid,
          'store_name': widget.storename,
          'basicstore_name': widget.basicstorename,
          'basicusername': widget.basicusername,
          'stroeimage': storeimage,
          'userimage': userimage,
          'username': widget.username,
          'combo': '${widget.basicusername}${widget.basicstorename}'
        });
      }
      await FirebaseFirestore.instance
          .collection('chat')
          .doc(widget.id.toString())
          .collection('chatx')
          .doc(widget.busid + widget.cusidd)
          .set({
        'lastsent': 'customer',
        'createdAt': Timestamp.now(),
      });

      final send = await FirebaseFirestore.instance
          .collection('customer_details')
          .doc(widget.busid)
          .collection('tokens')
          .get();
      final tokenx = send.docs.first.data()['registrationTokens'];
      print(tokenx);
      print(",,,,,,,,<<<<>>>>>>>>>");

      //    sendpushnotification(tokenx, _enteredMessage, widget.username);
      final business = await FirebaseFirestore.instance
          .collection('business_details')
          .doc(widget.busid.toString())
          .get();
      final foundsent = business.data()!['foundsent'];
      FirebaseFirestore.instance
          .collection('business_details')
          .doc(widget.busid.toString())
          .update({'foundsent': foundsent + 1});
      print('customer');
      setState(() {
        _controller.clear();
        _enteredMessage = '';

        //    FocusManager.instance.primaryFocus?.unfocus();
        // _controller.removeListener(() {
        //   _controller.dispose();
        // });
        // KeyboardLockMode;
        //    Navigator.of(context).pop(false);

        // _controllernode.nextFocus();
        // _controllernode.removeListener(_meskey);
      });

      Future.delayed(const Duration(seconds: 9), (() async {
        final chatDocs = await FirebaseFirestore.instance
            .collection('listing')
            .doc(widget.id.toString())
            .get();
        final badgo1 = chatDocs
            .data()!['post_owner_reply_to_business${widget.basicstorename}'];
        final badgo2 = chatDocs
            .data()!['post_owner_seen_by_business${widget.basicstorename}'];

        final badgoo = badgo1 - badgo2;
        print('${chatDocs.data()!['messages']} lololololololololo');
        print('$badgo1 lololololololololo');
        print('$badgo2 lololololololololo');
        print('$badgoo lololololololololo');

        badgoo > 0
            ? await FirebaseFirestore.instance.collection('notify').doc().set({
                'customerid': cusid,
                'businessid': {widget.busid},
                'listid': widget.id,
                'createdAt': Timestamp.now(),
                'to$cusid': false,
                'to${widget.busid}': true,
                'text': _enteredMessage,
                'target': widget.busid,
                'store_name': widget.username
              })
            : null;
        badgoo > 0
            ? sendpushnotification(tokenx, _enteredMessage, widget.username)
            : null;
      }));
    }

    void _sendMessage() async {
      print('luck');
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      final chatxx = await FirebaseFirestore.instance
          .collection('chat')
          .doc(widget.id.toString())
          .collection('chatx')
          .doc('${widget.basicusername}bus${widget.basicstorename}')
          .get();
      chatxx.exists
          ? await FirebaseFirestore.instance
              .collection('chat')
              .doc(widget.id.toString())
              .collection('chatx')
              .doc('${widget.basicusername}bus${widget.basicstorename}')
              .update({'combo': 'xxx'})
          : null;
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: false,
        sound: true,
      );
      print('User granted permission: ${settings.authorizationStatus}');
      String? fcmToken = await fbm.getToken();
      _controller.clear();

      final targ = await FirebaseFirestore.instance
          .collection('listing')
          .doc(widget.id.toString())
          .get();
      // final tarid = targ.data()!['userid'];

      final repto =
          targ.data()!['post_owner_reply_to_business${widget.basicstorename}'];
      final busmess = targ.data()!['${widget.basicstorename}messages'];
      final busmessseen = targ.data()!['${widget.basicstorename}messagesseen'];
      final sent = targ.data()!['sent'];
      final messages = targ.data()!['messages'];
      FirebaseFirestore.instance
          .collection('listing')
          .doc(widget.id.toString())
          .update({
        'post_owner_seen_by_business${widget.basicstorename}': repto,
        '${widget.basicstorename}messages': busmess + 1,
        'sent': sent + 1,
        'messages': messages + 1,
        'createdAt': Timestamp.now(),
      });

      final chatxdocs = await FirebaseFirestore.instance
          .collection('chat')
          .doc(widget.id.toString())
          .collection('chatx')
          .get();
      final chfox = await FirebaseFirestore.instance
          .collection('listing')
          .doc(widget.id.toString())
          .get();
      final chox = await FirebaseFirestore.instance
          .collection('business_details')
          .where('second_uid',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      final cusid = chatxdocs.docs.first.data()['customerid'];
      final busid = chox.docs.last.data()['first_uid'];
      final store_name = chox.docs.last.data()['store_name'];
      final storeimage = chox.docs.last.data()['image_url'];
      final userimage = chfox.data()!['userimage'];
      final username = chfox.data()!['username'];
      final userid2 = chfox.data()!['userid2'];

      // if (fcmToken != null) {
      //   await FirebaseFirestore.instance
      //       .collection('business_details')
      //       .doc(busid)
      //       .collection('tokens')
      //       .doc(fcmToken)
      //       .set({
      //     'createdAt': Timestamp.now(),
      //     'platform': Platform.operatingSystem.toString(),
      //     'registrationTokens': fcmToken,
      //   });

      // }
      final lastdocid = chatxdocs.docs.length;
      final lastdocidnum = lastdocid;
      final newdocid = lastdocidnum + 1;
      await FirebaseFirestore.instance
          .collection('chat')
          .doc(widget.id.toString())
          .collection('chatx')
          .doc(newdocid.toString())
          .set({
        'customerid': cusid,
        'businessid': busid,
        'listid': widget.id,
        'createdAt': Timestamp.now(),
        'to$cusid': true,
        'to$busid': false,
        'text': _enteredMessage,
        //  'target': cusid,
        'store_name': store_name,
        'basicstore_name': widget.basicstorename,
        'basicusername': widget.basicusername,
        'stroeimage': storeimage,
        'userimage': userimage,
        'username': username,
        'to': userid2,
        'combo': '${widget.basicusername}${widget.basicstorename}'
      });
      await FirebaseFirestore.instance
          .collection('chat')
          .doc(widget.id.toString())
          .collection('chatx')
          .doc(widget.cusidd + widget.busid)
          .collection('chatxx')
          .add({
        'customerid': cusid,
        'businessid': busid,
        'listid': widget.id,
        'createdAt': Timestamp.now(),
        'to$cusid': true,
        'to$busid': false,
        'text': _enteredMessage,
        //  'target': cusid,
        'store_name': store_name,
        'basicstore_name': widget.basicstorename,
        'basicusername': widget.basicusername,
        'stroeimage': storeimage,
        'userimage': userimage,
        'username': username,
        'to': userid2,
        'combo': '${widget.basicusername}${widget.basicstorename}'
      });
      await FirebaseFirestore.instance
          .collection('chat')
          .doc(widget.id.toString())
          .collection('chatx')
          .doc(widget.busid + widget.cusidd)
          .set({
        'lastsent': 'business',
        'createdAt': Timestamp.now(),
      });

      final send = await FirebaseFirestore.instance
          .collection('customer_details')
          .doc(cusid)
          .collection('tokens')
          .get();
      final tokenx = send.docs.first.data()['registrationTokens'];
      print(tokenx);
      print(",,,,,,,,<<<<>>>>>>>>>");

      //   sendpushnotification(tokenx, _enteredMessage, store_name);

      print('business');
      setState(() {
        _controller.clear();
        _enteredMessage = '';
        //    FocusManager.instance.primaryFocus?.unfocus();
        // _controller.removeListener(() {
        //   _controllernode.onKey;
        // });
        //    Navigator.of(context).pop(false);
        //  KeyboardLockMode;
        // _controllernode.nextFocus();
        // _controllernode.removeListener(_meskey);
      });

      Future.delayed(const Duration(seconds: 9), (() async {
        final chatDocs = await FirebaseFirestore.instance
            .collection('listing')
            .doc(widget.id.toString())
            .get();
        final badgo1 = chatDocs.data()!['messages'];
        final badgo2 = chatDocs.data()!['messages_seen'];

        final badgoo = badgo1 - badgo2;
        print('${chatDocs.data()!['messages'].toString()} lololololololololo');
        print('$badgo1 lololololololololo');
        print('$badgo2 lololololololololo');
        badgoo > 0
            ? await FirebaseFirestore.instance.collection('notify').doc().set({
                'customerid': cusid,
                'businessid': busid,
                'listid': widget.id,
                'createdAt': Timestamp.now(),
                'to$cusid': true,
                'to$busid': false,
                'text': _enteredMessage,
                'target': widget.cusidd,
                'store_name': widget.storename
              })
            : null;
        badgoo > 0
            ? sendpushnotification(tokenx, _enteredMessage, store_name)
            : null;
      }));
    }

// void removespinner() async {if (widget.type == 'business') {
//           final cow = await FirebaseFirestore.instance
//               .collection('chat')
//               .doc(widget.id.toString())
//               .collection('chatx')
//               .doc('${widget.basicusername}busloading${widget.basicstorename}')
//               .get();
//           cow.exists
//               ? FirebaseFirestore.instance
//                   .collection('chat')
//                   .doc(widget.id.toString())
//                   .collection('chatx')
//                   .doc(
//                       '${widget.basicusername}busloading${widget.basicstorename}')
//                   .update({'combo': 'xxxx'})
//               : null;
//         }}
    void _submitAuthForm(
      String title,
      File? image,
      BuildContext ctx,
    ) async {
      var url;
      if (widget.type == 'business') {
        final chatxdocs = await FirebaseFirestore.instance
            .collection('chat')
            .doc(widget.id.toString())
            .collection('chatx')
            .get();
        final chfox = await FirebaseFirestore.instance
            .collection('listing')
            .doc(widget.id.toString())
            .get();
        final chox = await FirebaseFirestore.instance
            .collection('business_details')
            .where('second_uid',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get();
        final cusid = chatxdocs.docs.first.data()['customerid'];
        final busid = chox.docs.last.data()['first_uid'];
        final store_name = chox.docs.last.data()['store_name'];
        final storeimage = chox.docs.last.data()['image_url'];
        final userimage = chfox.data()!['userimage'];
        final username = chfox.data()!['username'];
        final userid2 = chfox.data()!['userid2'];

        FirebaseMessaging messaging = FirebaseMessaging.instance;
        FirebaseFirestore.instance
            .collection('chat')
            .doc(widget.id.toString())
            .collection('chatx')
            .doc('${widget.basicusername}busloading${widget.basicstorename}')
            .set({
          'customerid': cusid,
          'businessid': busid,
          'listid': widget.id,
          'createdAt': Timestamp.now(),
          'to$cusid': false,
          'to$busid': true,
          'text': 'loadingxbus??!!',
          //  'target': cusid,
          'store_name': store_name,
          'basicstore_name': widget.basicstorename,
          'basicusername': widget.basicusername,
          'stroeimage': storeimage,
          'userimage': userimage,
          'username': username,
          'to': FirebaseAuth.instance.currentUser!.uid,
          'combo': '${widget.basicusername}${widget.basicstorename}'
        });
      }
      if (widget.type == 'customer') {
        final listdoc = await FirebaseFirestore.instance
            .collection('listing')
            .doc(widget.id.toString())
            .get();
        final store_nameprice =
            listdoc.data()!['${widget.basicstorename}price'];
        final store_messagesIndicator = listdoc.data()![widget.basicstorename];
        final store_messages =
            listdoc.data()!['${widget.basicstorename}messages'];
        final store_messagesseen =
            listdoc.data()!['${widget.basicstorename}messagesseen'];
        final cusid = listdoc.data()!['userid'];
        final storeimage = listdoc.data()!['${widget.basicstorename}image'];
        final userimage = listdoc.data()!['userimage'];
        final messbaqy = store_messages - store_messagesseen;
        final messages = listdoc.data()!['messages'];
        final messages_seen = listdoc.data()!['messages_seen'];
        final sent = listdoc.data()!['sent'];
        final seen = listdoc.data()!['seen'];

        final sentminseen = sent - seen;
        await FirebaseFirestore.instance
            .collection('listing')
            .doc(widget.id.toString())
            .update({
          'seen': sentminseen == 0 ? seen : seen + messbaqy,
          'messages_seen': messages_seen + messbaqy,
          '${widget.basicstorename}messagesseen': store_messages
        });
        FirebaseFirestore.instance
            .collection('chat')
            .doc(widget.id.toString())
            .collection('chatx')
            .doc('${widget.basicusername}loading${widget.basicstorename}')
            .set({
          'customerid': cusid,
          'businessid': widget.busid,
          'listid': widget.id,
          'createdAt': Timestamp.now(),
          'to$cusid': true,
          'to${widget.busid}': false,
          'text': 'loadingxcus??!!',
          //  'target': cusid,
          'store_name': widget.storename,
          'basicstore_name': widget.basicstorename,
          'basicusername': widget.basicusername,
          'stroeimage': storeimage,
          'userimage': userimage,
          'username': widget.username,
          'to': FirebaseAuth.instance.currentUser!.uid,
          'combo': '${widget.basicusername}${widget.basicstorename}'
        });
      }

      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child('${Timestamp.now().toString()}.jpg');
      //.child('vv.jpg');
      print('laasaaaaaa');
      await ref.putFile(image!).whenComplete(() => image);

      url = await ref.getDownloadURL();

      if (widget.type == 'business') {
        FirebaseMessaging messaging = FirebaseMessaging.instance;
        final chatxx = await FirebaseFirestore.instance
            .collection('chat')
            .doc(widget.id.toString())
            .collection('chatx')
            .doc('${widget.basicusername}bus${widget.basicstorename}')
            .get();
        chatxx.exists
            ? await FirebaseFirestore.instance
                .collection('chat')
                .doc(widget.id.toString())
                .collection('chatx')
                .doc('${widget.basicusername}bus${widget.basicstorename}')
                .update({'combo': 'xxx'})
            : null;
        NotificationSettings settings = await messaging.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
        FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);

        await FirebaseMessaging.instance
            .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: false,
          sound: true,
        );
        print('User granted permission: ${settings.authorizationStatus}');
        String? fcmToken = await fbm.getToken();
        _controller.clear();

        final targ = await FirebaseFirestore.instance
            .collection('listing')
            .doc(widget.id.toString())
            .get();
        // final tarid = targ.data()!['userid'];

        final repto = targ
            .data()!['post_owner_reply_to_business${widget.basicstorename}'];
        final busmess = targ.data()!['${widget.basicstorename}messages'];
        final busmessseen =
            targ.data()!['${widget.basicstorename}messagesseen'];
        final sent = targ.data()!['sent'];
        final messages = targ.data()!['messages'];
        FirebaseFirestore.instance
            .collection('listing')
            .doc(widget.id.toString())
            .update({
          'post_owner_seen_by_business${widget.basicstorename}': repto,
          '${widget.basicstorename}messages': busmess + 1,
          'sent': sent + 1,
          'messages': messages + 1
        });

        final chatxdocs = await FirebaseFirestore.instance
            .collection('chat')
            .doc(widget.id.toString())
            .collection('chatx')
            .get();
        final chfox = await FirebaseFirestore.instance
            .collection('listing')
            .doc(widget.id.toString())
            .get();
        final chox = await FirebaseFirestore.instance
            .collection('business_details')
            .where('second_uid',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get();
        final cusid = chatxdocs.docs.first.data()['customerid'];
        final busid = chox.docs.last.data()['first_uid'];
        final store_name = chox.docs.last.data()['store_name'];
        final storeimage = chox.docs.last.data()['image_url'];
        final userimage = chfox.data()!['userimage'];
        final username = chfox.data()!['username'];
        final userid2 = chfox.data()!['userid2'];

        // if (fcmToken != null) {
        //   await FirebaseFirestore.instance
        //       .collection('business_details')
        //       .doc(busid)
        //       .collection('tokens')
        //       .doc(fcmToken)
        //       .set({
        //     'createdAt': Timestamp.now(),
        //     'platform': Platform.operatingSystem.toString(),
        //     'registrationTokens': fcmToken,
        //   });

        // }
        final lastdocid = chatxdocs.docs.length;
        final lastdocidnum = lastdocid;
        final newdocid = lastdocidnum + 1;
        await FirebaseFirestore.instance
            .collection('chat')
            .doc(widget.id.toString())
            .collection('chatx')
            .doc(newdocid.toString())
            .set({
          'customerid': cusid,
          'businessid': busid,
          'listid': widget.id,
          'createdAt': Timestamp.now(),
          'to$cusid': true,
          'to$busid': false,
          'text': url,
          //  'target': cusid,
          'store_name': store_name,
          'basicstore_name': widget.basicstorename,
          'basicusername': widget.basicusername,
          'stroeimage': storeimage,
          'userimage': userimage,
          'username': username,
          'to': userid2,
          'combo': '${widget.basicusername}${widget.basicstorename}'
        });
        await FirebaseFirestore.instance
            .collection('chat')
            .doc(widget.id.toString())
            .collection('chatx')
            .doc(widget.cusidd + widget.busid)
            .collection('chatxx')
            .add({
          'customerid': cusid,
          'businessid': busid,
          'listid': widget.id,
          'createdAt': Timestamp.now(),
          'to$cusid': true,
          'to$busid': false,
          'text': url,
          //  'target': cusid,
          'store_name': store_name,
          'basicstore_name': widget.basicstorename,
          'basicusername': widget.basicusername,
          'stroeimage': storeimage,
          'userimage': userimage,
          'username': username,
          'to': userid2,
          'combo': '${widget.basicusername}${widget.basicstorename}'
        });
        await FirebaseFirestore.instance
            .collection('chat')
            .doc(widget.id.toString())
            .collection('chatx')
            .doc(widget.busid + widget.cusidd)
            .set({
          'lastsent': 'business',
          'createdAt': Timestamp.now(),
        });
        await FirebaseFirestore.instance.collection('notify').doc().set({
          'customerid': cusid,
          'businessid': busid,
          'listid': widget.id,
          'createdAt': Timestamp.now(),
          'to$cusid': true,
          'to$busid': false,
          'text': url,
          'target': widget.cusidd,
          'store_name': widget.storename
        });
        final send = await FirebaseFirestore.instance
            .collection('customer_details')
            .doc(cusid)
            .collection('tokens')
            .get();
        final tokenx = send.docs.first.data()['registrationTokens'];
        print(tokenx);
        print(",,,,,,,,<<<<>>>>>>>>>");

        sendpushnotification(tokenx, 'new photo', store_name);

        print('business');
      }
      if (widget.type == 'customer') {
        print('luck');
        final chatxx = await FirebaseFirestore.instance
            .collection('chat')
            .doc(widget.id.toString())
            .collection('chatx')
            .doc('${widget.basicusername}${widget.basicstorename}')
            .get();
        chatxx.exists
            ? await FirebaseFirestore.instance
                .collection('chat')
                .doc(widget.id.toString())
                .collection('chatx')
                .doc('${widget.basicusername}${widget.basicstorename}')
                .update({'combo': 'xxx'})
            : null;
        FirebaseMessaging messaging = FirebaseMessaging.instance;

        NotificationSettings settings = await messaging.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
        FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);

        await FirebaseMessaging.instance
            .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: false,
          sound: true,
        );
        print('User granted permission: ${settings.authorizationStatus}');
        String? fcmToken = await fbm.getToken();
        _controller.clear();

        final listdoc = await FirebaseFirestore.instance
            .collection('listing')
            .doc(widget.id.toString())
            .get();
        final store_nameprice =
            listdoc.data()!['${widget.basicstorename}price'];
        final store_messagesIndicator = listdoc.data()![widget.basicstorename];
        final store_messages =
            listdoc.data()!['${widget.basicstorename}messages'];
        final store_messagesseen =
            listdoc.data()!['${widget.basicstorename}messagesseen'];
        final cusid = listdoc.data()!['userid'];
        final storeimage = listdoc.data()!['${widget.basicstorename}image'];
        final userimage = listdoc.data()!['userimage'];
        final messbaqy = store_messages - store_messagesseen;
        final messages = listdoc.data()!['messages'];
        final messages_seen = listdoc.data()!['messages_seen'];
        final sent = listdoc.data()!['sent'];
        final seen = listdoc.data()!['seen'];

        final sentminseen = sent - seen;
        await FirebaseFirestore.instance
            .collection('listing')
            .doc(widget.id.toString())
            .update({
          'seen': sentminseen == 0 ? seen : seen + messbaqy,
          'messages_seen': messages_seen + messbaqy,
          '${widget.basicstorename}messagesseen': store_messages,
          'createdAt': Timestamp.now(),
        });
        if (store_messagesIndicator == 'off') {
          await FirebaseFirestore.instance
              .collection('listing')
              .doc(widget.id.toString())
              .update({
            widget.storename: 'on',
            'post_owner_reply_to_business${widget.basicstorename}': 1,
            'post_owner_seen_by_business${widget.basicstorename}': 0,
            'createdAt': Timestamp.now(),
          });
          await FirebaseFirestore.instance
              .collection('chat')
              .doc(widget.id.toString())
              .set({
            'customerid': cusid,
            widget.basicstorename: widget.storename,
            'listid': widget.id,
            'last shop link': Timestamp.now(),
          });
          await FirebaseFirestore.instance
              .collection('chat')
              .doc(widget.id.toString())
              .collection('chatx')
              .doc('1')
              .set({
            'customerid': cusid,
            'businessid': widget.busid,
            'listid': widget.id,
            'createdAt': Timestamp.now(),
            'to$cusid': false,
            'to${widget.busid}': true,
            'text': url,
            'to': widget.busid2,
            'store_name': widget.storename,
            'basicstore_name': widget.basicstorename,
            'basicusername': widget.basicusername,
            'stroeimage': storeimage,
            'userimage': userimage,
            'username': widget.username,
            'combo': '${widget.basicusername}${widget.basicstorename}'
          });
        }
        if (store_messagesIndicator == 'on') {
          final owner = await FirebaseFirestore.instance
              .collection('listing')
              .doc(widget.id.toString())
              .get();
          final owrep = owner
              .data()!['post_owner_reply_to_business${widget.basicstorename}'];
          final owseen = owner
              .data()!['post_owner_seen_by_business${widget.basicstorename}'];
          await FirebaseFirestore.instance
              .collection('listing')
              .doc(widget.id.toString())
              .update({
            'post_owner_reply_to_business${widget.basicstorename}': owrep + 1,
            //     'post_owner_seen': 0,
          });
          final chatxdocs = await FirebaseFirestore.instance
              .collection('chat')
              .doc(widget.id.toString())
              .collection('chatx')
              .get();
          final lastdocid = chatxdocs.docs.length;
          final lastdocidnum = lastdocid;
          final newdocid = lastdocidnum + 1;
          await FirebaseFirestore.instance
              .collection('chat')
              .doc(widget.id.toString())
              .collection('chatx')
              .doc(newdocid.toString())
              .set({
            'customerid': cusid,
            'businessid': widget.busid,
            'listid': widget.id,
            'createdAt': Timestamp.now(),
            'to$cusid': false,
            'to${widget.busid}': true,
            'text': url,
// 'businessid2':busid2,
// 'customerid2':userx,
            'to': widget.busid2,
            //  'target': cusid,
            'store_name': widget.storename,
            'basicstore_name': widget.basicstorename,
            'basicusername': widget.basicusername,
            'stroeimage': storeimage,
            'userimage': userimage,
            'username': widget.username,
            'combo': '${widget.basicusername}${widget.basicstorename}'
          });
          await FirebaseFirestore.instance
              .collection('chat')
              .doc(widget.id.toString())
              .collection('chatx')
              .doc(widget.cusidd + widget.busid)
              .collection('chatxx')
              .add({
            'customerid': cusid,
            'businessid': widget.busid,
            'listid': widget.id,
            'createdAt': Timestamp.now(),
            'to$cusid': false,
            'to${widget.busid}': true,
            'text': url,
// 'businessid2':busid2,
// 'customerid2':userx,
            'to': widget.busid2,
            //  'target': cusid,
            'store_name': widget.storename,
            'basicstore_name': widget.basicstorename,
            'basicusername': widget.basicusername,
            'stroeimage': storeimage,
            'userimage': userimage,
            'username': widget.username,
            'combo': '${widget.basicusername}${widget.basicstorename}'
          });
        }
        await FirebaseFirestore.instance
            .collection('chat')
            .doc(widget.id.toString())
            .collection('chatx')
            .doc(widget.busid + widget.cusidd)
            .set({
          'lastsent': 'customer',
          'createdAt': Timestamp.now(),
        });

        await FirebaseFirestore.instance.collection('notify').doc().set({
          'customerid': cusid,
          'businessid': {widget.busid},
          'listid': widget.id,
          'createdAt': Timestamp.now(),
          'to$cusid': false,
          'to${widget.busid}': true,
          'text': url,
          'target': widget.busid,
          'store_name': widget.username
        });
        final send = await FirebaseFirestore.instance
            .collection('customer_details')
            .doc(widget.busid)
            .collection('tokens')
            .get();
        final tokenx = send.docs.first.data()['registrationTokens'];
        print(tokenx);
        print(",,,,,,,,<<<<>>>>>>>>>");

        sendpushnotification(tokenx, _enteredMessage, widget.username);
        final business = await FirebaseFirestore.instance
            .collection('business_details')
            .doc(widget.busid.toString())
            .get();
        final foundsent = business.data()!['foundsent'];
        FirebaseFirestore.instance
            .collection('business_details')
            .doc(widget.busid.toString())
            .update({'foundsent': foundsent + 1});
        print('customer');
      }
      if (widget.type == 'business') {
        final cow = await FirebaseFirestore.instance
            .collection('chat')
            .doc(widget.id.toString())
            .collection('chatx')
            .doc('${widget.basicusername}busloading${widget.basicstorename}')
            .get();
        cow.exists
            ? FirebaseFirestore.instance
                .collection('chat')
                .doc(widget.id.toString())
                .collection('chatx')
                .doc(
                    '${widget.basicusername}busloading${widget.basicstorename}')
                .update({'combo': 'xxxx'})
            : null;
      }
      if (widget.type == 'customer') {
        final cow = await FirebaseFirestore.instance
            .collection('chat')
            .doc(widget.id.toString())
            .collection('chatx')
            .doc('${widget.basicusername}loading${widget.basicstorename}')
            .get();
        cow.exists
            ? FirebaseFirestore.instance
                .collection('chat')
                .doc(widget.id.toString())
                .collection('chatx')
                .doc('${widget.basicusername}loading${widget.basicstorename}')
                .update({'combo': 'xxxx'})
            : null;
      }
    }

    void blockstate() async {
      final busbkcus = await FirebaseFirestore.instance
          .collection('block')
          .doc(widget.busid + widget.cusidd)
          .get();
      final cusbkbus = await FirebaseFirestore.instance
          .collection('block')
          .doc(widget.cusidd + widget.busid)
          .get();
      if (busbkcus.exists && widget.type == 'business') {
        setState(() {
          blovsunblo = 'unblock';
        });
      } else if (!busbkcus.exists && widget.type == 'business') {
        setState(() {
          blovsunblo = 'block';
        });
      }
      if (cusbkbus.exists && widget.type == 'customer') {
        setState(() {
          blovsunblo = 'unblock';
        });
      } else if (!cusbkbus.exists && widget.type == 'customer') {
        setState(() {
          blovsunblo = 'block';
        });
      }
      if (cusbkbus.exists || busbkcus.exists) {
        setState(() {
          block = 'chain';
        });
      } else if (!cusbkbus.exists && !busbkcus.exists) {
        setState(() {
          block = 'unchain';
        });
      }
    }

    void _sendMessageblock() async {
      widget.type == 'business'
          ? FirebaseFirestore.instance
              .collection('block')
              .doc(widget.busid + widget.cusidd)
              .set({
              'customerid': widget.cusidd,
              'businessid': widget.busid,
              'listid': widget.id,
              'createdAt': Timestamp.now(),
              'blockprocess': 'business blocked customer',
              'basicstore_name': widget.basicstorename,
              'basicusername': widget.basicusername,
            })
          : FirebaseFirestore.instance
              .collection('block')
              .doc(widget.cusidd + widget.busid)
              .set({
              'customerid': widget.cusidd,
              'businessid': widget.busid,
              'listid': widget.id,
              'createdAt': Timestamp.now(),
              'blockprocess': 'customer blocked business',
              'basicstore_name': widget.basicstorename,
              'basicusername': widget.basicusername,
            });
    }

    void _unblock() async {
      final busbkcus = await FirebaseFirestore.instance
          .collection('block')
          .doc(widget.busid + widget.cusidd)
          .get();
      final cusbkbus = await FirebaseFirestore.instance
          .collection('block')
          .doc(widget.cusidd + widget.busid)
          .get();
      // final busbkcusx = await FirebaseFirestore.instance
      //     .collection('block')
      //     .doc('${widget.busid}${widget.cusidd}x')
      //     .get();
      // final cusbkbusx = await FirebaseFirestore.instance
      //     .collection('block')
      //     .doc('${widget.cusidd}${widget.busid}x')
      //     .get();
      if (busbkcus.exists && widget.type == 'business') {
        FirebaseFirestore.instance
            .collection('block')
            .doc(widget.busid + widget.cusidd)
            .delete();
      }
      if (cusbkbus.exists && widget.type == 'customer') {
        FirebaseFirestore.instance
            .collection('block')
            .doc(widget.cusidd + widget.busid)
            .delete();
      }
    }

    void _report() async {
      final lisdoc = await FirebaseFirestore.instance
          .collection('customer_details')
          .where('second_uid',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      final reporter = widget.type != 'customer'
          ? lisdoc.docs.last.id
          : (widget.cusidd + widget.busid);
      final repdoc = await FirebaseFirestore.instance
          .collection('chat_report')
          .doc(widget.id.toString())
          .collection('reporters')
          .doc(reporter)
          .get();
      repdoc.exists
          ? setState(() {
              repan = 'deactivated';
            })
          : setState(() {
              repan = 'active';
            });
    }

    return Container(
        height: 280,
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(8),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      maxLines: null,
                      controller: _controller,
                      //     focusNode: _controllernode,
                      textCapitalization: TextCapitalization.sentences,
                      readOnly: block == 'chain' || blovsunblo == 'unblock'
                          ? true
                          : false,
                      autocorrect: true,
                      enableSuggestions: true,
                      decoration: InputDecoration(
                          labelText: block == 'unchain' && blovsunblo == 'block'
                              ? 'Send a message...'
                              : blovsunblo == 'unblock'
                                  ? 'you blocked this person,unlock to be able to chat with ...'
                                  : 'sorry you are blocked by this person'),
                      onChanged: (value) {
                        setState(() {
                          _enteredMessage = value;
                        });
                      },
                      onSubmitted: (value) {
                        setState(() {
                          _enteredMessage = value;
                        });
                        _enteredMessage.trim().isEmpty ||
                                _enteredMessage.trim() == '' ||
                                _controller.text.trim() == ''
                            ? null
                            : widget.type == 'business'
                                ? _sendMessage()
                                : _sendMessagecustomer();
                      },
                    ),
                  ),
                  block == 'chain' || blovsunblo == 'unblock'
                      ? const SizedBox()
                      : Barpictrans(
                          _submitAuthForm,
                        ),
                  IconButton(
                      color: Theme.of(context).primaryColor,
                      icon: const Icon(
                        Icons.send,
                      ),
                      onPressed: () {
                        print('newxxxxxxxxx;');

                        _enteredMessage.trim().isEmpty ||
                                _enteredMessage.trim() == '' ||
                                _controller.text.trim() == ''
                            ? null
                            : widget.type == 'business'
                                ? _sendMessage()
                                : _sendMessagecustomer();
                        FocusManager.instance.primaryFocus?.unfocus();
                        // setState(() {
                        //   _controller.clear();
                        //   _enteredMessage = '';
                        // });
                      }),
                ],
              ),
              const Divider(),
              Center(
                  // child: CircleAvatar(
                  //     backgroundColor: Colors.cyan,
                  //     child: Center(
//  Card(
//                       elevation: 20,
//                       //     margin: const EdgeInsets.all(2),
//                       //   clipBehavior: Clip.antiAliasWithSaveLayer,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(4)),
//                       color: Colors.cyan.shade100,
                  child: DropdownButton(
                alignment: Alignment.topCenter,
                elevation: 50,
                underline: Container(),
                icon: const Icon(
                  Icons.settings,
                  color: Colors.black,
                ),
                items: [
                  DropdownMenuItem(
                    value: 'block',
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          blovsunblo == 'block'
                              ? const Icon(
                                  Icons.block,
                                  color: Colors.red,
                                )
                              : const Icon(
                                  Icons.block_outlined,
                                  color: Colors.greenAccent,
                                ),
                          const SizedBox(width: 8),
                          Text(blovsunblo),
                        ],
                      ),
                    ),
                  ),
                  // DropdownMenuItem(
                  //   value: 'unblock',
                  //   child: Container(
                  //     child: Row(
                  //       children: const <Widget>[
                  //         Icon(Icons.run_circle),
                  //         SizedBox(width: 8),
                  //         Text('unblock'),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  DropdownMenuItem(
                    value: 'report',
                    child: Container(
                      child: Row(
                        children: const <Widget>[
                          Icon(Icons.flag),
                          SizedBox(width: 8),
                          Text('report'),
                        ],
                      ),
                    ),
                  ),
                ],
                onChanged: (itemIdentifier) {
                  if (itemIdentifier == 'block') {
                    blovsunblo == 'block' ? _sendMessageblock() : _unblock();
                  }
                  if (itemIdentifier == 'unblock') {
                    blovsunblo == 'block' ? _sendMessageblock() : _unblock();
                    //  _unblock();
                  }
                  if (itemIdentifier == 'report') {
                    repan == 'deactivated'
                        ? null
                        : showDialog(
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
                                          if (reportcontroller.value.text ==
                                              '') {
                                            null;
                                          } else {
                                            // Future.delayed(const Duration(seconds: 2),
                                            //     (() {
                                            Navigator.of(ctx).pop(false);
                                            //  }));
                                            showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                title:
                                                    const Text('reprt sent!'),
                                                content: const Text(
                                                  'admins will justify it',
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('ok'),
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
                                                await FirebaseFirestore.instance
                                                    .collection(
                                                        'customer_details')
                                                    .where('second_uid',
                                                        isEqualTo: FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                    .get();
                                            final reporter =
                                                widget.type != 'customer'
                                                    ? lisdoc.docs.last.id
                                                    : (widget.cusidd +
                                                        widget.busid);
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
                                              'reported':
                                                  widget.type == 'customer'
                                                      ? widget.busid
                                                      : widget.cusidd,
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
              )),
              AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    '',
                    textStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.cyanAccent,
                      overflow: TextOverflow.visible,
                    ),
                    speed: const Duration(seconds: 3),
                  )
                ],
                // totalRepeatCount: 2,
                repeatForever: true,
                onNext: (p0, p1) {
                  _controller.value.text != '' ? _typing() : _typingdelete();
                  _seen();
                  blockstate();
                  _report();
                },
              ),
            ]));
  }
}
 //   https://firebasestorage.googleapis.com/v0/b/flutter-chat-6ca2c.appspot.com/