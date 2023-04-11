import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alaqy/businessChoose.dart';
import 'package:flutter_alaqy/userChoose.dart';
import 'package:provider/provider.dart';
//import 'auth.dart';
import 'package:intl/intl_standalone.dart';

import 'ImagePicker.dart';

// import 'fucks.dart';
// import 'user_image_picker.dart';

class UserToBusinessForm extends StatefulWidget {
  const UserToBusinessForm(
    this.submitFn,
    this.isLoading,
  );

  final bool isLoading;
  final void Function(
    String email,
    String storename,
    String category,
    String city,
    String password,
    String userName,
    File? image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  UserToBusinessFormState createState() => UserToBusinessFormState();
}

class UserToBusinessFormState extends State<UserToBusinessForm> {
  bool loading = false;

  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _storename = '';
  var _category = 'اجهزة المطبخ';
  var _userName = '';
  var _city = 'alexandria';
  var _userPassword = '';
  var _userImageFile;

  void _pickedImage(File? image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    setState(() {
      loading = true;
    });
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && _isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please pick an image.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    if (_city == '' && _isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please choose a city.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    if (_category == '' && _isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please choose a category.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    if (isValid == true) {
      _formKey.currentState?.save();
      widget.submitFn(
        _userEmail.trim(),
        _storename.trim(),
        _category.trim(),
        _city.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _userImageFile,
        _isLogin,
        context,
      );

      FirebaseAuth.instance.userChanges().listen((User? user) {
        if (user == null) {
          print('User is currently signed out!');
        } else {
          Navigator.of(context).pushReplacementNamed(businessChoose.routeName);
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
    setState(() {
      loading = false;
    });
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
                  //      if (_isLogin)
                  UserImagePicker(_pickedImage),
                  // if (_isLogin)
                  //   StreamBuilder(
                  //       stream: FirebaseFirestore.instance
                  //           .collection('business_details')
                  //           .snapshots(),
                  //       builder: (ctx, chatSnapshot) {
                  //         if (chatSnapshot.connectionState ==
                  //             ConnectionState.waiting) {
                  //           return chatSnapshot.hasData
                  //               ? const Center(
                  //                   child: CircularProgressIndicator(),
                  //                 )
                  //               : const Center(
                  //                   child: Text('authentication'),
                  //                 );
                  //         }
                  //         final chatDocs = chatSnapshot.data!.docs;
                  //         final List<String> items = [];
                  //         for (var i = 0; i < chatDocs.length; i++) {
                  //           if (chatDocs.isNotEmpty) {
                  //             items.add(chatDocs[i]['store_name']);
                  //           }
                  //         }
                  //         return TextFormField(
                  //           key: const ValueKey('store name'),
                  //           autocorrect: false,
                  //           textCapitalization: TextCapitalization.none,
                  //           enableSuggestions: false,
                  //           validator: (value) {
                  //             if (value!.isEmpty) {
                  //               return 'Please provide a value.';
                  //             }
                  //             if (items.contains(value)) {
                  //               return 'this store name is already exists';
                  //             }
                  //             //   return '';
                  //           },
                  //           keyboardType: TextInputType.name,
                  //           decoration: const InputDecoration(
                  //             labelText: 'store name',
                  //           ),
                  //           onSaved: (value) {
                  //             if (value != null) {
                  //               _storename = value;
                  //             }
                  //           },
                  //         );
                  //       }),
                  // TextFormField(
                  //   key: const ValueKey('email'),
                  //   autocorrect: false,
                  //   textCapitalization: TextCapitalization.none,
                  //   enableSuggestions: false,
                  //   validator: (value) {
                  //     //           if (value!.isEmpty || !value.contains('@')) {
                  //     //           return 'Please enter a valid email address.';
                  //     //       }
                  //     //     return null;
                  //     //      },
                  //     if (value != null) {
                  //       return (value.isEmpty || !value.contains('@'))
                  //           ? 'Please enter a valid email address.'
                  //           : null;
                  //     }
                  //     //     return null;
                  //   },
                  //   keyboardType: TextInputType.emailAddress,
                  //   decoration: const InputDecoration(
                  //     labelText: 'Email address',
                  //   ),
                  //   onSaved: (value) {
                  //     if (value != null) {
                  //       _userEmail = value;
                  //     }
                  //   },
                  // ),
                  // if (_isLogin)
                  TextFormField(
                    key: const ValueKey('username'),
                    autocorrect: true,
                    //      textCapitalization: TextCapitalization.words,
                    enableSuggestions: false,
                    validator: (value) {
                      //                if (value!.isEmpty || value.length < 4) {
                      //                return 'Please enter at least 4 characters';
                      //                 }
                      //                  return '';
                      //               },
                      if (value != null) {
                        return (value.isEmpty || value.length < 4)
                            ? 'Please enter at least 4 characters'
                            : null;
                      }
                      //        return null;
                    },
                    decoration: const InputDecoration(labelText: 'store name'),
                    onSaved: (value) {
                      if (value != null) {
                        _userName = value;
                      }
                    },
                  ),
                  // TextFormField(
                  //   key: const ValueKey('password'),
                  //   validator: (value) {
                  //     if (value != null) {
                  //       //                if (value!.isEmpty || value.length < 5) {
                  //       //                    return 'Password must be at least 5 characters long.';
                  //       //                  }
                  //       //                  return '';
                  //       //              },

                  //       return (value.isEmpty || value.length < 5)
                  //           ? 'Password must be at least 5 characters long.'
                  //           : null;
                  //     }
                  //     //         return null;
                  //   },
                  //   decoration: const InputDecoration(labelText: 'Password'),
                  //   obscureText: true,
                  //   onSaved: (value) {
                  //     if (value != null) {
                  //       _userPassword = value;
                  //     }
                  //   },
                  // ),
                  //   if (_isLogin)
                  DropdownButton(
                    underline: Container(),
                    icon: const Icon(
                      Icons.category,
                      color: Colors.grey,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'اجهزة المطبخ',
                        // onTap: () {
                        //   _sendMessageblock();
                        //   blacklist();
                        // },
                        child: Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: const <Widget>[
                              Icon(Icons.category_outlined),
                              SizedBox(width: 8),
                              Text('اجهزة المطبخ'),
                            ],
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == 'اجهزة المطبخ') {
                        // setState(() {
                        _category = "اجهزة المطبخ";
                        // });
                      }

                      // if (value == 'report') {
                      //   _report();
                      // }
                    },
                  ),
                  //    if (_isLogin)
                  DropdownButton(
                    underline: Container(),
                    icon: const Icon(
                      Icons.location_city,
                      color: Colors.grey,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'alexandria',
                        // onTap: () {
                        //   _sendMessageblock();
                        //   blacklist();
                        // },
                        child: Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: const <Widget>[
                              Icon(Icons.location_city_outlined),
                              SizedBox(width: 8),
                              Text('alexandria'),
                            ],
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == 'alexandria') {
                        // setState(() {
                        _city = 'alexandria';
                        // });
                      }

                      // if (value == 'report') {
                      //   _report();
                      // }
                    },
                  ),
                  const SizedBox(height: 12),
                  //     if (widget.isLoading) const CircularProgressIndicator(),
                  //   if (!widget.isLoading)
                  (loading)
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            _trySubmit();
                            setState(() {
                              loading = true;
                            });
                          },
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
                  // ((!widget.isLoading) || (loading = false))
                  //     ? TextButton(
                  //         //            textColor: Theme.of(context).primaryColor,
                  //         child: Text(_isLogin
                  //             ? 'I already have an account'
                  //             : 'Creat new account'),
                  //         onPressed: () {
                  //           setState(() {
                  //             _isLogin = !_isLogin;
                  //           });
                  //         },
                  //       )
                  //     : const CircularProgressIndicator()
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
