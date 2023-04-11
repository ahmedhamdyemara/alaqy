import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alaqy/authScreenUser.dart';
import 'package:flutter_alaqy/user_main.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl_standalone.dart';
import 'dart:io';

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
  LoginScreen(this.accType);

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
  Map<String, String> _initValues = {
    'phone': '+20',
  };
  final _phoneController = TextEditingController();
  void need() async {
    final mobile = _phoneController.text.trim();
    final numberState = await FirebaseFirestore.instance
        .collection('customer_details')
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

  final _passController = TextEditingController();
  void already_registered(BuildContext context) {
    setState(() {
      loading = true;
    });
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => widget.accType == 'customer'
                ? AuthScreenUser(
                    _phoneController.toString(), 'result.user!.uid', false)
                : AuthScreenBusiness(
                    _phoneController.toString(), 'result.user!.uid', false)));
  }

  Future registerUser(String mobile, BuildContext context) async {
    setState(() {
      loading = true;
    });
    var _credential;
    var smsCode;
    final _codeController = TextEditingController();
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: mobile,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (AuthCredential authCredential) {
          _auth
              .signInWithCredential(authCredential)
              .then((UserCredential result) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => widget.accType == 'customer'
                        ? AuthScreenUser(
                            _phoneController.toString(), result.user!.uid, true)
                        : AuthScreenBusiness(_phoneController.toString(),
                            result.user!.uid, true)));
          }).catchError((e) {
            print(e);
          });
        },
        verificationFailed: (FirebaseAuthException authException) {
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
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          FirebaseAuth auth = FirebaseAuth.instance;

                          smsCode = _codeController.text.trim();

                          _credential = PhoneAuthProvider.credential(
                              verificationId: verificationId, smsCode: smsCode);
                          auth
                              .signInWithCredential(_credential)
                              .then((UserCredential result) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        widget.accType == 'customer'
                                            ? AuthScreenUser(
                                                _phoneController.text,
                                                result.user!.uid,
                                                true)
                                            : AuthScreenBusiness(
                                                _phoneController.text,
                                                result.user!.uid,
                                                true)));
                          }).catchError((e) {
                            print(e);
                          });
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
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(32),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Colors.grey.shade200)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: Colors.grey.shade300)),
                  filled: true,
                  fillColor: Colors.grey[100],
                  hintText: "Phone Number"),
              controller: _phoneController,
            ),
            const SizedBox(
              height: 8,
            ),
loading == true ? const CircularProgressIndicator(): const SizedBox(),
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
                  Future.delayed(const Duration(seconds: 2), (() {
                    print('xoxo');
                    print(_already);

                    need();
                    print(_already);

                    final mobile = _phoneController.text.trim();
                    _already
                        ? already_registered(context)
                        : registerUser(mobile, context);
                  }));
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
                                  'result.user!.uid', false)
                              : AuthScreenBusiness(_phoneController.text,
                                  'result.user!.uid', false)));
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
