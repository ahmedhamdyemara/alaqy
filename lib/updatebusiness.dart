//import 'dart:html';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alaqy/businessChoose.dart';

import 'imagepickerform.dart';

class UpdateBusiness extends StatefulWidget {
  static const routeName = '/updateBusiness';

  @override
  UpdateBusinessState createState() => UpdateBusinessState();
}

class UpdateBusinessState extends State<UpdateBusiness> {
  final _controller = new TextEditingController();
  final _controllername = new TextEditingController();
  final userid = FirebaseAuth.instance.currentUser!.uid;
  bool cityon = false;
  bool caton = false;
  bool aron = false;

  var city;
  var category;
  var area;
  String? stname;
  var _enteredMessage = '';
  var _enteredMessagename = '';
  var _userImageFile;
  var urlx;
  var spin = false;
  void _pickedImage(dynamic image) async {
    _userImageFile = image;
// void _submitAuthForm(
    //   File image,
//  ) async {
    final url;
    if (image != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child('update${DateTime.now()}.jpg');
      await ref.putFile(image).whenComplete(() => image);

      url = await ref.getDownloadURL();
      setState(() {
        urlx = url;
        spin = true;
      });
      // final userdoc = await FirebaseFirestore.instance
      //     .collection('business_details')
      //     .where('second_uid', isEqualTo: userid)
      //     .get();
      // final docid = userdoc.docs.first.id;
      // final storename = userdoc.docs.first.data()['store_name'];
      // final basicstorename = userdoc.docs.first.data()['basicstore_name'];

      // print(docid);
      // print('docid');

      // await FirebaseFirestore.instance
      //     .collection('business_details')
      //     .doc(docid)
      //     .update({
      //   'image_url': url,
      // });

      // final userdocx = await FirebaseFirestore.instance
      //     .collection('listing')
      //     .where(basicstorename)
      //     .get();
      // final opp = userdocx.docs.toList();
      // if (userdocx.docs.isNotEmpty) {
      //   for (var i = 0; i < userdocx.docs.length; i++) {
      //     //   kop.add(opp[i].id);
      //     print('q');
      //     print(opp[i].id);

      //     final chax = await FirebaseFirestore.instance
      //         .collection('chat')
      //         .doc(opp[i].id)
      //         .collection('chatx')
      //         .where('basicstore_name', isEqualTo: basicstorename)
      //         .get();

      //     for (var x = 0; x < chax.docs.length; x++) {
      //       print('qqq');

      //       final col = chax.docs[x].id;
      //       print(col);
      //       await FirebaseFirestore.instance
      //           .collection('chat')
      //           .doc(opp[i].id)
      //           .collection('chatx')
      //           .doc(col)
      //           .update({
      //         'stroeimage': url,
      //       });
      //     }
      //   }
      // }
      _controller.text = url;
    } else {
      url = '';
    }

    // }
  }

  void _sendMessage(String storename) async {
    final userdoc = await FirebaseFirestore.instance
        .collection('business_details')
        .where('second_uid', isEqualTo: userid)
        .get();
    final docid = userdoc.docs.first.id;
    final cityname = userdoc.docs.first.data()['city'];
    final categoryname = userdoc.docs.first.data()['category'];
    final areaname = userdoc.docs.first.data()['area'];

    await FirebaseFirestore.instance
        .collection('business_details')
        .doc(docid)
        .update({
      'store_name': _enteredMessagename.trim(),
      'updated': true,
    });
    final citydocs = await FirebaseFirestore.instance
        .collection('city')
        .where('name', isEqualTo: cityname)
        .get();
    final categorydocs = await FirebaseFirestore.instance
        .collection('category')
        .where('name', isEqualTo: categoryname)
        .get();
    final areaaa = await FirebaseFirestore.instance
        .collection('area')
        .where('name', isEqualTo: areaname)
        .get();
    final areaid = areaaa.docs.first.id;
    final cityid = citydocs.docs.first.id;
    final categoryid = categorydocs.docs.first.id;
    await FirebaseFirestore.instance
        .collection('city')
        .doc(cityid)
        .collection('shopsInThisCity')
        .doc(userid)
        .update({
      'name': _enteredMessagename.trim(),
    });
    await FirebaseFirestore.instance
        .collection('category')
        .doc(categoryid)
        .collection('shopsInThisCategory')
        .doc(userid)
        .update({
      'name': _enteredMessagename.trim(),
    });
    await FirebaseFirestore.instance
        .collection('area')
        .doc(areaid)
        .collection('shopsInThisArea')
        .doc(userid)
        .set({
      'name': _enteredMessagename.trim(),
    });
    final countlisdocsss = await FirebaseFirestore.instance
        .collection('area')
        .doc(areaid)
        .collection('shopsInThisArea')
        .get();
    final countlisss = countlisdocsss.docs.length;
    await FirebaseFirestore.instance
        .collection('area')
        .doc(areaid)
        .update({'shopsInThisArealength': countlisss});

    final userdocx = await FirebaseFirestore.instance
        .collection('listing')
        .where(storename)
        .get();
    final opp = userdocx.docs.toList();
    if (userdocx.docs.isNotEmpty) {
      for (var i = 0; i < userdocx.docs.length; i++) {
        //   kop.add(opp[i].id);
        print('q');
        print(opp[i].id);

        final chax = await FirebaseFirestore.instance
            .collection('chat')
            .doc(opp[i].id)
            .collection('chatx')
            .where('basicstore_name', isEqualTo: storename)
            .get();

        for (var x = 0; x < chax.docs.length; x++) {
          print('qqq');

          final col = chax.docs[x].id;
          print(col);
          await FirebaseFirestore.instance
              .collection('chat')
              .doc(opp[i].id)
              .collection('chatx')
              .doc(col)
              .update({
            'store_name': _enteredMessagename.trim(),
          });
          await FirebaseFirestore.instance
              .collection('chat')
              .doc(opp[i].id)
              .update({
            storename: _enteredMessagename.trim(),
          });
        }
        final comment = await FirebaseFirestore.instance
            .collection('reply_comment')
            .doc(opp[i].id)
            .collection('reply')
            .doc(docid)
            .get();
        comment.exists
            ? await FirebaseFirestore.instance
                .collection('reply_comment')
                .doc(opp[i].id)
                .collection('reply')
                .doc(docid)
                .update({'storename': _enteredMessagename.trim()})
            : null;
      }
    }

    FocusScope.of(context).unfocus();
    _controller.clear();
    Navigator.of(context).pushReplacementNamed(UpdateBusiness.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: const Text('Edit profile'), actions: [
          IconButton(
              onPressed: () => Navigator.of(context)
                  .pushReplacementNamed(businessChoose.routeName),

// Navigator.popAndPushNamed(context, '/'),
              icon: const Icon(Icons.home)),
        ]),
        body: SizedBox(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('business_details')
                    .where('second_uid', isEqualTo: userid)
                    .snapshots(),
                builder: (ctx, chatSnapshottt) {
                  // if (chatSnapshottt.connectionState ==
                  //     ConnectionState.waiting) {
                  //   return const Center(
                  //     child: Text('Loading...'),
                  //   );
                  // }
                  if (chatSnapshottt.hasData == false) {
                    return const Center(child: Text(' Loading...'));
                  }
                  final chatdocs = chatSnapshottt.data!.docs;
                  final imageurl = chatdocs.first.data()['image_url'];
                  final updated = chatdocs.first.data()['updated'];
                  var _city = chatdocs.first.data()['city'];
                  var _category = chatdocs.first.data()['category'];
                  var _cityx = chatdocs.first.data()['city_id'];
                  var _areax = chatdocs.first.data()['area_id'];
                  var _area = chatdocs.first.data()['area'];
                  var _categoryx = chatdocs.first.data()['category_id'];
                  final busid = chatdocs.first.id;
                  var image = urlx ?? imageurl;
                  final storename = chatdocs.first.data()['basicstore_name'];
                  final basicstorename =
                      chatdocs.first.data()['basicstore_name'];
                  final storenamelast = chatdocs.first.data()['store_name'];
                  final docid = chatdocs.first.id;

                  return SingleChildScrollView(
                      child: SizedBox(
                          child: Column(children: [
                    Center(
                      child: updated
                          ? const Text('already updated')
                          : const Text('update'),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    UserImagePickerForm(_pickedImage, imageurl, updated),
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.all(8),
                      child: Expanded(
                        child: TextFormField(
                          readOnly: updated == true ? true : false,
                          controller: _controllername,
                          validator: (value) {
                            if (value != null) {
                              return (value.isEmpty)
                                  ? 'Please enter a valid storename.'
                                  : null;
                            }
                            if (value != null) {
                              return (value.isEmpty || value.length < 4)
                                  ? 'Please enter at least 4 characters'
                                  : null;
                            }
                          },
                          decoration: const InputDecoration(
                              labelText: 'update store name',
                              icon: Icon(Icons.edit)),
                          onChanged: (value) {
                            setState(() {
                              _enteredMessagename = value;
                              spin = true;
                            });
                          },
                        ),
                      ),
                    ),

                    const Center(
                      child:
                          Text('you can update your store name only one time'),
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('city')
                            .snapshots(),
                        builder: (ctx, userSnapshot) {
                          if (userSnapshot.hasData == false) {
                            return const Center(child: Text(' Loading...'));
                          }
                          // if (userSnapshot.connectionState ==
                          //     ConnectionState.waiting) {
                          //   return const Center(
                          //     child: Text(
                          //       'Loading...',
                          //       style: TextStyle(fontSize: 2),
                          //     ),
                          //   );
                          // }
                          final chatDocs =
                              userSnapshot.hasData ? userSnapshot.data : null;
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
                                      const Icon(Icons.location_city_outlined),
                                      const SizedBox(width: 2),
                                      Text(names[r]),
                                    ],
                                  ),
                                )));
                          }
                          return ListTile(
                            leading: Text(
                              city ?? _city ?? names[0],
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
                              onChanged: (value) async {
                                if (!updated) {
                                  for (var r = 0; r < names.length; r++) {
                                    if (value == names[r]) {
                                      city = names[r];
                                      setState(() {
                                        cityon = true;
                                        spin = true;
                                      });
                                    }
                                  }
                                  // final cittt = await FirebaseFirestore.instance
                                  //     .collection('city')
                                  //     .where('name', isEqualTo: city)
                                  //     .get();
                                  // final cityyy = cittt.docs.isEmpty
                                  //     ? _cityx
                                  //     : cittt.docs.first.id;
                                  // FirebaseFirestore.instance
                                  //     .collection('business_details')
                                  //     .doc(busid)
                                  //     .update(
                                  //         {'city': city, 'city_id': cityyy});
                                  // final citydoc = await FirebaseFirestore
                                  //     .instance
                                  //     .collection('city')
                                  //     .where('name', isEqualTo: city)
                                  //     .get();
                                  // final citydocx = await FirebaseFirestore
                                  //     .instance
                                  //     .collection('city')
                                  //     .where('name', isEqualTo: _city)
                                  //     .get();
                                  // final cityid = citydoc.docs.first.id;
                                  // final cityidx = citydocx.docs.first.id;
                                  // await FirebaseFirestore.instance
                                  //     .collection('city')
                                  //     .doc(cityidx)
                                  //     .collection('shopsInThisCity')
                                  //     .doc(userid)
                                  //     .delete();
                                  // await FirebaseFirestore.instance
                                  //     .collection('city')
                                  //     .doc(cityid)
                                  //     .collection('shopsInThisCity')
                                  //     .doc(userid)
                                  //     .set({'shopname': storenamelast});
                                  // final countlisdocs = await FirebaseFirestore
                                  //     .instance
                                  //     .collection('city')
                                  //     .doc(cityid)
                                  //     .collection('shopsInThisCity')
                                  //     .get();
                                  // final countlisdocsx = await FirebaseFirestore
                                  //     .instance
                                  //     .collection('city')
                                  //     .doc(cityidx)
                                  //     .collection('shopsInThisCity')
                                  //     .get();
                                  // final countlis = countlisdocs.docs.length;
                                  // final countlisx = countlisdocsx.docs.length;

                                  // await FirebaseFirestore.instance
                                  //     .collection('city')
                                  //     .doc(cityid)
                                  //     .update(
                                  //         {'shopsinthiscitylength': countlis});
                                  // await FirebaseFirestore.instance
                                  //     .collection('city')
                                  //     .doc(cityidx)
                                  //     .update(
                                  //         {'shopsinthiscitylength': countlisx});
                                } else {
                                  null;
                                }
                              },
                              selectedItemBuilder: (BuildContext context) {
                                return nnn;
                              },
                              items: mmm,
                            ),
                            onTap: () {},
                          );
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
                          final chatDocs =
                              userSnapshot.hasData ? userSnapshot.data : null;
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
                              category ?? _category ?? names[0],
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
                              onChanged: (value) async {
                                if (!updated) {
                                  for (var r = 0; r < names.length; r++) {
                                    if (value == names[r]) {
                                      category = names[r];
                                      setState(() {
                                        caton = true;
                                        spin = true;
                                      });
                                    }
                                  }
                                  // final cattt = await FirebaseFirestore.instance
                                  //     .collection('category')
                                  //     .where('name', isEqualTo: category)
                                  //     .get();
                                  // final catyyy = cattt.docs.isEmpty
                                  //     ? _category
                                  //     : cattt.docs.first.id;
                                  // FirebaseFirestore.instance
                                  //     .collection('business_details')
                                  //     .doc(busid)
                                  //     .update({
                                  //   'category_id': catyyy,
                                  //   'category': category
                                  // });
                                  // final catdoc = await FirebaseFirestore
                                  //     .instance
                                  //     .collection('category')
                                  //     .where('name', isEqualTo: category)
                                  //     .get();
                                  // final catdocx = await FirebaseFirestore
                                  //     .instance
                                  //     .collection('category')
                                  //     .where('name', isEqualTo: _categoryx)
                                  //     .get();
                                  // final catid = catdoc.docs.first.id;
                                  // final catidx = catdocx.docs.first.id;
                                  // await FirebaseFirestore.instance
                                  //     .collection('category')
                                  //     .doc(catidx)
                                  //     .collection('shopsInThisCategory')
                                  //     .doc(userid)
                                  //     .delete();
                                  // await FirebaseFirestore.instance
                                  //     .collection('category')
                                  //     .doc(catid)
                                  //     .collection('shopsInThisCategory')
                                  //     .doc(userid)
                                  //     .set({'name': storenamelast});

                                  // final countlisdocss = await FirebaseFirestore
                                  //     .instance
                                  //     .collection('category')
                                  //     .doc(catid)
                                  //     .collection('shopsInThisCategory')
                                  //     .get();
                                  // final countlisdocssx = await FirebaseFirestore
                                  //     .instance
                                  //     .collection('category')
                                  //     .doc(catidx)
                                  //     .collection('shopsInThisCategory')
                                  //     .get();
                                  // final countliss = countlisdocss.docs.length;
                                  // final countlissx = countlisdocssx.docs.length;
                                  // await FirebaseFirestore.instance
                                  //     .collection('category')
                                  //     .doc(catidx)
                                  //     .update({
                                  //   'shopsInThisCategorylength': countlissx
                                  // });
                                  // await FirebaseFirestore.instance
                                  //     .collection('category')
                                  //     .doc(catid)
                                  //     .update({
                                  //   'shopsInThisCategorylength': countliss
                                  // });
                                } else {
                                  null;
                                }
                              },
                              selectedItemBuilder: (BuildContext context) {
                                return nnn;
                              },
                              items: mmm,
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
                    //       return ListTile(
                    //         leading: Text(
                    //           area ?? _area ?? '',
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
                    //             if (!updated) {
                    //               for (var r = 0; r < names.length; r++) {
                    //                 if (value == names[r]) {
                    //                   area = names[r];
                    //                   setState(() {
                    //                     aron = !aron;
                    //                   });
                    //                 }
                    //               }
                    //             } else {
                    //               null;
                    //             }
                    //           },
                    //           selectedItemBuilder: (BuildContext context) {
                    //             return nnn;
                    //           },
                    //           items: mmm,

                    //         ),
                    //         onTap: () {
                    //           !updated
                    //               ? setState(() {
                    //                   //   area = 'زيزينيا';

                    //                   aron = !aron;
                    //                 })
                    //               : null;
                    //         },
                    //       );
                    //     }),
                    //////////////////////////////////////// // ListTile(
                    //   leading: Text(
                    //     _city == '' ? 'الاسكندرية' : _city,
                    //     style: TextStyle(
                    //         color: cityon == false
                    //             ? Colors.grey
                    //             : Colors.deepPurple),
                    //   ),
                    //   title: DropdownButton(
                    //     underline: Text(
                    //       'city',
                    //       style: TextStyle(
                    //           color: cityon == false
                    //               ? Colors.grey
                    //               : Colors.amberAccent),
                    //     ),
                    //     icon: Icon(Icons.location_city_outlined,
                    //         color: cityon == false
                    //             ? Colors.grey
                    //             : Colors.deepPurple),
                    //     items: [
                    //       DropdownMenuItem(
                    //         value: 'الاسكندرية',
                    //         child: Container(
                    //           child: Row(
                    //             children: const <Widget>[
                    //               Icon(Icons.location_city_outlined),
                    //               SizedBox(width: 2),
                    //               Text('الاسكندرية'),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //     onChanged: (value) async {
                    //       if (value == 'الاسكندرية') {
                    //         _city = "الاسكندرية";
                    //         setState(() {
                    //           cityon = !cityon;
                    //         });
                    ////////////////////////////////////////       }
//  final img = await FirebaseFirestore.instance
//         .collection('listing')
//         .doc(widget.listid.toString())
//         .get();
//     final jpg = img.data()!['image_url'];
//     final titlex = img.data()!['title'];
//     final descriptionx = img.data()!['description'];
//     final cityx = img.data()!['city'];
//     final areax = img.data()!['area'];
//     final categoryx = img.data()!['category'];
//     print(city);
//     print(cityx);
//     print(area);
//     print(areax);
//     print(category);
//     print(categoryx);
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('area')
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
                          final chatDocs =
                              userSnapshot.hasData ? userSnapshot.data : null;
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
                                      const Icon(Icons.location_on),
                                      const SizedBox(width: 2),
                                      Text(names[r]),
                                    ],
                                  ),
                                )));
                          }
                          return ListTile(
                            leading: Text(
                              area ?? _area,
                              style: TextStyle(
                                  color: aron == false
                                      ? Colors.grey
                                      : Colors.deepPurple),
                            ),
                            trailing: DropdownButton(
                              underline: Text(
                                'area',
                                style: TextStyle(
                                    color: aron == false
                                        ? Colors.grey
                                        : Colors.blueGrey),
                              ),
                              icon: Icon(Icons.location_on,
                                  color: aron == false
                                      ? Colors.grey
                                      : Colors.deepPurple),
                              onChanged: (value) {
                                if (!updated) {
                                  for (var r = 0; r < names.length; r++) {
                                    if (value == names[r]) {
                                      area = names[r];
                                      setState(() {
                                        aron = true;
                                        spin = true;
                                      });
                                    }
                                  }
                                } else {
                                  null;
                                }
                              },
                              selectedItemBuilder: (BuildContext context) {
                                return nnn;
                              },
                              items: mmm,
                            ),
                            onTap: () {
                              // setState(() {
                              //   //   area = 'زيزينيا';

                              //   aron = !aron;
                              // });
                            },
                          );
                        }),
                    TextButton(
                        onPressed: () async {
                          if (spin == true) {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('updated successfully!'),
                                content: const CircularProgressIndicator(),
                                actions: <Widget>[
                                  TextButton(
                                    child: AnimatedTextKit(
                                      animatedTexts: [
                                        TyperAnimatedText(
                                          '',
                                          textStyle: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.cyanAccent,
                                            overflow: TextOverflow.visible,
                                          ),
                                          speed: const Duration(seconds: 3),
                                        )
                                      ],
                                      totalRepeatCount: 2,
                                      // repeatForever: true,
                                      onNext: (p1, p2) {
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                UpdateBusiness.routeName);
                                        Navigator.of(ctx).pop(false);
                                      },
                                    ),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            );
                            _enteredMessagename.trim().isEmpty
                                ? null
                                : _sendMessage(storename);
                            await FirebaseFirestore.instance
                                .collection('business_details')
                                .doc(docid)
                                .update({
                              'image_url': image,
                              'updated': true,
                            });

                            final userdocx = await FirebaseFirestore.instance
                                .collection('listing')
                                .where(basicstorename)
                                .get();
                            final opp = userdocx.docs.toList();
                            if (userdocx.docs.isNotEmpty) {
                              for (var i = 0; i < userdocx.docs.length; i++) {
                                //   kop.add(opp[i].id);
                                print('q');
                                print(opp[i].id);

                                final chax = await FirebaseFirestore.instance
                                    .collection('chat')
                                    .doc(opp[i].id)
                                    .collection('chatx')
                                    .where('basicstore_name',
                                        isEqualTo: basicstorename)
                                    .get();

                                for (var x = 0; x < chax.docs.length; x++) {
                                  print('qqq');

                                  final col = chax.docs[x].id;
                                  print(col);
                                  await FirebaseFirestore.instance
                                      .collection('chat')
                                      .doc(opp[i].id)
                                      .collection('chatx')
                                      .doc(col)
                                      .update({
                                    'stroeimage': image,
                                  });
                                }
                              }
                            }
                            final cattt = await FirebaseFirestore.instance
                                .collection('category')
                                .where('name', isEqualTo: category)
                                .get();
                            final catyyy = cattt.docs.isEmpty
                                ? _category
                                : cattt.docs.first.id;
                            final categoryzz = category ?? _category;
                            final cityzz = city ?? _city;
                            final areazz = area ?? _area;
                            FirebaseFirestore.instance
                                .collection('business_details')
                                .doc(busid)
                                .update({
                              'category_id': catyyy,
                              'category': categoryzz
                            });

                            final cittt = await FirebaseFirestore.instance
                                .collection('city')
                                .where('name', isEqualTo: city)
                                .get();
                            final cityyy = cittt.docs.isEmpty
                                ? _cityx
                                : cittt.docs.first.id;
                            FirebaseFirestore.instance
                                .collection('business_details')
                                .doc(busid)
                                .update({'city': cityzz, 'city_id': cityyy});
                            final citydoc = await FirebaseFirestore.instance
                                .collection('city')
                                .where('name', isEqualTo: city)
                                .get();
                            final citydocx = await FirebaseFirestore.instance
                                .collection('city')
                                .where('name', isEqualTo: _city)
                                .get();
                            final cityid = citydoc.docs.first.id;
                            final cityidx = citydocx.docs.first.id;
                            await FirebaseFirestore.instance
                                .collection('city')
                                .doc(cityidx)
                                .collection('shopsInThisCity')
                                .doc(userid)
                                .delete();
                            await FirebaseFirestore.instance
                                .collection('city')
                                .doc(cityid)
                                .collection('shopsInThisCity')
                                .doc(userid)
                                .set({'shopname': storenamelast});
                            final countlisdocs = await FirebaseFirestore
                                .instance
                                .collection('city')
                                .doc(cityid)
                                .collection('shopsInThisCity')
                                .get();
                            final countlisdocsx = await FirebaseFirestore
                                .instance
                                .collection('city')
                                .doc(cityidx)
                                .collection('shopsInThisCity')
                                .get();
                            final countlis = countlisdocs.docs.length;
                            final countlisx = countlisdocsx.docs.length;

                            await FirebaseFirestore.instance
                                .collection('city')
                                .doc(cityid)
                                .update({'shopsinthiscitylength': countlis});
                            await FirebaseFirestore.instance
                                .collection('city')
                                .doc(cityidx)
                                .update({'shopsinthiscitylength': countlisx});
                            final catdoc = await FirebaseFirestore.instance
                                .collection('category')
                                .where('name', isEqualTo: category)
                                .get();
                            final catdocx = await FirebaseFirestore.instance
                                .collection('category')
                                .where('name', isEqualTo: _categoryx)
                                .get();
                            final areaaa = await FirebaseFirestore.instance
                                .collection('area')
                                .where('name', isEqualTo: area)
                                .get();
                            final areaxxx = cittt.docs.isEmpty
                                ? _areax
                                : areaaa.docs.first.id;
                            FirebaseFirestore.instance
                                .collection('business_details')
                                .doc(busid)
                                .update({'area': areazz, 'area_id': areaxxx});
                            final areadoc = await FirebaseFirestore.instance
                                .collection('area')
                                .where('name', isEqualTo: area)
                                .get();
                            final areadocx = await FirebaseFirestore.instance
                                .collection('area')
                                .where('name', isEqualTo: _area)
                                .get();
                            final areaid = areadoc.docs.first.id;
                            final areaidx = areadocx.docs.first.id;
                            await FirebaseFirestore.instance
                                .collection('area')
                                .doc(areaidx)
                                .collection('shopsInThisArea')
                                .doc(userid)
                                .delete();
                            await FirebaseFirestore.instance
                                .collection('area')
                                .doc(areaid)
                                .collection('shopsInThisArea')
                                .doc(userid)
                                .set({'shopname': storenamelast});
                            final countlisdocsarea = await FirebaseFirestore
                                .instance
                                .collection('area')
                                .doc(areaid)
                                .collection('shopsInThisArea')
                                .get();
                            final countlisdocsxarea = await FirebaseFirestore
                                .instance
                                .collection('area')
                                .doc(areaidx)
                                .collection('shopsInThisArea')
                                .get();
                            final countlisarea = countlisdocsarea.docs.length;
                            final countlisxarea = countlisdocsxarea.docs.length;

                            await FirebaseFirestore.instance
                                .collection('area')
                                .doc(areaid)
                                .update(
                                    {'shopsinthisarealength': countlisarea});
                            await FirebaseFirestore.instance
                                .collection('area')
                                .doc(areaidx)
                                .update(
                                    {'shopsinthisarealength': countlisxarea});
                            final catid = catdoc.docs.first.id;
                            final catidx = catdocx.docs.first.id;
                            await FirebaseFirestore.instance
                                .collection('category')
                                .doc(catidx)
                                .collection('shopsInThisCategory')
                                .doc(userid)
                                .delete();
                            await FirebaseFirestore.instance
                                .collection('category')
                                .doc(catid)
                                .collection('shopsInThisCategory')
                                .doc(userid)
                                .set({'name': storenamelast});

                            final countlisdocss = await FirebaseFirestore
                                .instance
                                .collection('category')
                                .doc(catid)
                                .collection('shopsInThisCategory')
                                .get();
                            final countlisdocssx = await FirebaseFirestore
                                .instance
                                .collection('category')
                                .doc(catidx)
                                .collection('shopsInThisCategory')
                                .get();
                            final countliss = countlisdocss.docs.length;
                            final countlissx = countlisdocssx.docs.length;
                            await FirebaseFirestore.instance
                                .collection('category')
                                .doc(catidx)
                                .update(
                                    {'shopsInThisCategorylength': countlissx});
                            await FirebaseFirestore.instance
                                .collection('category')
                                .doc(catid)
                                .update(
                                    {'shopsInThisCategorylength': countliss});
                          }
                        },
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 9,
                              horizontal: 9,
                            ),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12)),
                              color: Color.fromARGB(47, 96, 125, 139),
                            ),
                            child: const Text('confirm'))),
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
                          setState(() {
                            _controllername.text = storenamelast;
                          });
                          print(storenamelast);
                        }),
                  ])));
                })));
  }
}
