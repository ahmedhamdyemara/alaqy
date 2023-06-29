import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alaqy/userChoose.dart';

import 'imagepickerform.dart';

class UpdateUser extends StatefulWidget {
  static const routeName = '/updateuser';

  @override
  _UpdateUserState createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final _controller = new TextEditingController();
  final _controllername = new TextEditingController();
  final userid = FirebaseAuth.instance.currentUser!.uid;

  var _enteredMessage = '';
  var _enteredMessagename = '';
  var _userImageFile;
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
      final userdoc = await FirebaseFirestore.instance
          .collection('customer_details')
          .where('second_uid', isEqualTo: userid)
          .get();
      final docid = userdoc.docs.first.id;
      await FirebaseFirestore.instance
          .collection('customer_details')
          .doc(docid)
          .update({
        'image_url': url,
      });
      final userdocx = await FirebaseFirestore.instance
          .collection('listing')
          .where('userid2', isEqualTo: userid)
          .get();
      if (userdocx.docs.isNotEmpty) {
        //  final List<String> items = [];
        for (var i = 0; i < userdocx.docs.length; i++) {
          //   items.add(userdocx.docs[i]['cattitle']);
          final docidx = userdocx.docs[i].id;
          final chax = await FirebaseFirestore.instance
              .collection('chat')
              .doc(docidx)
              .collection('chatx')
              .get();
          for (var x = 0; x < chax.docs.length; x++) {
            final chaxid = chax.docs[x].id;
            await FirebaseFirestore.instance
                .collection('chat')
                .doc(docidx)
                .collection('chatx')
                .doc(chaxid)
                .update({
              'userimage': url,
            });
          }
        }
      }
      _controller.text = url;
    } else {
      url = '';
    }

    // }
    Navigator.of(context).pushReplacementNamed(UpdateUser.routeName);
  }

  void _sendMessage() async {
    final userdoc = await FirebaseFirestore.instance
        .collection('customer_details')
        .where('second_uid', isEqualTo: userid)
        .get();
    final docid = userdoc.docs.first.id;
//  final cityname = userdoc.docs.first.data()['city'];
//     final categoryname = userdoc.docs.first.data()['category'];
//  final areaname = userdoc.docs.first.data()['area'];
// final citydocs = await FirebaseFirestore.instance
//         .collection('city')
//         .where('name', isEqualTo: cityname)
//         .get();
//     final categorydocs = await FirebaseFirestore.instance
//         .collection('category')
//         .where('name', isEqualTo: categoryname)
//         .get();
// final areadocs = await FirebaseFirestore.instance
//         .collection('area')
//         .where('name', isEqualTo: areaname)
//         .get();
//  final cityid = citydocs.docs.first.id;
//     final categoryid = categorydocs.docs.first.id;
//  final areaid = citydocs.docs.first.id;
//  await FirebaseFirestore.instance
//         .collection('city')
//         .doc(cityid)
//         .collection('listingsInThisCity')
//         .doc(userid)
//         .update({
//       'name': _enteredMessagename.trim(),
//     });
//  await FirebaseFirestore.instance
//         .collection('category')
//         .doc(categoryid)
//         .collection('listingsInThisCategory')
//         .doc(userid)
//         .update({
//       'name': _enteredMessagename.trim(),
//     });
// await FirebaseFirestore.instance
//         .collection('area')
//         .doc(categoryid)
//         .collection('listingsInThisArea')
//         .doc(userid)
//         .update({
//       'name': _enteredMessagename.trim(),
//     });
    FirebaseFirestore.instance
        .collection('customer_details')
        .doc(docid)
        .update({
      'username':
          "${_enteredMessagename.trim().replaceAll(RegExp(r' '), '_')}@alaqy.com",
      'name': _enteredMessagename.trim(),
      'updated': true,
    });
    final userdocc = await FirebaseFirestore.instance
        .collection('business_details')
        .where('second_uid', isEqualTo: userid)
        .get();
    if (userdocc.docs.isNotEmpty) {
      final docidd = userdocc.docs.first.id;
      await FirebaseFirestore.instance
          .collection('business_details')
          .doc(docidd)
          .update({
        'username':
            "${_enteredMessagename.trim().replaceAll(RegExp(r' '), '_')}@alaqy.com",
        'name': _enteredMessagename.trim(),
      });
    }
    final userdocx = await FirebaseFirestore.instance
        .collection('listing')
        .where('userid2', isEqualTo: userid)
        .get();
    if (userdocx.docs.isNotEmpty) {
      //  final List<String> items = [];
      for (var i = 0; i < userdocx.docs.length; i++) {
        //   items.add(userdocx.docs[i]['cattitle']);
        var cityname = userdocx.docs[i].data()['city'];
        var categoryname = userdocx.docs[i].data()['category'];
        var areaname = userdocx.docs[i].data()['area'];
        var citydocs = await FirebaseFirestore.instance
            .collection('city')
            .where('name', isEqualTo: cityname)
            .get();
        var categorydocs = await FirebaseFirestore.instance
            .collection('category')
            .where('name', isEqualTo: categoryname)
            .get();
        var areadocs = await FirebaseFirestore.instance
            .collection('area')
            .where('name', isEqualTo: areaname)
            .get();
        var cityid = citydocs.docs.first.id;
        var categoryid = categorydocs.docs.first.id;
        var areaid = areadocs.docs.first.id;
        FirebaseFirestore.instance
            .collection('city')
            .doc(cityid)
            .collection('listingsInThisCity')
            .doc(userid)
            .update({
          'name': _enteredMessagename.trim(),
        });
        FirebaseFirestore.instance
            .collection('category')
            .doc(categoryid)
            .collection('listingsInThisCategory')
            .doc(userid)
            .update({
          'name': _enteredMessagename.trim(),
        });
        FirebaseFirestore.instance
            .collection('area')
            .doc(areaid)
            .collection('listingsInThisArea')
            .doc(userid)
            .update({
          'name': _enteredMessagename.trim(),
        });
        final docidx = userdocx.docs[i].id;
        FirebaseFirestore.instance.collection('listing').doc(docidx).update({
          'username': _enteredMessagename
              .trim() //.replaceAll(RegExp(r' '), '_')}@alaqy.com",
          // 'name': _enteredMessagename.trim(),
        });
      }
      final userdocx2 = await FirebaseFirestore.instance
          .collection('listdetails')
          .where('userid2', isEqualTo: userid)
          .get();
      if (userdocx2.docs.isNotEmpty) {
        //  final List<String> items = [];
        for (var i = 0; i < userdocx2.docs.length; i++) {
          //   items.add(userdocx.docs[i]['cattitle']);
          final docidx2 = userdocx2.docs[i].id;
          FirebaseFirestore.instance
              .collection('listdetails')
              .doc(docidx2)
              .update({
            'username': _enteredMessagename
                .trim() //.replaceAll(RegExp(r' '), '_')}@alaqy.com",
            // 'name': _enteredMessagename.trim(),
          });
          final chax = await FirebaseFirestore.instance
              .collection('chat')
              .doc(docidx2)
              .collection('chatx')
              .get();
          for (var x = 0; x < chax.docs.length; x++) {
            final chaxid = chax.docs[i].id;
            final chaxstorename = chax.docs[i].data()['store_name'];
            final chaxusername = chax.docs[i].data()['username'];
            final seendoc = await FirebaseFirestore.instance
                .collection('chat')
                .doc(docidx2)
                .collection('chatx')
                .doc('$chaxusername$chaxstorename')
                .get();
            final seendocx = await FirebaseFirestore.instance
                .collection('chat')
                .doc(docidx2)
                .collection('chatx')
                .doc('${chaxusername}bus$chaxstorename')
                .get();
            // seendoc.exists
            //     ? await FirebaseFirestore.instance
            //         .collection('chat')
            //         .doc(docidx2)
            //         .collection('chatx')
            //         .doc('$chaxusername$chaxstorename')
            //         .delete()
            //     : null;
            // seendocx.exists
            //     ? await FirebaseFirestore.instance
            //         .collection('chat')
            //         .doc(docidx2)
            //         .collection('chatx')
            //         .doc('${chaxusername}bus$chaxstorename')
            //         .delete()
            //     : null;
            FirebaseFirestore.instance
                .collection('chat')
                .doc(docidx2)
                .collection('chatx')
                .doc(chaxid)
                .update({
              'username': _enteredMessagename.trim(),
              //  'combo': '${_enteredMessagename.trim()}$chaxstorename'
            });
          }
        }
      }
    }
    FocusScope.of(context).unfocus();
    _controller.clear();

    Navigator.of(context).pushReplacementNamed(UpdateUser.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: const Text('Edit profile'), actions: [
          IconButton(
              onPressed: () =>
                  Navigator.popAndPushNamed(context, userChoose.routeName),
              icon: const Icon(Icons.home)),
        ]),
        body: SingleChildScrollView(
            child: SizedBox(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('customer_details')
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
                      final username = chatdocs.first.data()['username'];

                      return SizedBox(
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
                                        ? 'Please enter a valid username.'
                                        : null;
                                  }
                                  if (value != null) {
                                    return (value.isEmpty || value.length < 4)
                                        ? 'Please enter at least 4 characters'
                                        : null;
                                  }
                                },
                                decoration: const InputDecoration(
                                    labelText: 'update user name'),
                                onChanged: (value) {
                                  setState(() {
                                    _enteredMessagename = value;
                                  });
                                },
                              ),
                            )),
                        Stack(
                          children: [
                            Center(
                                child: TextButton(
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
                                          color:
                                              Color.fromARGB(47, 96, 125, 139),
                                        ),
                                        child: const Text('confirm')),
                                    onPressed: () {
                                      _enteredMessagename.trim().isEmpty
                                          ? null
                                          : showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                title: const Text(
                                                    'updated successfully!'),
                                                content:
                                                    const CircularProgressIndicator(),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: AnimatedTextKit(
                                                      animatedTexts: [
                                                        TyperAnimatedText(
                                                          '',
                                                          textStyle:
                                                              const TextStyle(
                                                            fontSize: 20,
                                                            color: Colors
                                                                .cyanAccent,
                                                            overflow:
                                                                TextOverflow
                                                                    .visible,
                                                          ),
                                                          speed: const Duration(
                                                              seconds: 3),
                                                        )
                                                      ],
                                                      totalRepeatCount: 2,
                                                      // repeatForever: true,
                                                      onNext: (p1, p2) {
                                                        Navigator.of(context)
                                                            .pushReplacementNamed(
                                                                UpdateUser
                                                                    .routeName);
                                                        Navigator.of(ctx)
                                                            .pop(false);
                                                      },
                                                    ),
                                                    onPressed: () {},
                                                  ),
                                                ],
                                              ),
                                            );
                                      _enteredMessagename.trim().isEmpty
                                          ? null
                                          : _sendMessage();
                                    }))
                          ],
                        ),
                        const Center(
                          child: Text(
                              'you can update your user name only one time'),
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
                            totalRepeatCount: 1,
                            onNext: (p0, p1) {
                              setState(() {
                                _controllername.text =
                                    ((username.toString().split('@').first)
                                        .trim()
                                        .replaceAll(RegExp(r'_'), ' '));
                              });
                            }),
                      ]));
                    }))));
  }
}
