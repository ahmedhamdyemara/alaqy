import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';

import 'ImagePicker.dart';
import 'business_main.dart';
import 'business_mainx.dart';
import 'numberPhone.dart';

// import 'fucks.dart';
// import 'user_image_picker.dart';

class AuthFormBusiness extends StatefulWidget {
  const AuthFormBusiness(
      this.submitFn, this.isLoading, this.supx, this.phone, this.username);
  final bool supx;
  final bool isLoading;
  final String phone;
  final String username;

  final void Function(
    String email,
    String area,
    String category,
    String city,
    String password,
    String userName,
    dynamic image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  AuthFormBusinessState createState() => AuthFormBusinessState();
}

class AuthFormBusinessState extends State<AuthFormBusiness> {
  bool cityon = false;
  bool caton = false;
  bool aron = false;

  bool? loading;
  final _phoneController = TextEditingController();
  final _emailcontroller = TextEditingController();
  var _userImageFile;
  bool add = true;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  List names = [];
  List<Widget> nnn = [];
  List<DropdownMenuItem> mmm = [];
  List names2 = [];
  List<Widget> nnn2 = [];
  List<DropdownMenuItem> mmm2 = [];
  List names3 = [];
  List<Widget> nnn3 = [];
  List<DropdownMenuItem> mmm3 = [];
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _storename = '';
  var _category = '';
  var _userName = '';
  var _city = '';
  var _userPassword = '';
  var area = '';
  // var _userImageFile;

  void _pickedImage(dynamic image) {
    _userImageFile = image;
  }

  void sending_SMS(String msg, List<String> list_receipents) async {
    String send_result =
        await sendSMS(message: msg, recipients: list_receipents)
            .catchError((err) {
      print(err);
    });
    print(send_result);
  }

  void _trySubmit() async {
    final mobile = _phoneController.text.trim();
    final numberState = await FirebaseFirestore.instance
        .collection('business_details')
        .where('phone_num', isEqualTo: mobile)
        .get();
    if (numberState.docs.isNotEmpty) {
      final cops = (numberState.docs.first.data()['basicemail'])
          .toString()
          .split('@')
          .first;
      setState(() {
        _userEmail = cops;
      });
      print(_userEmail);
    }
    if (widget.supx == false &&
        numberState.docs.isEmpty &&
        widget.username == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              const Text('this number dont belong to any business account.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      FocusScope.of(context).unfocus();

      return;
    }
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    // if (_userImageFile == null && widget.supx) {
    //   setState(() {
    //     loading = false;
    //   });
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: const Text('Please pick an image.'),
    //       backgroundColor: Theme.of(context).errorColor,
    //     ),
    //   );
    //   return;
    // }
    // if (_city == '' && widget.supx) {
    //   setState(() {
    //     loading = false;
    //     caton = false;
    //     cityon = false;
    //     aron = false;
    //   });
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: const Text('Please choose a city.'),
    //       backgroundColor: Theme.of(context).errorColor,
    //     ),
    //   );
    //   FocusScope.of(context).unfocus();

    //   return;
    // }
    // if (_category == '' && widget.supx) {
    //   setState(() {
    //     loading = false;
    //     caton = false;
    //     cityon = false;
    //     aron = false;
    //   });
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: const Text('Please choose a category.'),
    //       backgroundColor: Theme.of(context).errorColor,
    //     ),
    //   );
    //   FocusScope.of(context).unfocus();

    //   return;
    // }
    if (area == '' && widget.supx) {
      setState(() {
        loading = false;
        caton = false;
        cityon = false;
        aron = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please choose an area.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      FocusScope.of(context).unfocus();

      return;
    }

    if (isValid == true) {
      _formKey.currentState?.save();
      widget.supx
          ? widget.submitFn(
              '${_userEmail.trim().replaceAll(RegExp(r' '), '_').replaceAll(RegExp(r'@'), '_')}@alaqy.com',
              area.trim(),
              _category.trim() == '' ? names2[0] : _category.trim(),
              _city.trim() == '' ? names[0] : _city.trim(),
              _userPassword.trim(),
              _userName.trim(),
              _userImageFile,
              _isLogin,
              context,
            )
          : widget.submitFn(
              '${_userEmail.trim().replaceAll(RegExp(r' '), '_')}@alaqy.com',
              area.trim(),
              _category.trim(),
              _city.trim(),
              _userPassword.trim(),
              _userName.trim(),
              _userImageFile,
              _isLogin,
              context,
            );
      // _phoneController.clear();
      //  _emailcontroller.dispose();
      FirebaseAuth.instance.userChanges().listen((User? user) {
        if (user == null) {
          print('User is currently signed out!');
        } else {
          //   final con = navigatorKey.currentState!.context;
          // navigatorKey.currentContext.debugDoingBuild;
          //   if (numberState.docs.isNotEmpty && widget.supx == false) {
          if (numberState.docs.isNotEmpty) {
            final uidq = (numberState.docs.first.data()['first_uid']);
            if (widget.supx == false) {
              FirebaseFirestore.instance
                  .collection('customer_details')
                  .doc(uidq)
                  .update({
                'businesslast': true,
              });
            }
          }
          widget.supx
              ? // Future.delayed(const Duration(seconds: 3), (() {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (ctx) => BusinessMainx('none', widget.phone)))
              // Navigator.of(context)
              //     .pushReplacementNamed(businessChoose.routeName);
              // }))
              : // Future.delayed(const Duration(seconds: 3), (() {
              // navigatorKey.currentState?.pushReplacement(MaterialPageRoute(
              //     builder: (ctx) => const BusinessMain('none')));
              //  if (mounted) {
              // setState(() {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (ctx) => const BusinessMain('none')));
          //    });

          //  }
          // Navigator.of(context)
          //     .pushReplacementNamed(businessChoose.routeName);
          //    }));
          // Navigator.of(context).push(
          //     MaterialPageRoute(builder: (ctx) => const BusinessMain('none')));
          //  Navigator.of(context).pushReplacementNamed(businessChoose.routeName);
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
    // print(widget.username);
    // print('${_userEmail}xx');
    //  final oppa = Provider.of<Auth>(context, listen: false).userId;
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                if (widget.supx)
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
                      totalRepeatCount: 1,
                      // repeatForever: true,
                      onNext: (p0, p1) async {
                        if (add == true) {
                          final areadocs = await FirebaseFirestore.instance
                              .collection('area')
                              .get();
                          final categorydocs = await FirebaseFirestore.instance
                              .collection('category')
                              .get();
                          final citydocs = await FirebaseFirestore.instance
                              .collection('city')
                              .get();
                          for (var x = 0; x < citydocs.docs.length; x++) {
                            names.add(citydocs.docs[x].data()['name']);
                          }
                          for (var r = 0; r < names.length; r++) {
                            nnn.add(Text(names[r]));
                            mmm.add(DropdownMenuItem(
                                value: names[r],
                                child: Container(
                                  child: Row(
                                    children: <Widget>[
                                      const Icon(Icons.location_city_outlined),
                                      const SizedBox(width: 2),
                                      Text(names[r]),
                                    ],
                                  ),
                                )));
                          }

                          for (var y = 0; y < categorydocs.docs.length; y++) {
                            names2.add(categorydocs.docs[y].data()['name']);
                          }
                          for (var z = 0; z < names2.length; z++) {
                            nnn2.add(Text(names2[z]));
                            mmm2.add(DropdownMenuItem(
                                value: names2[z],
                                child: Container(
                                  child: Row(
                                    children: <Widget>[
                                      const Icon(Icons.category_outlined),
                                      const SizedBox(width: 2),
                                      Text(names2[z]),
                                    ],
                                  ),
                                )));
                          }
                          for (var a = 0; a < areadocs.docs.length; a++) {
                            names3.add(areadocs.docs[a].data()['name']);
                          }
                          for (var b = 0; b < names3.length; b++) {
                            nnn3.add(Text(names3[b]));
                            mmm3.add(DropdownMenuItem(
                                value: names3[b],
                                child: Container(
                                  child: Row(
                                    children: <Widget>[
                                      const Icon(Icons.location_on),
                                      const SizedBox(width: 2),
                                      Text(names3[b]),
                                    ],
                                  ),
                                )));
                          }
                        }
                        setState(() {
                          add == false;
                        });
                      }),
                if (widget.supx) UserImagePicker(_pickedImage),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  readOnly: widget.supx,
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
                if (widget.supx)
                  TextFormField(
                    key: const ValueKey('email'),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    validator: (value) {
                      if (value != null) {
                        return (value.isEmpty)
                            ? 'Please enter a valid username.'
                            : null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    readOnly: widget.username == '' ? false : true,
                    decoration: const InputDecoration(
                      labelText: 'user name',
                    ),
                    controller: _emailcontroller,
                    onSaved: (value) {
                      if (value != null) {
                        _userEmail = value;
                      }
                    },
                  ),
                if (widget.supx)
                  TextFormField(
                    key: const ValueKey('username'),
                    autocorrect: true,
                    textCapitalization: TextCapitalization.words,
                    enableSuggestions: false,
                    validator: (value) {
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
                if (widget.supx)
                  // StreamBuilder(
                  //     stream: FirebaseFirestore.instance
                  //         .collection('city')
                  //         .snapshots(),
                  //     builder: (ctx, userSnapshot) {
                  //       if (userSnapshot.connectionState ==
                  //           ConnectionState.waiting) {
                  //         return const Center(
                  //           child: Text(
                  //             'Loading...',
                  //             style: TextStyle(fontSize: 2),
                  //           ),
                  //         );
                  //       }
                  //       final chatDocs =
                  //           userSnapshot.hasData ? userSnapshot.data : null;
                  //       List names = [];
                  //       List<Widget> nnn = [];
                  //       List<DropdownMenuItem> mmm = [];
                  //       for (var x = 0; x < chatDocs!.docs.length; x++) {
                  //         names.add(chatDocs.docs[x].data()['name']);
                  //       }
                  //       for (var r = 0; r < names.length; r++) {
                  //         nnn.add(Text(names[r]));
                  //         mmm.add(DropdownMenuItem(
                  //             value: names[r],
                  //             child: Container(
                  //               child: Row(
                  //                 children: <Widget>[
                  //                   const Icon(Icons.location_city_outlined),
                  //                   const SizedBox(width: 2),
                  //                   Text(names[r]),
                  //                 ],
                  //               ),
                  //             )));
                  //       }
                  //       return
                  ListTile(
                      leading: Text(
                        _city == ''
                            ? names.isEmpty
                                ? ''
                                : names[0]
                            : _city,
                        style: TextStyle(
                            color: cityon == false
                                ? Colors.grey
                                : Colors.deepPurple),
                      ),
                      title: DropdownButton(
                        underline: Text(
                          'city',
                          style: TextStyle(
                              color: cityon == false
                                  ? Colors.grey
                                  : Colors.amberAccent),
                        ),
                        icon: Icon(Icons.location_city_outlined,
                            color: cityon == false
                                ? Colors.grey
                                : Colors.deepPurple),
                        onChanged: (value) {
                          for (var k = 0; k < names.length; k++) {
                            if (value == names[k]) {
                              _city = names[k];
                              setState(() {
                                cityon = true;
                              });
                            }
                          }
                        },
                        selectedItemBuilder: (BuildContext context) {
                          return nnn;
                        },
                        items: mmm,

// [
//                                       DropdownMenuItem(
//                                         value: 'الاسكندرية',
//                                         child: Container(
//                                           child: Row(
//                                             children: const <Widget>[
//                                               Icon(
//                                                   Icons.location_city_outlined),
//                                               SizedBox(width: 2),
//                                               Text('الاسكندرية'),
//                                             ],
//                                           ),
//                                         ),
//                                       ),
//                                     ],
                        onTap: () {},
                      )),
                //        }),
                if (widget.supx)
                  // StreamBuilder(
                  //     stream: FirebaseFirestore.instance
                  //         .collection('category')
                  //         .snapshots(),
                  //     builder: (ctx, userSnapshot) {
                  //       if (userSnapshot.connectionState ==
                  //           ConnectionState.waiting) {
                  //         return const Center(
                  //           child: Text(
                  //             'Loading...',
                  //             style: TextStyle(fontSize: 2),
                  //           ),
                  //         );
                  //       }
                  //       final chatDocs =
                  //           userSnapshot.hasData ? userSnapshot.data : null;
                  //       List names = [];
                  //       List<Widget> nnn = [];
                  //       List<DropdownMenuItem> mmm = [];
                  //       for (var x = 0; x < chatDocs!.docs.length; x++) {
                  //         names.add(chatDocs.docs[x].data()['name']);
                  //       }
                  //       for (var r = 0; r < names.length; r++) {
                  //         nnn.add(Text(names[r]));
                  //         mmm.add(DropdownMenuItem(
                  //             value: names[r],
                  //             child: Container(
                  //               child: Row(
                  //                 children: <Widget>[
                  //                   const Icon(Icons.category_outlined),
                  //                   const SizedBox(width: 2),
                  //                   Text(names[r]),
                  //                 ],
                  //               ),
                  //             )));
                  //       }
                  //       print(names[1]);
                  //       return
                  ListTile(
                    leading: Text(
                      _category == ''
                          ? names2.isEmpty
                              ? ''
                              : names2[0]
                          : _category,
                      style: TextStyle(
                          color:
                              caton == false ? Colors.grey : Colors.deepPurple),
                    ),
                    trailing: DropdownButton(
                      underline: Text(
                        'category',
                        style: TextStyle(
                            color: caton == false
                                ? Colors.grey
                                : Colors.tealAccent),
                      ),
                      icon: Icon(Icons.category_outlined,
                          color:
                              caton == false ? Colors.grey : Colors.deepPurple),
                      onChanged: (value) {
                        for (var l = 0; l < names2.length; l++) {
                          if (value == names2[l]) {
                            _category = names2[l];
                            setState(() {
                              caton = true;
                            });
                          }
                          // if (value == '') {
                          //   _category = names2[0];
                          // }
                        }
                      },
                      selectedItemBuilder: (BuildContext context) {
                        return nnn2;
                      },
                      items: mmm2,

                      //   items: [
                      //     DropdownMenuItem(
                      //       value: 'ادوات المطبخ',
                      //       child: Container(
                      //         child: Row(
                      //           children: const <Widget>[
                      //             Icon(Icons.category_outlined),
                      //             Text('ادوات المطبخ'),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      //   onChanged: (value) {
                      //     if (value == 'ادوات المطبخ') {
                      //       _category = 'ادوات المطبخ';
                      //       setState(() {
                      //         caton = !caton;
                      //       });
                      //     }
                      //   },
                    ),
                    onTap: () {},
                  ),
                //       }),
                if (widget.supx)
                  // StreamBuilder(
                  //     stream: FirebaseFirestore.instance
                  //         .collection('area')
                  //         .snapshots(),
                  //     builder: (ctx, userSnapshot) {
                  //       if (userSnapshot.connectionState ==
                  //           ConnectionState.waiting) {
                  //         return const Center(
                  //           child: Text(
                  //             'Loading...',
                  //             style: TextStyle(fontSize: 2),
                  //           ),
                  //         );
                  //       }
                  //       final chatDocs =
                  //           userSnapshot.hasData ? userSnapshot.data : null;
                  //       List names = [];
                  //       List<Widget> nnn = [];
                  //       List<DropdownMenuItem> mmm = [];
                  //       for (var x = 0; x < chatDocs!.docs.length; x++) {
                  //         names.add(chatDocs.docs[x].data()['name']);
                  //       }
                  //       for (var r = 0; r < names.length; r++) {
                  //         nnn.add(Text(names[r]));
                  //         mmm.add(DropdownMenuItem(
                  //             value: names[r],
                  //             child: Container(
                  //               child: Row(
                  //                 children: <Widget>[
                  //                   const Icon(Icons.location_on),
                  //                   const SizedBox(width: 2),
                  //                   Text(names[r]),
                  //                 ],
                  //               ),
                  //             )));
                  //       }
                  //       return
                  ListTile(
                    leading: Text(
                      area,
                      style: TextStyle(
                          color:
                              aron == false ? Colors.grey : Colors.deepPurple),
                    ),
                    trailing: DropdownButton(
                      underline: Text(
                        'area',
                        style: TextStyle(
                            color:
                                aron == false ? Colors.grey : Colors.blueGrey),
                      ),
                      icon: Icon(Icons.location_on,
                          color:
                              aron == false ? Colors.grey : Colors.deepPurple),
                      onChanged: (value) {
                        for (var m = 0; m < names3.length; m++) {
                          if (value == names3[m]) {
                            area = names3[m];
                            setState(() {
                              aron = true;
                            });
                          }
                        }
                      },
                      selectedItemBuilder: (BuildContext context) {
                        return nnn3;
                      },
                      items: mmm3,
                      // items: [
                      //   DropdownMenuItem(
                      //     value: 'زيزينيا', //  from data base
                      //     child: Container(
                      //       child: Row(
                      //         children: const <Widget>[
                      //           Icon(Icons.location_on),
                      //           SizedBox(width: 2),
                      //           Text('زيزينيا'),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ],
                      // onChanged: (value) {
                      //   if (value == 'زيزينيا') {
                      //     setState(() {
                      //       area = 'زيزينيا';

                      //       aron = !aron;
                      //     });
                      //   }
                      // },
                    ),
                    onTap: () {
                      // setState(() {
                      //   //   area = 'زيزينيا';

                      //   aron = !aron;
                      // });
                    },
                  ),
                //   }),
                const SizedBox(height: 12),
                (widget.isLoading)
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          setState(() {
                            loading == true;
                          });
                          Future.delayed(const Duration(seconds: 2), (() {
                            _trySubmit();
                          }));
                        },
                        child: const Text('submit'),
                      ),
                (!widget.supx)
                    ? TextButton(
                        child: const Text('Create an account'),
                        onPressed: () {
                          print('conf');

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LoginScreen('business', false)));
                        },
                      )
                    : TextButton(
                        //            textColor: Theme.of(context).primaryColor, LoginScreen('customer')
                        child: const Text('back'),
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/');
                        },
                      ),
                TextButton(
                  child: const Text('forgot password'),
                  onPressed: () {
                    sending_SMS(
                        'Hello, this the test message', ['+201558559900']);
                  },
                ),
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
                    if (widget.username != '') {
                      //   setState(() {
                      _userEmail = widget.username.toString().split('@').first;
                      //     });
                      //    setState(() {
                      _emailcontroller.text =
                          widget.username.toString().split('@').first;
                      //     });
                    }
                    if (!widget.supx) {
                      if (mounted) {
                        _phoneController.text.trim() == ''
                            ?
// setState(() {
                            _phoneController.text = '+20' //;
                            //      })
                            : null;
                      }
                    }
                    if (widget.supx) {
                      //   setState(() {

                      _phoneController.text = widget.phone;
                      // });
                    }
                  },
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
