import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alaqy/authScreenUser.dart';

import 'AuthScreenBusiness.dart';
// import 'auth.dart';
// import 'http_exception.dart';
// import 'auth_screeeen.dart';
// import 'categoriesscreen.dart';
// import 'foundbyloc.dart';
// import 'fucks.dart';
// import 'products_overview_screen.dart';

// class Number extends StatefulWidget {
//   static const routeName = '/Number';
//   @override
//   State<Number> createState() => NumberState();
// }

// class NumberState extends State<Number> {
//   var isLoading = false;

//   void cat(context) async {
//     setState(() {
//       isLoading = true;
//     });
//     //  final oppas = Provider.of<Auth>(context, listen: false);

//     final oppa = FirebaseAuth.instance.currentUser!.email;
// //Provider.of<Auth>(context, listen: false).userId;

//     final user = FirebaseAuth.instance.currentUser;
//     final userData = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user?.uid)
//         .get();
//     FirebaseFirestore.instance.collection('welcome').doc(oppa).set({
//       'welcomed': oppa,
//       'marhab': user?.uid,
//     });
//     if (!mounted) return;
//     final userrr = FirebaseAuth.instance.currentUser!.email;
// //Provider.of<Auth>(context, listen: false).userId;
//     if (userrr != null) {
//       await FirebaseFirestore.instance.collection('chato').doc(oppa).set({
//         'pokeuser': 'x',
//       });
//       await FirebaseFirestore.instance.collection('chato').doc('${oppa}x').set({
//         'pokeuser': 'x',
//       });
//       setState(() {
//         isLoading = false;
//       });
//       Navigator.of(context).pushReplacementNamed(Foundbyloc.routeName);
//     } else {
//       setState(() {
//         isLoading = false;
//       });
//       Navigator.of(context).pushReplacementNamed(AuthScreenn.routeName);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             'EL-koshk     -Welcome ',
//             style: TextStyle(
//               fontSize: 18,
//             ),
//           ),
//         ),
//         body: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Center(
//                   child: isLoading == true
//                       ? const CircularProgressIndicator()
//                       : ElevatedButton(
//                           child: const Text(
//                               'Press here if u r over 15 yrs old to continue'),
//                           onPressed: () async {
//                             cat(context);
//                           })),
//               SizedBox(
//                   width: double.infinity,
//                   height: 70,
//                   child: ElevatedButton(
//                       child: const Text('skip if u confirmed this before'),
//                       onPressed: () async {
//                         Navigator.of(context)
//                             .pushReplacementNamed(Foundbyloc.routeName);
//                       }))
//             ]));
//   }
// }
class LoginScreen extends StatefulWidget {
  static const routeName = '/Number';
  String accType;
  bool koke;
  LoginScreen(this.accType, this.koke);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  bool loading = false;
  bool sup = true;
  var _already = false;
  var _usertobus = false;
  Map<String, String> _initValues = {
    'phone': '+20',
  };
  final _phoneController = TextEditingController();
  void need() async {
    final mobile = _phoneController.text.trim();
    final numberState = widget.accType == 'customer'
        ? await FirebaseFirestore.instance
            .collection('customer_details')
            .where('phone_num', isEqualTo: mobile)
            .get()
        : await FirebaseFirestore.instance
            .collection('business_details')
            .where('phone_num', isEqualTo: mobile)
            .get();
    numberState.docs.isNotEmpty
        ? setState(() {
            _already = true;
          })
        : setState(() {
            _already = false;
          });
    print(_already);
    print('already');
    print(mobile);
  }

  void need2(cox) async {
    final mobile = _phoneController.text.trim();
    final usertobusx = await FirebaseFirestore.instance
        .collection('customer_details')
        .where('phone_num', isEqualTo: mobile)
        .get();
    if (widget.accType == 'business' && _already == false) {
      print('shawn michaels');
      // final usertobusx = await FirebaseFirestore.instance
      //     .collection('customer_details')
      //     .where('phone_num', isEqualTo: mobile)
      //     .get();
      usertobusx.docs.isNotEmpty
          ? setState(() {
              _usertobus = true;
            })
          : setState(() {
              _usertobus = false;
            });
      // usertobusx.docs.isNotEmpty
      //     ? MaterialPageRoute(
      //         builder: (context) => UserToBusinessScreen(
      //             _phoneController.toString(),
      //             usertobusx.docs.first.id,
      //             usertobusx.docs.first.data()['second_uid'],
      //             mobile))
      //     : null;
    }
    // print(usertobusx.docs.first.data()['username']);
    _usertobus == true
        ? Navigator.pushReplacement(
            cox,
            MaterialPageRoute(
                builder: (context) => AuthScreenBusiness(
                    mobile,
                    usertobusx.docs.first.id,
                    true,
                    usertobusx.docs.first.data()['username'])))
        : null;
  }

  final _passController = TextEditingController();
//   void already_customergobus(BuildContext context) { setState(() {
//       loading = true;
//     });
//  MaterialPageRoute(
//             builder: (context) =>  UserToBusinessScreen(
//                     _phoneController.toString(), 'result.user!.uid', false));

// }

  void already_registered(BuildContext context) {
    setState(() {
      loading = true;
    });
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => widget.accType == 'customer'
                ? AuthScreenUser(
                    _phoneController.text, 'result.user!.uidx', false, false)
                : AuthScreenBusiness(
                    _phoneController.text, 'result.user!.uidx', false, '')));
    // print('result.user!.uidx');
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

  Future registerUser(String mobile, BuildContext context) async {
    setState(() {
      loading = true;
    });
    try {
      var _credential;
      var smsCode;
      final _codeController = TextEditingController();
      FirebaseAuth _auth = FirebaseAuth.instance;
      if (widget.koke == true) {
        final numberState = widget.accType == 'customer'
            ? await FirebaseFirestore.instance
                .collection('customer_details')
                .where('phone_num', isEqualTo: mobile)
                .get()
            : await FirebaseFirestore.instance
                .collection('business_details')
                .where('phone_num', isEqualTo: mobile)
                .get();
        if (numberState.docs.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('this number dont belong to any account.'),
              backgroundColor: Theme.of(context).errorColor,
            ),
          );
          setState(() {
            loading = false;
          });
          return;
        }
      }
      //if (widget.koke == false) {
      (widget.koke == false)
          ? _auth.verifyPhoneNumber(
              phoneNumber: mobile,
              timeout: const Duration(seconds: 60),
              verificationCompleted: (AuthCredential authCredential) {
                try {
                  setState(() {
                    loading = true;
                  });
                  _auth
                      .signInWithCredential(authCredential)
                      .then((UserCredential result) {
                    try {
                      Navigator.of(context).pop(false);
                      setState(() {
                        loading = false;
                      });
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => widget.accType == 'customer'
                                  ? AuthScreenUser(_phoneController.text,
                                      result.user!.uid, true, false)
                                  : AuthScreenBusiness(_phoneController.text,
                                      result.user!.uid, true, '')));
                    } on HttpException catch (err) {
                      var errMessage = 'Authentication failed';
                      if (err.toString().contains('incorrect')) {
                        errMessage = 'Please enter a valid number';
                      } else if (err.toString().contains('TOO_LONG')) {
                        errMessage = 'Please enter a valid number';
                      } else {
                        errMessage =
                            'Could not authenticate you. Please try again later.';
                      }

                      _showErrorDialog(errMessage);
                    } catch (err) {
                      if (err.toString().isEmpty) {
                        null;
                      } else {
                        final errMessage = err.toString();
                        _showErrorDialog(errMessage);

                        print(err);
                      }
                    }
                  }).catchError((e) {
                    var errMessage = 'Authentication failed';
                    if (e.toString().contains('incorrect')) {
                      errMessage = 'Please enter a valid number';
                    } else if (e.toString().contains('TOO_LONG')) {
                      errMessage = 'Please enter a valid number';
                    } else {
                      errMessage =
                          'Could not authenticate you. Please try again later.';
                    }

                    _showErrorDialog(errMessage);
                    print(e);
                  });
                } on HttpException catch (err) {
                  var errMessage = 'Authentication failed';
                  if (err.toString().contains('incorrect')) {
                    errMessage = 'Please enter a valid number';
                  } else if (err.toString().contains('TOO_LONG')) {
                    errMessage = 'Please enter a valid number';
                  } else {
                    errMessage =
                        'Could not authenticate you. Please try again later.';
                  }

                  _showErrorDialog(errMessage);
                } catch (err) {
                  if (err.toString().isEmpty) {
                    null;
                  } else {
                    final errMessage = err.toString();
                    _showErrorDialog(errMessage);

                    print(err);
                  }
                }
              },
              verificationFailed: (FirebaseAuthException authException) {
                _showErrorDialog(authException.message.toString());
                setState(() {
                  loading = false;
                });
                print(authException.message);
              },
              codeSent: (String verificationId, [int? forceResendingToken]) {
                //show dialog to take input from the user
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                          title: const Text("Enter SMS Code"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextField(
                                controller: _codeController,
                                keyboardType: TextInputType.phone,
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  loading = true;
                                });
                                FirebaseAuth auth = FirebaseAuth.instance;

                                smsCode = _codeController.text.trim();

                                _credential = PhoneAuthProvider.credential(
                                    verificationId: verificationId,
                                    smsCode: smsCode);
                                auth
                                    .signInWithCredential(_credential)
                                    .then((UserCredential result) {
                                  try {
                                    Navigator.of(context).pop(false);
                                    setState(() {
                                      loading = false;
                                    });
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                widget.accType == 'customer'
                                                    ? AuthScreenUser(
                                                        _phoneController.text,
                                                        result.user!.uid,
                                                        true,
                                                        false)
                                                    : AuthScreenBusiness(
                                                        _phoneController.text,
                                                        result.user!.uid,
                                                        true,
                                                        '')));
                                  } on HttpException catch (err) {
                                    var errMessage = 'Authentication failed';
                                    if (err.toString().contains('Incorrect')) {
                                      errMessage = 'Incorrect validation code';
                                    } else if (err
                                        .toString()
                                        .contains('Wrong')) {
                                      errMessage = 'Incorrect validation code';
                                    } else {
                                      errMessage =
                                          'Could not authenticate you. Please try again later.';
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
                                  }
                                }).catchError((e) {
                                  var errMessage = 'Authentication failed';
                                  if (e.toString().contains('incorrect')) {
                                    errMessage = 'code is not valid';
                                  } else if (e
                                      .toString()
                                      .contains('Incorrect validation code')) {
                                    errMessage = 'code is not valid';
                                  } else {
                                    errMessage =
                                        'Could not authenticate you. Please try again later.';
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
                                  print(e);
                                });

                                // Navigator.of(context).pop();
                                // setState(() {
                                //   loading = false;
                                // });
                              },
                              child: const Text(
                                "Done",
                                style: TextStyle(color: Colors.blue),
                              ),
                            )
                          ],
                        ));
              },
              codeAutoRetrievalTimeout: (String verificationId) {
                verificationId = verificationId;
                print(verificationId);
                print("Timout");
              })
          : _auth.verifyPhoneNumber(
              phoneNumber: mobile,
              timeout: const Duration(seconds: 60),
              verificationCompleted: (AuthCredential authCredential) {
                try {
                  setState(() {
                    loading = true;
                  });
                  _auth
                      .signInWithCredential(authCredential)
                      .then((UserCredential result) {
                    try {
                      Navigator.of(context).pop(false);
                      setState(() {
                        loading = false;
                      });
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => widget.accType == 'customer'
                                  ? AuthScreenUser(_phoneController.text,
                                      result.user!.uid, true, true)
                                  : AuthScreenBusiness(_phoneController.text,
                                      result.user!.uid, true, '')));
                    } on HttpException catch (err) {
                      var errMessage = 'Authentication failed';
                      if (err.toString().contains('incorrect')) {
                        errMessage = 'Please enter a valid number';
                      } else if (err.toString().contains('TOO_LONG')) {
                        errMessage = 'Please enter a valid number';
                      } else {
                        errMessage =
                            'Could not authenticate you. Please try again later.';
                      }

                      _showErrorDialog(errMessage);
                    } catch (err) {
                      if (err.toString().isEmpty) {
                        null;
                      } else {
                        final errMessage = err.toString();
                        _showErrorDialog(errMessage);

                        print(err);
                      }
                    }
                  }).catchError((e) {
                    var errMessage = 'Authentication failed';
                    if (e.toString().contains('incorrect')) {
                      errMessage = 'Please enter a valid number';
                    } else if (e.toString().contains('TOO_LONG')) {
                      errMessage = 'Please enter a valid number';
                    } else {
                      errMessage =
                          'Could not authenticate you. Please try again later.';
                    }

                    _showErrorDialog(errMessage);
                    print(e);
                  });
                } on HttpException catch (err) {
                  var errMessage = 'Authentication failed';
                  if (err.toString().contains('incorrect')) {
                    errMessage = 'Please enter a valid number';
                  } else if (err.toString().contains('TOO_LONG')) {
                    errMessage = 'Please enter a valid number';
                  } else {
                    errMessage =
                        'Could not authenticate you. Please try again later.';
                  }

                  _showErrorDialog(errMessage);
                } catch (err) {
                  if (err.toString().isEmpty) {
                    null;
                  } else {
                    final errMessage = err.toString();
                    _showErrorDialog(errMessage);

                    print(err);
                  }
                }
              },
              verificationFailed: (FirebaseAuthException authException) {
                _showErrorDialog(authException.message.toString());
                setState(() {
                  loading = false;
                });
                print(authException.message);
              },
              codeSent: (String verificationId, [int? forceResendingToken]) {
                //show dialog to take input from the user
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                          title: const Text("Enter SMS Code"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextField(
                                controller: _codeController,
                                keyboardType: TextInputType.phone,
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  loading = true;
                                });
                                FirebaseAuth auth = FirebaseAuth.instance;

                                smsCode = _codeController.text.trim();

                                _credential = PhoneAuthProvider.credential(
                                    verificationId: verificationId,
                                    smsCode: smsCode);
                                auth
                                    .signInWithCredential(_credential)
                                    .then((UserCredential result) {
                                  try {
                                    Navigator.of(context).pop(false);
                                    setState(() {
                                      loading = false;
                                    });
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                widget.accType == 'customer'
                                                    ? AuthScreenUser(
                                                        _phoneController.text,
                                                        result.user!.uid,
                                                        true,
                                                        true)
                                                    : AuthScreenBusiness(
                                                        _phoneController.text,
                                                        result.user!.uid,
                                                        true,
                                                        '')));
                                  } on HttpException catch (err) {
                                    var errMessage = 'Authentication failed';
                                    if (err.toString().contains('Incorrect')) {
                                      errMessage = 'Incorrect validation code';
                                    } else if (err
                                        .toString()
                                        .contains('Wrong')) {
                                      errMessage = 'Incorrect validation code';
                                    } else {
                                      errMessage =
                                          'Could not authenticate you. Please try again later.';
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
                                  }
                                }).catchError((e) {
                                  var errMessage = 'Authentication failed';
                                  if (e.toString().contains('incorrect')) {
                                    errMessage = 'code is not valid';
                                  } else if (e
                                      .toString()
                                      .contains('Incorrect validation code')) {
                                    errMessage = 'code is not valid';
                                  } else {
                                    errMessage =
                                        'Could not authenticate you. Please try again later.';
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
                                  print(e);
                                });

                                // Navigator.of(context).pop();
                                // setState(() {
                                //   loading = false;
                                // });
                              },
                              child: const Text(
                                "Done",
                                style: TextStyle(color: Colors.blue),
                              ),
                            )
                          ],
                        ));
              },
              codeAutoRetrievalTimeout: (String verificationId) {
                verificationId = verificationId;
                print(verificationId);
                print("Timout");
              });
    } on HttpException catch (err) {
      var errMessage = 'Authentication failed';
      if (err.toString().contains('incorrect')) {
        errMessage = 'Please enter a valid number';
      } else if (err.toString().contains('TOO_LONG')) {
        errMessage = 'Please enter a valid number';
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
    }

    // Navigator.of(context).pop(false);
    // setState(() {
    //   loading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('alaqy auth'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/');
                },
                icon: const Icon(
                  Icons.swap_horizontal_circle_sharp,
                  size: 40,
                ))
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(32),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                widget.accType == 'customer'
                    ? AnimatedTextKit(
                        animatedTexts: [
                          ColorizeAnimatedText('register as user',
                              colors: [
                                Colors.tealAccent,
                                Colors.redAccent,
                                Colors.cyanAccent,
                              ],
                              textStyle: const TextStyle(
                                fontSize: 23,
                              ),
                              textAlign: TextAlign.center,
                              speed: const Duration(milliseconds: 100)),
                        ],
                        repeatForever: true,
                      )
                    : AnimatedTextKit(
                        animatedTexts: [
                          ColorizeAnimatedText('register as business ',
                              colors: [
                                Colors.tealAccent,
                                Colors.deepPurple,
                                Colors.cyanAccent,
                              ],
                              textStyle: const TextStyle(
                                fontSize: 23,
                              ),
                              textAlign: TextAlign.center,
                              speed: const Duration(milliseconds: 100)),
                        ],
                        repeatForever: true,
                      ),

                const Text(
                  "Register",
                  style: TextStyle(
                      color: Colors.lightBlue,
                      fontSize: 36,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  //   initialValue: _initValues['phone'],
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey.shade200)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey.shade300)),
                      filled: true,
                      fillColor: Colors.grey[100],
                      hintText: "Phone Number"),
                  controller: _phoneController,
                ),
                const SizedBox(
                  height: 8,
                ),
                loading == true
                    ? const CircularProgressIndicator()
                    : const SizedBox(),
                const SizedBox(
                  height: 8,
                ),
                // TextFormField(
                //   decoration: InputDecoration(
                //       enabledBorder: OutlineInputBorder(
                //           borderRadius: const BorderRadius.all(Radius.circular(8)),
                //           borderSide: BorderSide(color: Colors.grey.shade200)),
                //       focusedBorder: OutlineInputBorder(
                //           borderRadius: const BorderRadius.all(Radius.circular(8)),
                //           borderSide: BorderSide(color: Colors.grey.shade300)),
                //       filled: true,
                //       fillColor: Colors.grey.shade100,
                //       hintText: "Password"),
                //   controller: _passController,
                // ),

                Container(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        loading = true;
                      });
                      Future.delayed(const Duration(seconds: 2), (() {
                        print('xoxo');
                        print(_already);

                        need();
                        need2(context);
                        print(_already);

                        final mobile = _phoneController.text.trim();
                        _already && widget.koke == false
                            ? already_registered(context)
                            : registerUser(mobile, context);
                      }));
                      // Future.delayed(const Duration(seconds: 18), (() {
                      //   setState(() {
                      //     loading = false;
                      //     _showErrorDialog('not a valid number');
                      //   });
                      // }));
                    },
                    child: const Text(
                      "submit",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  color: Colors.grey.shade100,
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        loading = true;
                      });
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => widget.accType == 'customer'
                                  ? AuthScreenUser(_phoneController.text,
                                      'result.user!.uid', false, false)
                                  : AuthScreenBusiness(_phoneController.text,
                                      'result.user!.uid', false, '')));
                    },
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TyperAnimatedText(
                          'already have an account?',
                          textStyle: const TextStyle(
                            fontSize: 20,
                            color: Colors.cyanAccent,
                            overflow: TextOverflow.visible,
                          ),
                          speed: const Duration(milliseconds: 100),
                        )
                      ],
                      repeatForever: true,
                      onNext: (p0, p1) {
                        need();
                        //   need2();
                      },
                      onTap: () {
                        setState(() {
                          loading = true;
                        });
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    widget.accType == 'customer'
                                        ? AuthScreenUser(_phoneController.text,
                                            'result.user!.uid', false, false)
                                        : AuthScreenBusiness(
                                            _phoneController.text,
                                            'result.user!.uid',
                                            false,
                                            '')));
                      },
                    ),
                  ),
                ),
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
                    _phoneController.text.trim() == ''
                        ? setState(() {
                            _phoneController.text = '+20';
                          })
                        : null;
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
