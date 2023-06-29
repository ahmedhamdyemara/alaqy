import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alaqy/alaqyform.dart';

class AlaaqyProcess extends StatefulWidget {
  static const routeName = '/AlaaqyProcess';

  @override
  State<AlaaqyProcess> createState() => _AlaaqyProcessState();
}

class _AlaaqyProcessState extends State<AlaaqyProcess> {
  bool isLoading = false;
  dynamic idz;
  dynamic idzcity;
//  dynamic idzarea;
  dynamic idzcategory;
  final userx = FirebaseAuth.instance.currentUser!.uid;
  void _selectPage() async {
    print(userx);

    final newidea = await FirebaseFirestore.instance
        .collection('listing')
        .where('userid2', isEqualTo: userx)
        .where('closed', isEqualTo: false)
        .get();
    List seens = [];
    List sents = [];

    for (var x = 0; x < newidea.docs.length; x++) {
      sents.add(newidea.docs[x].data()['sent']);
      seens.add(newidea.docs[x].data()['seen']);
    }
    const initialValue = 0.0;

    final seensx = seens.fold(
        initialValue, (previousValue, element) => previousValue + element);
    final sentsx = sents.fold(
        initialValue, (previousValue, element) => previousValue + element);
    final seezz = int.tryParse(seensx.toString());
    final useri = await FirebaseFirestore.instance
        .collection('customer_details')
        .where('second_uid', isEqualTo: userx)
        .get();
    //  print(userx);
    final idx = useri.docs.first.id;
    final sen = useri.docs.first.data()['sent'];
    FirebaseFirestore.instance
        .collection('customer_details')
        .doc(idx)
        .update({'seen': seensx, 'sent': sentsx});
  }

  void _submitAuthForm(
    String title,
    String description,
    String category,
    String city,
    //  String area,
    dynamic image,
  ) async {
    final url;
    final userid = FirebaseAuth.instance.currentUser!.uid;

    print(userid);
    final userdoc = await FirebaseFirestore.instance
        .collection('customer_details')
        .where('second_uid', isEqualTo: userid)
        .get();
    final docid = userdoc.docs.first.id;
    final usernamex = userdoc.docs.first.data()['username'];
    final basicusernamex = userdoc.docs.first.data()['basicemail'];

    final username = usernamex.toString().split('@').first;
    final basicusername = basicusernamex.toString().split('@').first;

    const useriamge =
        'https://firebasestorage.googleapis.com/v0/b/alaqy-64208.appspot.com/o/user_image%2FHI7A9RLmLTVnUn4UxqjAM92Gcwc2.jpg?alt=media&token=a4b20826-9003-4538-b1a5-41b3b1245169';
    setState(() {
      isLoading = true;
    });

    final getlength = await FirebaseFirestore.instance
        .collection('listing')
        .orderBy(
          'createdAt',
        )
        .get();
    var length = getlength.docs.length;

    final indexx = getlength.docs.length;
    print(indexx);
    setState(() {
      idz = indexx + 1;
    });

    if (image != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child('listing$idz.jpg');
      await ref.putFile(image).whenComplete(() => image);

      url = await ref.getDownloadURL();
    } else {
      url = '';
    }
    final cittt = await FirebaseFirestore.instance
        .collection('city')
        .where('name', isEqualTo: city)
        .get();
    final cityyy = cittt.docs.isEmpty ? '1' : cittt.docs.first.id;
    final cattt = await FirebaseFirestore.instance
        .collection('category')
        .where('name', isEqualTo: category)
        .get();
    final catyyy = cattt.docs.isEmpty ? '1' : cattt.docs.first.id;
    // final areaaa = await FirebaseFirestore.instance
    //     .collection('area')
    //     .where('name', isEqualTo: area)
    //     .get();
    // final areooo = areaaa.docs.first.id;
    await FirebaseFirestore.instance
        .collection('listing')
        .doc(idz.toString())
        .set({
      'id': idz,
      'idstring': idz.toString(),
      'userid2': userid,
      'userid': docid,
      'title': title,
      'description': description,
      'createdAt': Timestamp.now(),
      'city': city == '' ? 'الاسكندرية' : city,
      'city_id': cityyy,
      'category_id': catyyy,
      // 'area_id': areooo,
      // 'area': area,
      'username': username,
      'basicemail': basicusername,

      'category': category == '' ? 'ادوات المطبخ' : category,
      'image_url': url == ''
          ? 'https://firebasestorage.googleapis.com/v0/b/alaqy-64208.appspot.com/o/user_image%2FHI7A9RLmLTVnUn4UxqjAM92Gcwc2.jpg?alt=media&token=a4b20826-9003-4538-b1a5-41b3b1245169'
          : url,
      'userimage': useriamge,
      'messages': 0,
      'messages_seen': 0,
      'seen': 0,
      'storesidz': ['djxHD4FJea09n3KBYkoT'],
      'storesi': 0,
      'sent': 0,
      // 'orders': 0,
      //  'map': 0,
      'state': 'online',
      'closed': false,
      'total close': false,
      'updated': false,

      //  'news': 'New',
      //       'nationality': '',
//'city': '',
//'street': '',
    });
    await FirebaseFirestore.instance
        .collection('listdetails')
        .doc(idz.toString())
        .set({
      'id': idz,
      'userid2': userid,
      'userid': docid,
      'title': title,
      'description': description,
      'createdAt': Timestamp.now(),
      'city': city == '' ? 'الاسكندرية' : city,
      'city_id': cityyy,
      'category_id': catyyy,
      // 'area_id': areooo,
      // 'area': area,
      'closed': false,
      'total close': false,
      'username': username,
      'basicemail': basicusername,
      'category': category == '' ? 'ادوات المطبخ' : category,
      'image_url': url == ''
          ? 'https://firebasestorage.googleapis.com/v0/b/alaqy-64208.appspot.com/o/user_image%2FHI7A9RLmLTVnUn4UxqjAM92Gcwc2.jpg?alt=media&token=a4b20826-9003-4538-b1a5-41b3b1245169'
          : url,
      'updated': false,
    });
    final busstart = await FirebaseFirestore.instance
        .collection('business_details')
        .where('city', isEqualTo: city)
        .where('category', isEqualTo: category)
        .get();
    final List<String> items = [];
    for (var i = 0; i < busstart.docs.length; i++) {
      items.add(busstart.docs[i].id);
    }
    final List<DocumentSnapshot<Map<String, dynamic>>> sentx = [];
    final List<int> sent = [];

    for (var x = 0; x < items.length; x++) {
      sentx.add(await FirebaseFirestore.instance
          .collection('business_details')
          .doc(items[x])
          .get());
    }
    for (var y = 0; y < items.length; y++) {
      sent.add(sentx[y].data()!['sent']);
    }
    for (var z = 0; z < items.length; z++) {
      await FirebaseFirestore.instance
          .collection('business_details')
          .doc(items[z])
          .update({'sent': sent[z] + 1});
    }
    for (var k = 0; k < items.length; k++) {
      FirebaseFirestore.instance.collection('notify').add({
        'customerid': userid,
        'businessid': items[k],
        'listid': idz,
        'createdAt': Timestamp.now(),
        'to$userid': false,
        'to${items[k]}': true,
        'text': title,
        'target': items[k],
        'store_name': username
      });
    }
    if (city != '') {
      final citydoc = await FirebaseFirestore.instance
          .collection('city')
          .where('name', isEqualTo: city)
          .get();
      final cityid = citydoc.docs.isEmpty ? '1' : citydoc.docs.first.id;
      await FirebaseFirestore.instance
          .collection('city')
          .doc(cityid)
          .collection('listingsInThisCity')
          .doc(idz.toString())
          .set({'id': userid});
      final countlisdocs = await FirebaseFirestore.instance
          .collection('city')
          .doc(cityid)
          .collection('listingsInThisCity')
          .get();
      final countlis = countlisdocs.docs.length;
      await FirebaseFirestore.instance
          .collection('city')
          .doc(cityid)
          .update({'listinginthiscitylength': countlis});
    }
    if (category != '') {
      final catdoc = await FirebaseFirestore.instance
          .collection('category')
          .where('name', isEqualTo: category)
          .get();
      final catid = catdoc.docs.isEmpty ? '1' : catdoc.docs.first.id;
      await FirebaseFirestore.instance
          .collection('category')
          .doc(catid)
          .collection('listingsInThisCategory')
          .doc(idz.toString())
          .set({'id': userid});
      final countlisdocss = await FirebaseFirestore.instance
          .collection('category')
          .doc(catid)
          .collection('listingsInThisCategory')
          .get();
      final countliss = countlisdocss.docs.length;
      await FirebaseFirestore.instance
          .collection('category')
          .doc(catid)
          .update({'listingsInThisCategorylength': countliss});
    }
    // final areadoc = await FirebaseFirestore.instance
    //     .collection('area')
    //     .where('name', isEqualTo: area)
    //     .get();
    // final areaid = areadoc.docs.first.id;
    // await FirebaseFirestore.instance
    //     .collection('area')
    //     .doc(areaid)
    //     .collection('listingsInThisArea')
    //     .doc(idz.toString())
    //     .set({'id': userid});
    // final countlisdocsss = await FirebaseFirestore.instance
    //     .collection('area')
    //     .doc(areaid)
    //     .collection('listingsInThisarea')
    //     .get();
    // final countlisss = countlisdocsss.docs.length;
    // await FirebaseFirestore.instance
    //     .collection('area')
    //     .doc(areaid)
    //     .update({'listingsInThisarealength': countlisss});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              alaqyForm(_submitAuthForm, isLoading),
              AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    '                                                     ',
                    textStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.cyanAccent,
                      overflow: TextOverflow.visible,
                    ),
                    speed: const Duration(seconds: 5),
                  )
                ],
                // totalRepeatCount: 2,
                repeatForever: true,
                onNext: (p0, p1) {
                  _selectPage();
                },
              ),
            ])),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.messenger_outline_rounded),
        ));
  }
}
