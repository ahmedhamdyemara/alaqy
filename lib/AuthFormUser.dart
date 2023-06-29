import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alaqy/user_main.dart';
import 'package:flutter_sms/flutter_sms.dart';

import 'numberPhone.dart';
import 'user_mainx.dart';

// import 'fucks.dart';
// import 'user_image_picker.dart';

class AuthFormUser extends StatefulWidget {
  const AuthFormUser(this.submitFn, this.isLoading, this.supx, this.phone,
      this.koko, this.userx);

  final void Function(
    String email,
    String password,
    //  String userName,
    //  File? image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;
  final bool isLoading;
  final bool supx;
  final String phone;
  final bool koko;
  final String userx;
  @override
  AuthFormUserState createState() => AuthFormUserState();
}

class AuthFormUserState extends State<AuthFormUser> {
  bool? loading;
  bool knok = false;
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  var _userImageFile;

  void _pickedImage(File? image) {
    _userImageFile = image;
  }

  void _sendSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }
  // void sending_SMS(String msg, List<String> list_receipents) async {
  //   String send_result =
  //       await sendSMS(message: msg, recipients: list_receipents)
  //           .catchError((err) {
  //     print(err);
  //   });
  //   print(send_result);
  // }

  void _trySubmit() async {
    setState(() {
      loading = true;
    });
    final mobile = _phoneController.text.trim();
    final numberState = await FirebaseFirestore.instance
        .collection('customer_details')
        .where('phone_num', isEqualTo: mobile)
        .get();
    final numberStatez = await FirebaseFirestore.instance
        .collection('customer_details')
        .where('phone_num', isEqualTo: widget.phone)
        .get();
    final copa = knok == true || widget.koko == true
        ? numberStatez.docs.first
            .data()['basicemailx']
            .toString()
            .split('@')
            .first
        : (numberState.docs.first.data()['basicemail'])
            .toString()
            .split('@')
            .first;
    if (numberState.docs.isNotEmpty && widget.koko == false) {
      final flag = (numberState.docs.first.data()['activated']);
      final username = (numberState.docs.first.data()['basicemail']);

      if (flag == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('this number dont belong to any user account.'),
            backgroundColor: Theme.of(context).errorColor,
          ),
        );
        return;
      }
      final cops = knok == true || widget.koko == true
          ? numberStatez.docs.first
              .data()['basicemailx']
              .toString()
              .split('@')
              .first
          : (numberState.docs.first.data()['basicemail'])
              .toString()
              .split('@')
              .first;
      setState(() {
        _userEmail = cops;
      });
      print(_userEmail);
    }
    // if (widget.koko == false && widget.supx == false) {
    //   if ((widget.supx == false && numberState.docs.isEmpty)) {
    //     //||(numberStatez.docs.isNotEmpty && widget.koko == true)) {
    //     setState(() {
    //       loading = false;
    //     });
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: const Text('this number dont belong to any user account.'),
    //         backgroundColor: Theme.of(context).errorColor,
    //       ),
    //     );
    //     return;
    //   }
    // } else
    if (numberStatez.docs.isEmpty && widget.koko == true) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('this number dont belong to any user account.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
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
    final lol = knok == true || widget.koko == true
        ? '${copa}x@alaqy.com'
//'${numberStatez.docs.first.data()['name']}x@alaqy.com'
        : numberState.docs.isNotEmpty
            ? numberState.docs.first.data()['basicemailx']
            : '';

    if (isValid == true) {
      _formKey.currentState?.save();
      widget.supx && !widget.koko
          ? widget.submitFn(
              '${_userEmail.trim().replaceAll(RegExp(r' '), '_').replaceAll(RegExp(r'@'), '_')}@alaqy.com',
              _userPassword.trim(),
              //   _userName.trim(),
              //   _userImageFile,
              _isLogin,
              context,
            )
          : (numberState.docs.isNotEmpty || numberStatez.docs.isNotEmpty)
              ? widget.submitFn(
                  lol, // numberState.docs.first.data()['basicemail'],
                  _userPassword.trim(),
                  //   _userName.trim(),
                  //   _userImageFile,
                  _isLogin,
                  context,
                )
              : null;

      FirebaseAuth.instance.userChanges().listen((User? user) {
        if (user == null) {
          print('User is currently signed out!');
        } else {
          //   if (numberState.docs.isNotEmpty && widget.supx == false) {
          if (numberState.docs.isNotEmpty) {
            final uidq = (numberState.docs.first.data()['first_uid']);
            if (widget.supx == false) {
              FirebaseFirestore.instance
                  .collection('customer_details')
                  .doc(uidq)
                  .update({
                'businesslast': false,
              });
            }
          }
          widget.supx || widget.koko
              ? // Future.delayed(const Duration(seconds: 2), (() {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (ctx) => const UserMainx('none'))) //;
              //    }))
              : Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (ctx) => const UserMain('none')));

          // Navigator.of(context).pushReplacementNamed(userChoose.routeName);
          // print('User is signed in!');
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
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 30,
        ),
        //    margin: const EdgeInsets.all(20),
//         child:
// SingleChildScrollView(
        // child: Padding(
        //   padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 15),
              widget.supx || widget.userx == 'result.user!.uidx'
                  ? const SizedBox(height: 30)
                  : const SizedBox(),
              widget.supx || widget.userx == 'result.user!.uidx'
                  ? Center(
                      child: SizedBox(
                          //   height: 100,
                          //   width: double.infinity,
                          child: Image.asset(
                      'assets/alaqy.jpeg',
                      fit: BoxFit.contain,
                    )))
                  : const SizedBox(),
              widget.supx || widget.userx == 'result.user!.uidx'
                  ? const SizedBox(height: 50)
                  : const SizedBox(),
              widget.supx
                  ? Center(
                      child: Text(
                      !widget.koko ? 'بيانات العميل' : "تعديل البيانات",
                      style:
                          TextStyle(fontFamily: 'Tajawal', color: Colors.black),
                    ))
                  : widget.userx == 'result.user!.uidx'
                      ? const Center(
                          child: Text(
                          'هذا الرقم لديه حساب بالفعل',
                          style: TextStyle(
                              fontFamily: 'Tajawal', color: Colors.black),
                        ))
                      : const SizedBox(),
              const SizedBox(),
              // Text(widget.phone),
              // if (_isLogin) UserImagePicker(_pickedImage),
              widget.supx || widget.userx == 'result.user!.uidx'
                  ? const SizedBox(height: 50)
                  : const SizedBox(),

              if (knok || widget.koko == false)
                TextFormField(
                  //   initialValue: _initValues['phone'],
                  keyboardType: TextInputType.phone,
                  textAlign: TextAlign.center,
                  readOnly:
                      widget.userx == 'result.user!.uidx' ? true : widget.supx,

                  decoration: InputDecoration(
                    label: Center(
                        child: Text(
                      'رقم الموبايل',
                      style: TextStyle(
                          fontFamily: 'Tajawal',
                          color: Color.fromARGB(48, 0, 0, 0)),
                    )),
// helperStyle: TextStyle(),
                    enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.grey.shade200)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: Colors.grey.shade300)),
                    filled: true, //_phoneController.text == '' ? true : false,
                    fillColor: Colors.white,
                    // hintText: "Phone Number"
                  ),
                  controller: _phoneController,
                ),
              if (widget.supx && widget.koko == false)
                const SizedBox(height: 15),

              if (widget.supx && widget.koko == false)
                TextFormField(
                  key: const ValueKey('email'),
                  //   initialValue: _userEmail,
                  textAlign: TextAlign.center,

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
                  decoration: InputDecoration(
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                      enabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey.shade200)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey.shade300)),
                      filled: true,
                      fillColor: Colors.white,
                      //  labelText: widget.koko ? 'enter new Password' : 'Password',
                      label: Center(
                        //   labelText:
                        child: knok == true || widget.koko == true
                            ? Text('please enter an existing email')
                            : Text(
                                'اسم المستخدم',
                                style: TextStyle(
                                    fontFamily: 'Tajawal',
                                    color: Color.fromARGB(48, 0, 0, 0)),
                              ),
                      )),
                  obscureText: true,

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
              const SizedBox(height: 10),
              TextFormField(
                key: const ValueKey('password'),
                textAlign: TextAlign.center,
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
                decoration: InputDecoration(
                  label: Center(
                      child: widget.koko == false
                          ? Text(
                              "كلمة المرور",
                              style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  color: Color.fromARGB(48, 0, 0, 0)),
                            )
                          : Text(
                              'ادخال كلمة مرور جديدة',
                              style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  color: Color.fromARGB(48, 0, 0, 0)),
                            )),
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Colors.grey.shade200)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Colors.grey.shade300)),
                  filled: true,
                  fillColor: Colors.white,
                  //  labelText: widget.koko ? 'enter new Password' : 'Password',
                ),
                obscureText: true,
                onSaved: (value) {
                  if (value != null) {
                    _userPassword = value;
                    print(_userPassword);
                  }
                },
              ),

              const SizedBox(height: 17),
              //     if (widget.isLoading) const CircularProgressIndicator(),
              //   if (!widget.isLoading)
              loading == true //     (widget.isLoading)
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith(
                              (states) => Color.fromARGB(255, 253, 202, 0))),
                      onPressed: () {
                        setState(() {
                          loading == true;
                        });
                        Future.delayed(const Duration(seconds: 2), (() {
                          _trySubmit();
                        }));
                      },
                      child: SizedBox(
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              !widget.supx ? 'دخول الى الحساب' : 'حفظ البيانات',
                              style: TextStyle(
                                  fontFamily: 'Tajawal', color: Colors.black),
                              //  style: TextStyle(color: Colors.black),
                            ),
                          ))),

              (!widget.supx) && widget.userx != 'result.user!.uidx'
                  ? TextButton(
                      //            textColor: Theme.of(context).primaryColor, LoginScreen('customer')
                      child: const Text(
                        'انشاء حساب',
                        style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 59, 53, 53)),
                      ),
                      onPressed: () {
                        print('check');
                        //  Navigator.of(context).pop();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LoginScreen('customer', false)));
                      },
                    )
                  // : TextButton(
                  //     //            textColor: Theme.of(context).primaryColor, LoginScreen('customer')
                  //     child: const Text('back'),
                  //     onPressed: () {
                  //       Navigator.of(context).pushReplacementNamed('/');
                  //     },
                  //   ),
                  : const SizedBox(),
              !widget.koko && !widget.supx
                  ? const SizedBox(
                      height: 15,
                    )
                  : const SizedBox(),
              !widget.koko && !widget.supx
                  ? TextButton(
                      child: const Text(
                        'نسيت كلمة المرور؟',
                        style: TextStyle(
                            fontFamily: 'Tajawal',
                            color: Color.fromARGB(175, 59, 53, 53)),
                      ),
                      onPressed: () async {
                        // if (_phoneController.text.trim() == '' ||
                        //     _phoneController.text.trim() == '+20') {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(
                        //       content: const Text(
                        //           'please enter phone number first.'),
                        //       backgroundColor: Theme.of(context).errorColor,
                        //     ),
                        //   );
                        //   return;
                        // } else {
                        //   final koxx = await FirebaseFirestore.instance
                        //       .collection('customer_details')
                        //       .where('phone_num',
                        //           isEqualTo: _phoneController.text.trim())
                        //       .get();

                        //   if (koxx.docs.isEmpty) {
                        //     ScaffoldMessenger.of(context).showSnackBar(
                        //       SnackBar(
                        //         content: const Text(
                        //             'this number dont belong to any user account.'),
                        //         backgroundColor: Theme.of(context).errorColor,
                        //       ),
                        //     );
                        //     return;
                        //   } else {
                        setState(() {
                          knok = true;
                        });
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
// AuthScreenUser(
//                                           _phoneController.text,
//                                           'result.user!.uid',
//                                           false,
//                                           true)
                                    LoginScreen('customer', true)));
                        //   String _result = await sendSMS(
                        //           message: 'Hello, this the test message',
                        //           recipients: ['+201558559900'],
                        //           sendDirect: true)
                        //       .catchError((onError) {
                        //     print(onError);
                        //   });
                        //   print(_result);
                        //   _sendSMS('Hello, this the test message',
                        //       ['+201558559900']);
                        //  }
                        //  }
                      },
                    )
                  : const SizedBox(),

              // : TextButton(
              //     //            textColor: Theme.of(context).primaryColor, LoginScreen('customer')
              //     child: const Text('الرجوع'),
              //     onPressed: () {
              //       Navigator.of(context).pushReplacementNamed('/');
              //     },
              //   ),
              widget.koko || widget.supx || widget.userx == 'result.user!.uidx'
                  ? TextButton(
                      //            textColor: Theme.of(context).primaryColor, LoginScreen('customer')
                      child: const Text(
                        'الرجوع',
                        style: TextStyle(
                            fontFamily: 'Tajawal',
                            color: Color.fromARGB(48, 0, 0, 0)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/');
                      },
                    )
                  : const SizedBox(),
              // TextButton(
              //   //            textColor: Theme.of(context).primaryColor, LoginScreen('customer')
              //   child: const Text('splash'),
              //   onPressed: () {
              //     Navigator.of(context)
              //         .pushReplacementNamed(SplashScreen.routeName);
              //   },
              // ),

              loading == true
                  ? const CircularProgressIndicator()
                  : const SizedBox(),
              AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    '',
                    textStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.cyanAccent,
                      overflow: TextOverflow.visible,
                    ),
                    speed: const Duration(milliseconds: 100),
                  )
                ],
                // totalRepeatCount: 2,
                repeatForever: true,
                onNext: (p0, p1) {
                  if (!widget.supx && widget.userx != 'result.user!.uidx') {
                    _phoneController.text.trim() == ''
                        ? setState(() {
                            _phoneController.text = '+20';
                          })
                        : null;
                  }
                  if (widget.supx || widget.userx == 'result.user!.uidx') {
                    setState(() {
                      _phoneController.text = widget.phone;
                    });
                  }
                },
              ),
              //  : const Divider(),
            ],
          ),
        ),
      ),
      //   ),
      // ),
    );
  }
}
