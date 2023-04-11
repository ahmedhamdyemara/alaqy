import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alaqy/userChoose.dart';
import 'package:provider/provider.dart';
//import 'auth.dart';
import 'package:intl/intl_standalone.dart';

import 'numberPhone.dart';

// import 'fucks.dart';
// import 'user_image_picker.dart';

class AuthFormUser extends StatefulWidget {
  const AuthFormUser(
    this.submitFn,
    this.isLoading,
    this.supx,
  );
  final bool supx;

  final bool isLoading;
  final void Function(
    String email,
    String password,
    //  String userName,
    //  File? image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  AuthFormUserState createState() => AuthFormUserState();
}

class AuthFormUserState extends State<AuthFormUser> {
  bool? loading;

  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  var _userImageFile;

  void _pickedImage(File? image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    // if (_userImageFile == null && _isLogin) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: const Text('Please pick an image.'),
    //       backgroundColor: Theme.of(context).errorColor,
    //     ),
    //   );
    //   return;
    // }
    if (isValid == true) {
      _formKey.currentState?.save();
      widget.submitFn(
        '${_userEmail.trim()}@gmail.com',
        _userPassword.trim(),
        //   _userName.trim(),
        //   _userImageFile,
        _isLogin,
        context,
      );

      FirebaseAuth.instance.userChanges().listen((User? user) {
        if (user == null) {
          print('User is currently signed out!');
        } else {
          Navigator.of(context).pushReplacementNamed(userChoose.routeName);
          print('User is signed in!');
          // final cool = user.photoURL;
          //   final zool =
          //     FirebaseFirestore.instance.collection('users').doc('$user').get;
          //  final mool = zool.toString().
          // final sool = mool.asyncMap(
          //   (event) {
          //     ['userImage'];
          //   },
          // );
          print('$user');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //  final oppa = Provider.of<Auth>(context, listen: false).userId;

    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // if (_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    key: const ValueKey('email'),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    validator: (value) {
                      if (value != null) {
                        return (value.isEmpty)
                            ? 'Please enter a valid user name.'
                            : null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'user name',
                    ),
                    onSaved: (value) {
                      if (value != null) {
                        _userEmail = value;
                      }
                    },
                  ),
                  ////////////////////////////////// if (widget.supx)
                  //   TextFormField(
                  //     key: const ValueKey('username'),
                  //     autocorrect: true,
                  //     textCapitalization: TextCapitalization.words,
                  //     enableSuggestions: false,
                  //     validator: (value) {

                  //       if (value != null) {
                  //         return (value.isEmpty || value.length < 4)
                  //             ? 'Please enter at least 4 characters'
                  //             : null;
                  //       }
                  //     },
                  //     decoration: const InputDecoration(labelText: 'Username'),
                  //     onSaved: (value) {
                  //       if (value != null) {
                  //         _userName = value;
                  //       }
                  //     },
                  //   ),
                  TextFormField(
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value != null) {
                        //                if (value!.isEmpty || value.length < 5) {
                        //                    return 'Password must be at least 5 characters long.';
                        //                  }
                        //                  return '';
                        //              },

                        return (value.isEmpty || value.length < 5)
                            ? 'Password must be at least 5 characters long.'
                            : null;
                      }
                      //         return null;
                    },
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onSaved: (value) {
                      if (value != null) {
                        _userPassword = value;
                      }
                    },
                  ),

                  const SizedBox(height: 12),
                  //     if (widget.isLoading) const CircularProgressIndicator(),
                  //   if (!widget.isLoading)
                  (widget.isLoading)
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _trySubmit,
                          child: const Text('submit'),
                        ),
                  // if (oppa == 'iTODDDtLDWcUxCLzdOez2WZSGju2' ||
                  //     oppa == 'bG7FfM4zbRPaoHaDU0S8dUQjwbv2' ||
                  //     oppa == 'exztUlWOTeaTVZS7lLVCpG406UV2' ||
                  //     oppa == 'H2BtXKJC0TTtVtjon9VnfYvu47L2' ||
                  //     oppa == 'F8kf0a9zeNNtb7pl1cn9k4FkzJp1' ||
                  //     oppa == '3QHQEtFNJAZOP5h3ZbW1UKmK2t33' ||
                  //     oppa == 'T3cesGtnn1O6rlB5VuyxgDAuGFx2')
                  //   if (!widget.isLoading)
                  //     (oppa == 'iTODDDtLDWcUxCLzdOez2WZSGju2' ||
                  //             oppa == 'bG7FfM4zbRPaoHaDU0S8dUQjwbv2' ||
                  //             oppa == 'exztUlWOTeaTVZS7lLVCpG406UV2' ||
                  //             oppa == 'H2BtXKJC0TTtVtjon9VnfYvu47L2' ||
                  //             oppa == 'F8kf0a9zeNNtb7pl1cn9k4FkzJp1' ||
                  //             oppa == '3QHQEtFNJAZOP5h3ZbW1UKmK2t33' ||
                  //             oppa == 'T3cesGtnn1O6rlB5VuyxgDAuGFx2')
                  //         ?
                  (!widget.isLoading)
                      ? TextButton(
                          //            textColor: Theme.of(context).primaryColor, LoginScreen('customer')
                          child: const Text('i need to register'),
                          onPressed: () {
                            print('check');
                            MaterialPageRoute(
                                builder: (context) => LoginScreen('customer'));
                          },
                        )
                      : const CircularProgressIndicator()
                  //  : const Divider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
