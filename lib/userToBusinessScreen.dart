import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_alaqy/authFormBusiness.dart';
import 'package:flutter_alaqy/userToBusinessForm.dart';
import 'package:intl/intl_standalone.dart';

import 'AuthFormUser.dart';
// import 'http_exception.dart';

// import 'auth_form.dart';
// import 'fuck.dart';
// import 'package:provider/provider.dart';
// import 'auth.dart';
// import 'chat_screen.dart';

class UserToBusinessScreen extends StatefulWidget {
  static const routeName = '/UserToBusinessScreen';
  String phone;
  String user_id;
  String user_id2;
  String username;

  UserToBusinessScreen(this.phone, this.user_id, this.user_id2, this.username,
      {super.key});
  @override
  UserToBusinessScreenState createState() => UserToBusinessScreenState();
}

class UserToBusinessScreenState extends State<UserToBusinessScreen> {
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
    String storename,
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
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child('${widget.user_id2}.jpg');
      await ref.putFile(image!).whenComplete(() => image);

      final url = await ref.getDownloadURL();
      // if (!isLogin) {
      //   authResult = await _auth.signInWithEmailAndPassword(
      //     email: email,
      //     password: password,
      //   );
      // } else {
      //   authResult = await _auth.createUserWithEmailAndPassword(
      //     email: email,
      //     password: password,
      //   );
      //   if (isLogin) {

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
        'second_uid': widget.user_id2,
        'phone_num': widget.phone,
        'createdAt': Timestamp.now(),
        'username': widget.username,
        //   'email': email,
        'city': city,
        'store_name': username,
        'category': category,
        'image_url': url,
        //  'iam': 'null',
        'messages': 0,
        'seen': 0,
        // 'sent': 0,
        // 'orders': 0,
        //  'map': 0,
        'state': 'online',
        //  'news': 'New',
        //       'nationality': '',
//'city': '',
//'street': '',
      });

      final qwe = widget.user_id2;
      await FirebaseMessaging.instance
          .subscribeToTopic('business_details/$qwe');

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
          AnimatedTextKit(
            animatedTexts: [
              ColorizeAnimatedText('fill this form',
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
          ),
          const Divider(),
          UserToBusinessForm(
            _submitAuthForm,
            _isLoading,
          ),
          _isLoading ? const CircularProgressIndicator() : const SizedBox()
        ]))));
  }
}
