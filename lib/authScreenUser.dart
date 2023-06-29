import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'AuthFormUser.dart';
// import 'http_exception.dart';

// import 'auth_form.dart';
// import 'fuck.dart';
// import 'package:provider/provider.dart';
// import 'auth.dart';
// import 'chat_screen.dart';

class AuthScreenUser extends StatefulWidget {
  static const routeName = '/AuthScreenUser';
  String phone;
  String user_id;
  bool sup;
  bool kokox;
  AuthScreenUser(this.phone, this.user_id, this.sup, this.kokox, {super.key});
  @override
  AuthScreenUserState createState() => AuthScreenUserState();
}

class AuthScreenUserState extends State<AuthScreenUser> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  final fbm = FirebaseMessaging;
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void _submitAuthForm(
    String email,
    String password,
    // String username,
    //  File? image,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authResult;
    // AuthResult authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      print(widget.kokox);
      print('widget.kokox');

      if (widget.sup == false && widget.kokox == false) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
      final forg = widget.kokox
          ? await FirebaseFirestore.instance
              .collection('customer_details')
              .where('phone_num', isEqualTo: widget.phone)
              .get()
          : await FirebaseFirestore.instance
              .collection('customer_details')
              .get();
      final forgottenid = forg.docs.first.id;
//  final forgbus = widget.kokox
//           ? await FirebaseFirestore.instance
//               .collection('business_details')
//               .where('phone_num', isEqualTo: widget.phone)
//               .get()
//           : await FirebaseFirestore.instance
//               .collection('business_details')
//               .get();
//       final forgottenbusid =   forgbus.docs.isNotEmpty ?  forgbus.docs.first.id : 'null';
      if (widget.sup == true && widget.kokox == false) {
        await FirebaseFirestore.instance
            .collection('customer_details')
            .doc(widget.user_id)
            .set({
          'first_uid': widget.user_id,
          'second_uid': authResult.user?.uid,
          'phone_num': widget.phone,
          'createdAt': Timestamp.now(),
          'username': email,
          'basicemail': email,
          'basicemailx': email,

          'businesslast': false,

          'name': (email.toString().split('@').first)
              .trim()
              .replaceAll(RegExp(r'_'), ' '),
          'image_url':
              'https://firebasestorage.googleapis.com/v0/b/alaqy-64208.appspot.com/o/user_image%2FHI7A9RLmLTVnUn4UxqjAM92Gcwc2.jpg?alt=media&token=a4b20826-9003-4538-b1a5-41b3b1245169',
//'https://firebasestorage.googleapis.com/v0/b/alaqy-64208.appspot.com/o/user_image%2F6hQptGBEZWNdiTgKVHhgRjVgl5c2.jpg?alt=media&token=6e63ca69-f053-46df-9040-458b47b49133'
          'messages': 0,
          'seen': 0,
          'sent': 0,
          // 'orders': 0,
          //  'map': 0,
          'state': 'online',
          'lastseen': Timestamp.now(), 'activated': true,
          'updated': false,

          //       'nationality': '',
//'city': '',
//'street': '',
        });
      } else if (widget.kokox) {
        print(widget.phone);
        print(authResult.user?.uid);
        print(email);
        print("خخخخخخخخخخخخخخخخخخخخخخخخخخ");
        // final forg = await FirebaseFirestore.instance
        //     .collection('customer_details')
        //     .where({'phone_num': widget.phone}).get();
        // final forgottenid = forg.docs.first.id;
        //   print(forgottenid);

        FirebaseFirestore.instance
            .collection('customer_details')
            .doc(forgottenid)
            .update({
          'businesslast': false,
          'state': 'online',
          'lastseen': Timestamp.now(),
          'basicemailx': email,
          'second_uid': authResult.user?.uid,
        });
        // forgottenbusid == 'null'?  print("no business"):
        final forgbus = await FirebaseFirestore.instance
            .collection('business_details')
            .doc(forgottenid)
            .get();
        forgbus.exists
            ? FirebaseFirestore.instance
                .collection('business_details')
                .doc(forgottenid)
                .update({
                'basicemailx': email,
                'second_uid': authResult.user?.uid,
              })
            : print("no business");
        print("9999999999999999999999777777777777777777");
      }
      if (widget.sup == false) {
        if (widget.kokox == false) {
          FirebaseFirestore.instance
              .collection('customer_details')
              .doc(widget.user_id)
              .update({
            'businesslast': false,
            'state': 'online',
            'lastseen': Timestamp.now(),
          });
        } else {
          print(widget.phone);
          print(authResult.user?.uid);
          print(email);
          print("خخخخخخخخخخخخخخخخخخخخخخخخخخ");
          // final forg = await FirebaseFirestore.instance
          //     .collection('customer_details')
          //     .where({'phone_num': widget.phone}).get();
          // final forgottenid = forg.docs.first.id;
          //   print(forgottenid);

          FirebaseFirestore.instance
              .collection('customer_details')
              .doc(forgottenid)
              .update({
            'businesslast': false,
            'state': 'online',
            'lastseen': Timestamp.now(),
            'basicemailx': email,
            'second_uid': authResult.user?.uid,
          });
          // forgottenbusid == 'null'?  print("no business"):
          final forgbus = await FirebaseFirestore.instance
              .collection('business_details')
              .doc(forgottenid)
              .get();
          forgbus.exists
              ? FirebaseFirestore.instance
                  .collection('business_details')
                  .doc(forgottenid)
                  .update({
                  'basicemailx': email,
                  'second_uid': authResult.user?.uid,
                })
              : print("no business");
          print("9999999999999999999999777777777777777777");
        }
      }

      // final qwe = authResult.user?.uid;
      // await FirebaseMessaging.instance
      //     .subscribeToTopic('customer_details/$qwe');

      void _showErrorDialogg(String message) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An Error Occurred!'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    } on HttpException catch (err) {
      var errMessage = 'Authentication failed';
      if (err.toString().contains('EMAIL_EXISTS')) {
        errMessage = 'This email address is already in use.';
      } else if (err.toString().contains('Badly_Formatted')) {
        errMessage = 'Please remove @ from the choosen name';
      } else if (err.toString().contains('INVALID_EMAIL')) {
        errMessage = 'This is not a valid email address';
      } else if (err.toString().contains('WEAK_PASSWORD')) {
        errMessage = 'This password is too weak.';
      } else if (err.toString().contains('EMAIL_NOT_FOUND')) {
        errMessage = 'Could not find a user with that email.';
      } else if (err.toString().contains('INVALID_PASSWORD')) {
        errMessage = 'Invalid password.';
      } else {
        errMessage = 'Could not authenticate you. Please try again later.';
      }
      //     if (err.toString().isEmpty) {
      //     null;
      //    } else {
      //       errMessage = err.message;
//      }

      //    ScaffoldMessenger.of(ctx).showSnackBar(
      //       SnackBar(
//          content: Text(errMessage),
      //         backgroundColor: Theme.of(ctx).errorColor,
      //      ),
      //    );
      // setState(() {
      //   _isLoading = false;
      //    });
      _showErrorDialog(errMessage);
    } catch (err) {
      if (err.toString().isEmpty) {
        null;
      } else {
        final errMessage = err.toString();
        _showErrorDialog(errMessage);

        print(err);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //  if (FirebaseAuth.instance.currentUser() != null) {
//      return Fuck();
    //  }

    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).primaryColor,
        // appBar: widget.user_id == 'result.user!.uidx'
        //     ? AppBar(
        //         title: const Text('alaqy auth'),
        //         actions: [
        //           IconButton(
        //               onPressed: () {
        //                 Navigator.of(context).pushReplacementNamed('/');
        //               },
        //               icon: const Icon(
        //                 Icons.swap_horizontal_circle_sharp,
        //                 size: 40,
        //               ))
        //       ],
        //      )
        //   : null,
        body: Container(
            child: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
          // const SizedBox(
          //   height: 20,
          // ),
          // widget.user_id == 'result.user!.uidx'
          //     ? AnimatedTextKit(
          //         animatedTexts: [
          //           ColorizeAnimatedText('',
          //               colors: [
          //                 Colors.tealAccent,
          //                 Colors.lightGreen,
          //                 Colors.cyanAccent,
          //               ],
          //               textStyle: const TextStyle(
          //                 fontSize: 23,
          //               ),
          //               textAlign: TextAlign.center,
          //               speed: const Duration(milliseconds: 100)),
          //         ],
          //         repeatForever: true,
          //       )
          //     : const SizedBox(
          //         height: 20,
          //       ),
          // widget.user_id == 'result.user!.uidx'
          //     ? const Divider()
          //     : const SizedBox(
          //         height: 30,
          //       ),

          AuthFormUser(_submitAuthForm, _isLoading, widget.sup, widget.phone,
              widget.kokox, widget.user_id),
        ]))));
  }
}
