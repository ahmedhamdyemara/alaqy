import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_alaqy/authFormBusiness.dart';
import 'package:intl/intl_standalone.dart';

import 'AuthFormUser.dart';
// import 'http_exception.dart';

// import 'auth_form.dart';
// import 'fuck.dart';
// import 'package:provider/provider.dart';
// import 'auth.dart';
// import 'chat_screen.dart';

class AuthScreenBusiness extends StatefulWidget {
  static const routeName = '/AuthScreenBusiness';
  String phone;
  String user_id;
  bool sup;

  AuthScreenBusiness(this.phone, this.user_id, this.sup, {super.key});
  @override
  AuthScreenBusinessState createState() => AuthScreenBusinessState();
}

class AuthScreenBusinessState extends State<AuthScreenBusiness> {
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
    // String storename,
    String category,
    String city,
    String password,
    String username,
    File? image,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authResult;
    // AuthResult authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      if (widget.sup == false) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (widget.sup == true) {
          final ref = FirebaseStorage.instance
              .ref()
              .child('user_image')
              .child('${authResult.user?.uid}.jpg');
          await ref.putFile(image!).whenComplete(() => image);

          final url = await ref.getDownloadURL();
          //     final oppa = Provider.of<Auth>(context, listen: false).userId;

          //   await Firestore.instance
          //       .collection('chato')
          //      .document(oppa)
          //     .setData({'pokeuser': 'x'});
          await FirebaseFirestore.instance
              .collection('business_details')
              .doc(widget.user_id)
              .set({
            'first_uid': widget.user_id,
            'second_uid': authResult.user?.uid,
            'phone_num': widget.phone,
            'createdAt': Timestamp.now(),
            //  'username': username,
            'username': email,
            'city': city,
            'store_name': username,
            'category': category,
            'image_url': url,
            //'iam': 'null',
            'messages': 0,
            'seen': 0,
            'sent': 0,
            'orders': 0,
            //  'map': 0,
            'state': 'online',
            //  'news': 'New',
            //       'nationality': '',
//'city': '',
//'street': '',
          });
          await FirebaseFirestore.instance
              .collection('customer_details')
              .doc(widget.user_id)
              .set({
            'first_uid': widget.user_id,
            'second_uid': authResult.user?.uid,
            'phone_num': widget.phone,
            'createdAt': Timestamp.now(),
            //  'username': username,
            'username': email,
            //   'city': city,
            //  'store_name': storename,
            //   'category': category,
            //    'image_url': url,
            // 'iam': 'null',
            'messages': 0,
            'seen': 0,
            'sent': 0,
            //  'orders': 0,
            //   'map': 0,
            'state': 'online',
            //  'news': 'New',
            'activated': false,
            //       'nationality': '',
//'city': '',
//'street': '',
          });
        }

        final qwe = authResult.user?.uid;
        await FirebaseMessaging.instance
            .subscribeToTopic('business_details/$qwe');
      }

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
    } on HttpException catch (err) {
      var errMessage = 'Authentication failed';
      if (err.toString().contains('EMAIL_EXISTS')) {
        errMessage = 'This email address is already in use.';
      } else if (err.toString().contains('INVALID_EMAIL')) {
        errMessage = 'This is not a valid email address';
      } else if (err.toString().contains('WEAK_PASSWORD')) {
        errMessage = 'This password is too weak.';
      } else if (err.toString().contains('EMAIL_NOT_FOUND')) {
        errMessage = 'Could not find a user with that email.';
      } else if (err.toString().contains('INVALID_PASSWORD')) {
        errMessage = 'Invalid password.';
        //    } else {
        //      errMessage = 'Could not authenticate you. Please try again later.';
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
        backgroundColor: Theme.of(context).primaryColor,
        body: Container(
            child: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(
            height: 20,
          ),
          widget.user_id == 'result.user!.uid'
              ? AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText('This number already have an account',
                        colors: [
                          Colors.tealAccent,
                          Colors.lightGreen,
                          Colors.cyanAccent,
                        ],
                        textStyle: const TextStyle(
                          fontSize: 30,
                        ),
                        textAlign: TextAlign.center,
                        speed: const Duration(milliseconds: 100)),
                  ],
                  repeatForever: true,
                )
              : const SizedBox(
                  height: 20,
                ),
          widget.user_id == 'result.user!.uid'
              ? const Divider()
              : const SizedBox(
                  height: 30,
                ),
          AuthFormBusiness(_submitAuthForm, _isLoading, widget.sup),
        ]))));
  }
}
