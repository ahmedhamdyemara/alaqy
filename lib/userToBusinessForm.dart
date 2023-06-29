import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'ImagePicker.dart';
import 'business_mainx.dart';

class UserToBusinessForm extends StatefulWidget {
  const UserToBusinessForm(
    this.submitFn,
    this.isLoading,
  );

  final bool isLoading;
  final void Function(
    String email,
    String area,
    String storename,
    String category,
    String city,
    String password,
    String userName,
    dynamic image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  UserToBusinessFormState createState() => UserToBusinessFormState();
}

class UserToBusinessFormState extends State<UserToBusinessForm> {
  bool? loading;
  final storecontroller = TextEditingController();
  var _userImageFile;
  bool cityon = false;
  bool caton = false;
  bool aron = false;
  bool add = true;

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
  void _pickedImage(dynamic image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    setState(() {
      loading = true;
    });
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (area == '' && _isLogin) {
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
      widget.submitFn(
        _userEmail.trim(),
        area.trim(),
        _storename.trim(),
        _category.trim() == '' ? names2[0] : _category.trim(),
        _city.trim() == '' ? names[0] : _city.trim(),
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
          Future.delayed(const Duration(seconds: 3), (() {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (ctx) => const BusinessMainx('none', 'widget.phone')));
          }));
          print('User is signed in!');

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
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
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
                UserImagePicker(_pickedImage),
                TextFormField(
                  key: const ValueKey('username'),
                  enableSuggestions: false,
                  controller: storecontroller,
                  validator: (value) {
                    if (value != null) {
                      return (value.isEmpty || value.length < 4)
                          ? 'Please enter at least 4 characters'
                          : null;
                    }
                  },
                  decoration: const InputDecoration(labelText: 'store name'),
                  onSaved: (value) {
                    if (value != null) {
                      _userName = value;
                    }
                  },
                ),
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
                      onTap: () {},
                    )),
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
                          color:
                              caton == false ? Colors.grey : Colors.tealAccent),
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
                      }
                    },
                    selectedItemBuilder: (BuildContext context) {
                      return nnn2;
                    },
                    items: mmm2,
                  ),
                  onTap: () {},
                ),
                ListTile(
                  leading: Text(
                    area,
                    style: TextStyle(
                        color: aron == false ? Colors.grey : Colors.deepPurple),
                  ),
                  trailing: DropdownButton(
                    underline: Text(
                      'area',
                      style: TextStyle(
                          color: aron == false ? Colors.grey : Colors.blueGrey),
                    ),
                    icon: Icon(Icons.location_on,
                        color: aron == false ? Colors.grey : Colors.deepPurple),
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
                  ),
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                (loading == true)
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
