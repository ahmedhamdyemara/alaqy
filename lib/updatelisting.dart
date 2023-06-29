import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'updatelistingform.dart';

class UpdateListing extends StatefulWidget {
  static const routeName = '/UserImagePicker';

  const UpdateListing(this.listid);

  final dynamic listid;

  @override
  UpdateListingState createState() => UpdateListingState();
}

class UpdateListingState extends State<UpdateListing> {
  final _controller = new TextEditingController();
  final _controllername = new TextEditingController();
  final userid = FirebaseAuth.instance.currentUser!.uid;
  bool isLoading = false;
  dynamic idz;
  dynamic idzcity;
  // dynamic idzarea;
  dynamic idzcategory;

  var _enteredMessage = '';
  var _enteredMessagename = '';
  var _userImageFile;
  final userx = FirebaseAuth.instance.currentUser!.uid;

  // void foundsentseen(List items) async {
  //   List<DocumentSnapshot<Map<String, dynamic>>> useri = [];
  //   List<int> foundsentsx = [];
  //   List<int> foundseenx = [];
  //   for (var z = 0; z < items.length; z++) {
  //     var vbn = await FirebaseFirestore.instance
  //         .collection('business_details')
  //         .doc(items[z])
  //         .collection('mylistsx')
  //         .doc(widget.listid)
  //         .get();
  //     if (vbn.exists) {
  //       var userii = await FirebaseFirestore.instance
  //           .collection('business_details')
  //           .doc(items[z])
  //           .get();
  //       var sent = useri[z].data()!['foundsent'];
  //       var seen = useri[z].data()!['foundseen'];

  //       var upnum = useri[z].data()!['upnum'];
  //       var upnumseen = useri[z].data()!['upnumseen'];
  //       FirebaseFirestore.instance
  //           .collection('business_details')
  //           .doc(items[z])
  //           .update({'upnum': upnum + 1});
  //     }
  //     var userii = await FirebaseFirestore.instance
  //         .collection('business_details')
  //         .doc(items[z])
  //         .get();
  //     useri.add(userii);
  //     // final idx = useri.docs.first.id;
  //     final sent = useri[z].data()!['foundsent'];
  //     final seen = useri[z].data()!['foundseen'];

  //     final upnum = useri[z].data()!['upnum'];
  //     final upnumseen = useri[z].data()!['upnumseen'];

  //     final storenameb = useri[z].data()!['basicstore_name'];
  //     final listcont =
  //         await FirebaseFirestore.instance.collection('listing').get();

  //     // print(listcont.docs.length);
  //     // print(storenameb);
  //     foundsentsx.add(upnum);
  //     foundseenx.add(upnumseen);
  //     for (var z = 0; z < listcont.docs.length; z++) {
  //       if (listcont.docs[z].data().containsKey(storenameb)) {
  //         if (listcont.docs[z].data()[storenameb] == 'on') {
  //           foundsentsx.add(listcont.docs[z]
  //               .data()['post_owner_reply_to_business$storenameb']);
  //           foundseenx.add(listcont.docs[z]
  //               .data()['post_owner_seen_by_business$storenameb']);
  //           print('mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm$foundsentsx');
  //           print(foundseenx);
  //           print(seen);
  //           print(sent);
  //         }
  //       }
  //     }
  //     final mustaddedsent = foundsentsx.fold(
  //         0, (previousValue, element) => previousValue + element);
  //     final mustaddedseen = foundseenx.fold(
  //         0, (previousValue, element) => previousValue + element);

  //     FirebaseFirestore.instance
  //         .collection('business_details')
  //         .doc(items[z])
  //         .update({'foundsent': mustaddedsent, 'foundseen': mustaddedseen});
  //     final nameandtitle = await FirebaseFirestore.instance
  //         .collection('listing')
  //         .doc(widget.listid.toString())
  //         .get();
  //     final title = nameandtitle.data()!['title'];
  //     final name = nameandtitle.data()!['username'];

  //     final notifytest = await FirebaseFirestore.instance
  //         .collection('business_details')
  //         .doc(items[z])
  //         .collection('mylistsx')
  //         .doc(widget.listid.toString())
  //         .get();
  //     notifytest.exists
  //         ?
//FirebaseFirestore.instance.collection('notify').add({
  //             'customerid': userid,
  //             'businessid': items[z],
  //             'listid': idz,
  //             'createdAt': Timestamp.now(),
  //             'to$userid': false,
  //             'to${items[z]}': true,
  //             'text': title,
  //             'target': items[z],
  //             'store_name': name
  //           })
  //         : null;
  //   }
  // }

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

    // print(userid);
    final userdoc = await FirebaseFirestore.instance
        .collection('customer_details')
        .where('second_uid', isEqualTo: userid)
        .get();
    final docid = userdoc.docs.first.id;
    final usernamex = userdoc.docs.first.data()['username'];
    final username = usernamex.toString().split('@').first;
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
    //  print(indexx);
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
    final img = await FirebaseFirestore.instance
        .collection('listing')
        .doc(widget.listid.toString())
        .get();
    final jpg = img.data()!['image_url'];
    final titlex = img.data()!['title'];
    final descriptionx = img.data()!['description'];
    final cityxx = img.data()!['city_id'];
    //   final areaxx = img.data()!['area_id'];
    final categoryxx = img.data()!['category_id'];
    final cityx = img.data()!['city'];
//   final areax = img.data()!['area'];
    final categoryx = img.data()!['category'];
    // print(city);
    // print(cityx);
    // print(area);
    // print(areax);
    // print(category);
    // print(categoryx);

    final cittt = await FirebaseFirestore.instance
        .collection('city')
        .where('name', isEqualTo: city)
        .get();
    final cattt = await FirebaseFirestore.instance
        .collection('category')
        .where('name', isEqualTo: category)
        .get();

    // final areaaa = await FirebaseFirestore.instance
    //     .collection('area')
    //     .where('name', isEqualTo: area)
    //     .get();
    // final areooo = areaaa.docs.isEmpty ? areaxx : areaaa.docs.first.id;
    final cityyy = cittt.docs.isEmpty ? cityxx : cittt.docs.first.id;
    final catyyy = cattt.docs.isEmpty ? categoryxx : cattt.docs.first.id;
    await FirebaseFirestore.instance
        .collection('listing')
        .doc(widget.listid.toString())
        .update({
      'title': title == '' ? titlex : title,
      'description': description == '' ? descriptionx : description,
      'city': city == '' ? cityx : city,
      //  'area': area == '' ? areax : area,
      'city_id': cityyy,
      'category_id': catyyy,
      //   'area_id': areooo,
      'category': category == '' ? categoryx : category,
      'image_url': url == '' ? jpg : url,
      'updated': true,
    });
    final listdocget = await FirebaseFirestore.instance
        .collection('listdetails')
        .doc(widget.listid.toString())
        .get();
    final firstiduser = listdocget.data()!['userid'];
    final name = listdocget.data()!['username'];

    await FirebaseFirestore.instance
        .collection('listdetails')
        .doc(widget.listid.toString())
        .update({
      'title': title == '' ? titlex : title,
      'description': description == '' ? descriptionx : description,
      'city': city == '' ? cityx : city,
      //    'area': area == '' ? areax : area,
      'category': category == '' ? categoryx : category,
      'city_id': cityyy,
      'category_id': catyyy,
      //     'area_id': areooo,
      'image_url': url == '' ? jpg : url,
      'updated': true,
    });
    final busstartx = await FirebaseFirestore.instance
        .collection('business_details')
        .where('city', isEqualTo: city)
        .where('category', isEqualTo: category)
        .get();
    final List<String> itemsx = [];
    for (var i = 0; i < busstartx.docs.length; i++) {
      itemsx.add(busstartx.docs[i].id);
    }
    final List<DocumentSnapshot<Map<String, dynamic>>> sentx = [];
    final List<int> sent = [];

    for (var x = 0; x < itemsx.length; x++) {
      sentx.add(await FirebaseFirestore.instance
          .collection('business_details')
          .doc(itemsx[x])
          .get());
    }
    for (var y = 0; y < itemsx.length; y++) {
      sent.add(sentx[y].data()!['sent']);
    }
    for (var z = 0; z < itemsx.length; z++) {
      await FirebaseFirestore.instance
          .collection('business_details')
          .doc(itemsx[z])
          .update({'sent': sent[z] + 1});
    }
    for (var k = 0; k < itemsx.length; k++) {
      FirebaseFirestore.instance.collection('notify').add({
        'customerid': userid,
        'businessid': itemsx[k],
        'listid': idz,
        'createdAt': Timestamp.now(),
        'to$userid': false,
        'to${itemsx[k]}': true,
        'text': title,
        'target': itemsx[k],
        'store_name': username
      });
    }
    final busstart = await FirebaseFirestore.instance
        .collection('business_details')
        // .where('city', isEqualTo: city)
        // .where('category', isEqualTo: category)
        .get();
    final List<String> items = [];
    for (var i = 0; i < busstart.docs.length; i++) {
      if (busstart.docs[i].id != 'djxHD4FJea09n3KBYkoT') {
        items.add(busstart.docs[i].id);
      }
    }
    for (var z = 0; z < items.length; z++) {
      var vbn = await FirebaseFirestore.instance
          .collection('business_details')
          .doc(items[z])
          .collection('mylistsx')
          .doc(widget.listid)
          .get();

      if (vbn.exists) {
        print('vbn');
        FirebaseFirestore.instance
            .collection('business_details')
            .doc(vbn.data()!['id'])
            .collection('mylistsx')
            .doc(widget.listid)
            .update({widget.listid: true});
        FirebaseFirestore.instance
            .collection('business_details')
            .doc(vbn.data()!['id'])
            .collection('mylists')
            .doc(firstiduser)
            .update({'${widget.listid}${firstiduser}update': true});
        print(vbn.data()!['id']);
        var userii = await FirebaseFirestore.instance
            .collection('business_details')
            .doc(vbn.data()!['id'])
            .get();
        // var sent = userii[z].data()!['foundsent'];
        // var seen = userii[z].data()!['foundseen'];

        var upnum = userii.data()!['upnum'];
        var basicstore_name = userii.data()!['basicstore_name'];

        //     var upnumseen = userii[z].data()!['upnumseen'];
        FirebaseFirestore.instance
            .collection('business_details')
            .doc(vbn.data()!['id'])
            .update({'upnum': upnum + 1, '${basicstore_name}close': false});
        FirebaseFirestore.instance.collection('notify').add({
          'customerid': userid,
          'businessid': vbn.data()!['id'],
          'listid': idz,
          'createdAt': Timestamp.now(),
          'to$userid': false,
          'to${vbn.data()!['id']}': true,
          'text': title,
          'target': vbn.data()!['id'],
          'store_name': name
        });
        FirebaseFirestore.instance
            .collection('listing')
            .doc(widget.listid)
            .update({
          '${basicstore_name}close': false,
        });
      }
    }

    final citydoc = await FirebaseFirestore.instance
        .collection('city')
        .where('name', isEqualTo: city)
        .get();
    final citydocx = await FirebaseFirestore.instance
        .collection('city')
        .where('name', isEqualTo: cityx)
        .get();
    final cityid = citydoc.docs.first.id;
    final cityidx = citydocx.docs.first.id;
    await FirebaseFirestore.instance
        .collection('city')
        .doc(cityidx)
        .collection('listingsInThisCity')
        .doc(widget.listid)
        .delete();
    await FirebaseFirestore.instance
        .collection('city')
        .doc(cityid)
        .collection('listingsInThisCity')
        .doc(widget.listid)
        .set({'id': userid});
    final countlisdocs = await FirebaseFirestore.instance
        .collection('city')
        .doc(cityid)
        .collection('listingsInThisCity')
        .get();
    final countlisdocsx = await FirebaseFirestore.instance
        .collection('city')
        .doc(cityidx)
        .collection('listingsInThisCity')
        .get();
    final countlis = countlisdocs.docs.length;
    final countlisx = countlisdocsx.docs.length;

    await FirebaseFirestore.instance
        .collection('city')
        .doc(cityid)
        .update({'listinginthiscitylength': countlis});
    await FirebaseFirestore.instance
        .collection('city')
        .doc(cityidx)
        .update({'listinginthiscitylength': countlisx});
    final catdoc = await FirebaseFirestore.instance
        .collection('category')
        .where('name', isEqualTo: category)
        .get();
    final catdocx = await FirebaseFirestore.instance
        .collection('category')
        .where('name', isEqualTo: categoryx)
        .get();
    final catid = catdoc.docs.first.id;
    final catidx = catdocx.docs.first.id;
    await FirebaseFirestore.instance
        .collection('category')
        .doc(catidx)
        .collection('listingsInThisCategory')
        .doc(widget.listid)
        .delete();
    await FirebaseFirestore.instance
        .collection('category')
        .doc(catid)
        .collection('listingsInThisCategory')
        .doc(widget.listid)
        .set({'id': userid});

    final countlisdocss = await FirebaseFirestore.instance
        .collection('category')
        .doc(catid)
        .collection('listingsInThisCategory')
        .get();
    final countlisdocssx = await FirebaseFirestore.instance
        .collection('category')
        .doc(catidx)
        .collection('listingsInThisCategory')
        .get();
    final countliss = countlisdocss.docs.length;
    final countlissx = countlisdocssx.docs.length;
    await FirebaseFirestore.instance
        .collection('category')
        .doc(catidx)
        .update({'listingsInThisCategorylength': countlissx});
    await FirebaseFirestore.instance
        .collection('category')
        .doc(catid)
        .update({'listingsInThisCategorylength': countliss});
    // final areadoc = await FirebaseFirestore.instance
    //     .collection('area')
    //     .where('name', isEqualTo: area)
    //     .get();
    // final areaid = areadoc.docs.first.id;
    // final areadocx = await FirebaseFirestore.instance
    //     .collection('area')
    //     .where('name', isEqualTo: areax)
    //     .get();
    // final areaidx = areadocx.docs.first.id;
    // await FirebaseFirestore.instance
    //     .collection('area')
    //     .doc(areaidx)
    //     .collection('listingsInThisArea')
    //     .doc(widget.listid)
    //     .delete();
    // await FirebaseFirestore.instance
    //     .collection('area')
    //     .doc(areaid)
    //     .collection('listingsInThisArea')
    //     .doc(widget.listid)
    //     .set({'id': userid});
    // final countlisdocsss = await FirebaseFirestore.instance
    //     .collection('area')
    //     .doc(areaid)
    //     .collection('listingsInThisarea')
    //     .get();
    // final countlisdocsssx = await FirebaseFirestore.instance
    //     .collection('area')
    //     .doc(areaidx)
    //     .collection('listingsInThisarea')
    //     .get();
    // final countlisss = countlisdocsss.docs.length;
    // final countlisssx = countlisdocsssx.docs.length;
    // await FirebaseFirestore.instance
    //     .collection('area')
    //     .doc(areaidx)
    //     .update({'listingsInThisarealength': countlisssx});
    // await FirebaseFirestore.instance
    //     .collection('area')
    //     .doc(areaid)
    //     .update({'listingsInThisarealength': countlisss});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('listing')
                .doc(widget.listid)
                .snapshots(),
            builder: (ctx, chatSnapshottt) {
              // if (chatSnapshottt.connectionState == ConnectionState.waiting) {
              //   return const Center(
              //     child: Text('Loading...'),
              //   );
              // }
              if (chatSnapshottt.hasData == false) {
                return const Center(child: Text(' Loading...'));
              }
              final chatdocs = chatSnapshottt.data;
              final imageurl = chatdocs!.data()!['image_url'];
              final title = chatdocs.data()!['title'];
              final description = chatdocs.data()!['description'];
              final city = chatdocs.data()!['city'];
              //   final area = chatdocs.data()!['area'];
              final category = chatdocs.data()!['category'];
              final updated = chatdocs.data()!['updated'];
              // print(isLoading);
              // print(imageurl);
              // print(title);
              // print(description);
              // print(city);
              // print(area);
              // print(category);
              // print(updated);

              return updatelistingform(
                  _submitAuthForm,
                  isLoading,
                  imageurl,
                  title,
                  description,
                  city,
                  //area
                  category,
                  updated);
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.messenger_outline_rounded),
        ));
  }
}
