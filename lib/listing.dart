import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alaqy/listingcards.dart';

class Listing extends StatelessWidget {
  static const routeName = '/listing';
  final userx = FirebaseAuth.instance.currentUser!.uid;
  void _selectPage() async {
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
    final idx = useri.docs.first.id;
    final sen = useri.docs.first.data()['sent'];
    FirebaseFirestore.instance
        .collection('customer_details')
        .doc(idx)
        .update({'seen': seensx, 'sent': sentsx});
  }

  @override
  Widget build(BuildContext context) {
    _selectPage();
    final size = MediaQuery.of(context).size;
    final heightx = size.height;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          SizedBox(height: heightx - 150, child: const ListingCards()),
          AnimatedTextKit(
            animatedTexts: [
              TyperAnimatedText(
                '',
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
