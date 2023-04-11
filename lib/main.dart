import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_alaqy/AllOrders.dart';
import 'package:flutter_alaqy/AuthFormUser.dart';
import 'package:flutter_alaqy/AuthScreenBusiness.dart';
import 'package:flutter_alaqy/FoundOrders.dart';
import 'package:flutter_alaqy/alaaqyProcess.dart';
import 'package:flutter_alaqy/authScreenUser.dart';
import 'package:flutter_alaqy/businessChoose.dart';
import 'package:flutter_alaqy/business_main.dart';
import 'package:flutter_alaqy/listing.dart';
import 'package:flutter_alaqy/userChoose.dart';
import 'package:flutter_alaqy/userToBusinessForm.dart';
import 'package:flutter_alaqy/userToBusinessScreen.dart';
import 'package:flutter_alaqy/user_main.dart';
import 'package:image_picker/image_picker.dart';

import 'ImagePicker.dart';
import 'numberPhone.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var phoneController;
    var accTypem;
    var pick;
    var uid;
    var uid2;
    var sup;
    var usern;

    return MaterialApp(
        title: 'Alaaqy',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (ctx, snap) =>
              snap.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: Text('Loading...'),
                    )
                  : StreamBuilder(
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: (ctx, snapShot) =>
//snapShot.hasData
                          //                        ?
                          const MyHomePage(title: 'Alaaqy auth')
                      //   : LoginScreen(),
                      ),
        ),
        routes: {
          Listing.routeName: (ctx) => Listing(),
          AlaaqyProcess.routeName: (ctx) => AlaaqyProcess(),
          UserMain.routeName: (ctx) => UserMain(),
          BusinessMain.routeName: (ctx) => BusinessMain(),
          AllOrders.routeName: (ctx) => AllOrders(),
          FoundOrders.routeName: (ctx) => FoundOrders(),
          LoginScreen.routeName: (ctx) => LoginScreen(accTypem),
          userChoose.routeName: (ctx) => userChoose(),
          businessChoose.routeName: (ctx) => businessChoose(),
          AuthScreenUser.routeName: (ctx) =>
              AuthScreenUser(phoneController, uid, sup),
          AuthScreenBusiness.routeName: (ctx) =>
              AuthScreenBusiness(phoneController, uid, sup),
          UserImagePicker.routeName: (ctx) => UserImagePicker(pick),
          UserToBusinessScreen.routeName: (ctx) =>
              UserToBusinessScreen(phoneController, uid, uid2, usern),
          //    AuthFormUser.routeName: (ctx) => AuthFormUser(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
                // Column is also a layout widget. It takes a list of children and
                // arranges them vertically. By default, it sizes itself to fit its
                // children horizontally, and tries to be as tall as its parent.
                //
                // Invoke "debug painting" (press "p" in the console, choose the
                // "Toggle Debug Paint" action from the Flutter Inspector in Android
                // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
                // to see the wireframe for each widget.
                //
                // Column has various properties to control how it sizes itself and
                // how it positions its children. Here we use mainAxisAlignment to
                // center the children vertically; the main axis here is the vertical
                // axis because Columns are vertical (the cross axis would be
                // horizontal).
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              const Text(
                'Choose whether be customer or merchant ',
              ),
              TextButton.icon(
                  icon: const Icon(
                    Icons.person_outline_rounded,
                  ),
                  label: const Text('User account'),
                  //        textColor: Theme.of(context).primaryColor,
                  onPressed: () async {
                    print('user');
                    if (FirebaseAuth.instance.currentUser != null) {
                      final active = await FirebaseFirestore.instance
                          .collection('customer_details')
                          .where('second_uid',
                              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                          .get();
                      final usid = active.docs.isNotEmpty
                          ? active.docs.first.id
                          : 'none';
                      active.docs.isNotEmpty
                          ? FirebaseFirestore.instance
                              .collection('customer_details')
                              .doc(usid)
                              .update({'activated': true})
                          : null;
                    }
                    Navigator.of(context).pushNamed(userChoose.routeName);
                  }),
              const Text('or'),
              TextButton.icon(
                icon: const Icon(
                  Icons.business_center_outlined,
                ),
                label: const Text('Business account'),
                //          textColor: Theme.of(context).primaryColor,
                onPressed: () {
                  // print(FirebaseAuth.instance.currentUser!.phoneNumber);
                  // print(FirebaseAuth.instance.currentUser!.uid);
                  Navigator.of(context).pushNamed(businessChoose.routeName);
                },
              ),
            ])));
  }
}
