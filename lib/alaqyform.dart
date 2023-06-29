import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alaqy/imagepickerform.dart';
import 'package:flutter_alaqy/user_main.dart';

// import 'fucks.dart';
// import 'user_image_picker.dart';

class alaqyForm extends StatefulWidget {
  const alaqyForm(
    this.submitFn,
    this.isLoading,
  );

  final bool isLoading;
  final void Function(
    String category,
    String city,
    //  String area,
    String title,
    String description,
    dynamic image,
  ) submitFn;

  @override
  alaqyFormState createState() => alaqyFormState();
}

class alaqyFormState extends State<alaqyForm> {
  bool cityon = false;
  bool caton = false;
  // bool aron = false;

  bool loading = false;
  final storecontroller = TextEditingController();
  final _descriptiontroller = TextEditingController();
  final _titlecontroller = TextEditingController();

  var _userImageFile;
  var _description;

  final _formKey = GlobalKey<FormState>();
  // var _isLogin = true;
  var title = '';
  var description = '';
  var _category = '';
  //var area;
  var _city = '';
  var looking;
//  var _userPassword = '';

  void _pickedImage(dynamic image) {
    _userImageFile = image;
  }

  void routex() async {
    setState(() {
      _titlecontroller.clear();
      _descriptiontroller.clear();
    });

    Future.delayed(const Duration(seconds: 1), (() {
      Navigator.of(context).pop();

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const UserMain('zero')));
    }));
  }

  void _trySubmit() async {
    setState(() {
      loading = true;
    });
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    final categorydocs =
        await FirebaseFirestore.instance.collection('category').doc('1').get();
    final citydocs =
        await FirebaseFirestore.instance.collection('city').doc('1').get();
    final cityname = citydocs.data()!['name'];
    final categoryname = categorydocs.data()!['name'];
    print(cityname);
    print(categoryname);
    // if (_userImageFile == null && _isLogin) {
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
    // if (_city == '') {
    //   setState(() {
    //     loading = false;
    //   });
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: const Text('Please choose a city.'),
    //       backgroundColor: Theme.of(context).errorColor,
    //     ),
    //   );
    //   return;
    // }
    if (_titlecontroller.text.trim().length < 3) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('title must be at least three characters'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    if (_descriptiontroller.text.trim().length < 3) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('description must be at least three characters'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    if (isValid == true) {
      _formKey.currentState?.save();
      widget.submitFn(
          _titlecontroller.text.trim(), //   title.toString().trim(),
          _descriptiontroller.text.trim(), // _description.toString().trim(),
          _category.trim() == '' ? categoryname : _category.trim(),
          _city.trim() == '' ? cityname : _city.trim(),
          _userImageFile);
    }

    //  Navigator.of(context).pushReplacementNamed(userChoose.routeName);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Congratulations!'),
        content: AnimatedTextKit(
          animatedTexts: [
            TyperAnimatedText(
              'order on progress',
              textStyle: const TextStyle(
                fontSize: 16,
                color: Colors.cyanAccent,
                overflow: TextOverflow.visible,
              ),
              speed: const Duration(milliseconds: 100),
            )
          ],
          // totalRepeatCount: 2,
          repeatForever: true,
          onNext: (p0, p1) {
            // setState(() {
            //   _titlecontroller.clear();
            //   _descriptiontroller.clear();
            // });

            // Future.delayed(const Duration(seconds: 1), (() {
            //   Navigator.of(ctx).pop();

            //   Navigator.of(context).pushReplacement(
            //       MaterialPageRoute(builder: (ctx) => const UserMain('zero')));
            //   // setState(() {

            //   //  });
            // }));
          },
        ),
//  Text(
//           'Your order is on progress',
//         ),
        // actions: <Widget>[
        //   TextButton(
        //     child: const Text('ok'),
        //     onPressed: () {
        //       Navigator.of(ctx).pop(false);
        //     },
        //   ),
        // ],
      ),
    );
    Future.delayed(const Duration(seconds: 2), (() {
      setState(() {
        loading = false;
      });
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const UserMain('zero')));
      _titlecontroller.clear();
      _descriptiontroller.clear();
    }));
  }

  @override
  Widget build(BuildContext context) {
    //  final oppa = Provider.of<Auth>(context, listen: false).userId;

    return Center(
      child: (loading)
          ? const CircularProgressIndicator()
          : Card(
              margin: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          key: const ValueKey('title'),
                          enableSuggestions: false,
                          controller: _titlecontroller,
                          validator: (value) {
                            if (value != null) {
                              return (value.isEmpty || value.length < 3)
                                  ? 'Please enter at least 3 characters'
                                  : null;
                            }
                            return null;
                          },
                          decoration: const InputDecoration(labelText: 'title'),
                          onSaved: (value) {
                            if (value != null) {
                              setState(() {
                                title = value;
                              });

                              //   _titlecontroller.clear();
                            }
                          },
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        UserImagePickerForm(_pickedImage, null, false),
                        TextFormField(
                          //  key: const ValueKey('username'),

                          enableSuggestions: false,
                          controller: _descriptiontroller,
                          validator: (value) {
                            if (value != null) {
                              return (value.isEmpty)
                                  ? 'Please enter a value'
                                  : null;
                            }
                            return null;
                          },
                          decoration:
                              const InputDecoration(labelText: 'description'),
                          onSaved: (value) {
                            if (value != null) {
                              setState(() {
                                _description = value;
                              });
                              //    _descriptiontroller.clear();
                            }
                          },
                        ),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('city')
                                .snapshots(),
                            builder: (ctx, userSnapshot) {
                              if (userSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: Text(
                                    'Loading...',
                                    style: TextStyle(fontSize: 2),
                                  ),
                                );
                              }
                              final chatDocs = userSnapshot.hasData
                                  ? userSnapshot.data
                                  : null;
                              List names = [];
                              List<Widget> nnn = [];
                              List<DropdownMenuItem> mmm = [];
                              for (var x = 0; x < chatDocs!.docs.length; x++) {
                                names.add(chatDocs.docs[x].data()['name']);
                              }
                              for (var r = 0; r < names.length; r++) {
                                nnn.add(Text(names[r]));
                                mmm.add(DropdownMenuItem(
                                    value: names[r],
                                    child: Container(
                                      child: Row(
                                        children: <Widget>[
                                          const Icon(
                                              Icons.location_city_outlined),
                                          const SizedBox(width: 2),
                                          Text(names[r]),
                                        ],
                                      ),
                                    )));
                              }
                              return ListTile(
                                  leading: Text(
                                    _city == '' ? names[0] : _city,
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
                                      for (var r = 0; r < names.length; r++) {
                                        if (value == names[r]) {
                                          _city = names[r];
                                          setState(() {
                                            cityon = true;
                                          });
                                        }
                                      }
                                    },
                                    selectedItemBuilder:
                                        (BuildContext context) {
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
                                  ));
                            }),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('category')
                                .snapshots(),
                            builder: (ctx, userSnapshot) {
                              if (userSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: Text(
                                    'Loading...',
                                    style: TextStyle(fontSize: 2),
                                  ),
                                );
                              }
                              final chatDocs = userSnapshot.hasData
                                  ? userSnapshot.data
                                  : null;
                              List names = [];
                              List<Widget> nnn = [];
                              List<DropdownMenuItem> mmm = [];
                              for (var x = 0; x < chatDocs!.docs.length; x++) {
                                names.add(chatDocs.docs[x].data()['name']);
                              }
                              for (var r = 0; r < names.length; r++) {
                                nnn.add(Text(names[r]));
                                mmm.add(DropdownMenuItem(
                                    value: names[r],
                                    child: Container(
                                      child: Row(
                                        children: <Widget>[
                                          const Icon(Icons.category_outlined),
                                          const SizedBox(width: 2),
                                          Text(names[r]),
                                        ],
                                      ),
                                    )));
                              }
                              return ListTile(
                                leading: Text(
                                  _category == '' ? names[0] : _category,
                                  style: TextStyle(
                                      color: caton == false
                                          ? Colors.grey
                                          : Colors.deepPurple),
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
                                      color: caton == false
                                          ? Colors.grey
                                          : Colors.deepPurple),
                                  onChanged: (value) {
                                    for (var r = 0; r < names.length; r++) {
                                      if (value == names[r]) {
                                        _category = names[r];
                                        setState(() {
                                          caton = true;
                                        });
                                      }
                                    }
                                  },
                                  selectedItemBuilder: (BuildContext context) {
                                    return nnn;
                                  },
                                  items: mmm,

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
                              );
                            }),
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
                        //       final chatDocs = userSnapshot.hasData
                        //           ? userSnapshot.data
                        //           : null;
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
                        //       return ListTile(
                        //         leading: Text(
                        //           area ?? '',
                        //           style: TextStyle(
                        //               color: aron == false
                        //                   ? Colors.grey
                        //                   : Colors.deepPurple),
                        //         ),
                        //         trailing: DropdownButton(
                        //           underline: Text(
                        //             'area',
                        //             style: TextStyle(
                        //                 color: aron == false
                        //                     ? Colors.grey
                        //                     : Colors.blueGrey),
                        //           ),
                        //           icon: Icon(Icons.location_on,
                        //               color: aron == false
                        //                   ? Colors.grey
                        //                   : Colors.deepPurple),
                        //           onChanged: (value) {
                        //             for (var r = 0; r < names.length; r++) {
                        //               if (value == names[r]) {
                        //                 area = names[r];
                        //                 setState(() {
                        //                   aron = !aron;
                        //                 });
                        //               }
                        //             }
                        //           },
                        //           selectedItemBuilder: (BuildContext context) {
                        //             return nnn;
                        //           },
                        //           items: mmm,
                        //           // items: [
                        //           //   DropdownMenuItem(
                        //           //     value: 'زيزينيا', //  from data base
                        //           //     child: Container(
                        //           //       child: Row(
                        //           //         children: const <Widget>[
                        //           //           Icon(Icons.location_on),
                        //           //           SizedBox(width: 2),
                        //           //           Text('زيزينيا'),
                        //           //         ],
                        //           //       ),
                        //           //     ),
                        //           //   ),
                        //           // ],
                        //           // onChanged: (value) {
                        //           //   if (value == 'زيزينيا') {
                        //           //     setState(() {
                        //           //       area = 'زيزينيا';

                        //           //       aron = !aron;
                        //           //     });
                        //           //   }
                        //           // },
                        //         ),
                        //         onTap: () {
                        //           setState(() {
                        //             //   area = 'زيزينيا';

                        //             aron = !aron;
                        //           });
                        //         },
                        //       );
                        //     }),
                        const SizedBox(height: 12),
                        (loading)
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    loading = true;
                                  });
                                  _trySubmit();
                                },
                                child: const Text('submit'),
                              ),
                        (loading)
                            ? const CircularProgressIndicator()
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
