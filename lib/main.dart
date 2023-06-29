import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_alaqy/AllOrders.dart';
import 'package:flutter_alaqy/AuthScreenBusiness.dart';
import 'package:flutter_alaqy/FoundOrders.dart';
import 'package:flutter_alaqy/SPLASHSCREEN.dart';
import 'package:flutter_alaqy/alaaqyProcess.dart';
import 'package:flutter_alaqy/authScreenUser.dart';
import 'package:flutter_alaqy/businessChoose.dart';
import 'package:flutter_alaqy/business_main.dart';
import 'package:flutter_alaqy/listing.dart';
import 'package:flutter_alaqy/updatebusiness.dart';
import 'package:flutter_alaqy/updateuser.dart';
import 'package:flutter_alaqy/userChoose.dart';
import 'package:flutter_alaqy/userToBusinessScreen.dart';
import 'package:flutter_alaqy/user_main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'ImagePicker.dart';
import 'business_mainx.dart';
import 'chat_screens.dart';
import 'numberPhone.dart';
import 'opening.dart';
import 'user_mainx.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        // Navigator.pushNamed(
        //   context, '/',
        //   //  arguments: MessageArguments(message, true)
        // );
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'widget.id',
                'widget.storename',
                //  widget.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // Navigator.pushNamed(
      //   context, '/',
      //   //  arguments: MessageArguments(message, true)
      // );
    });
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  print('User granted permission: ${settings.authorizationStatus}');
  messaging.subscribeToTopic('notify');
  print("Handling a background message: ${message.messageId}");
}

Future<void> _onBackgroundMessage(RemoteMessage message) async {
  debugPrint('we have received a notification ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // void didChangeAppLifecycleStatee(AppLifecycleState state) async {
  //   // super.didChangeAppLifecycleState(state);
  //   if (FirebaseAuth.instance.currentUser != null) {
  //     final userdoc = await FirebaseFirestore.instance
  //         .collection('customer_details')
  //         .where('second_uid',
  //             isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //         .get();
  //     if (userdoc.docs.first.exists) {
  //       final userdocid = userdoc.docs.first.id;
  //       print(userdocid);
  //       print('userdocid');

  //       switch (state) {
  //         case AppLifecycleState.resumed:
  //           FirebaseFirestore.instance
  //               .collection('customer_details')
  //               .doc(userdocid)
  //               .update({
  //             'state': 'online',
  //             'lastseen': Timestamp.now(),
  //           });
  //           print("app in resumed");
  //           break;
  //         case AppLifecycleState.inactive:
  //           FirebaseFirestore.instance
  //               .collection('customer_details')
  //               .doc(userdocid)
  //               .update({
  //             'state': 'offline',
  //             'lastseen': Timestamp.now(),
  //           });
  //           print("app in inactive");
  //           break;
  //         case AppLifecycleState.paused:
  //           FirebaseFirestore.instance
  //               .collection('customer_details')
  //               .doc(userdocid)
  //               .update({
  //             'state': 'offline',
  //             'lastseen': Timestamp.now(),
  //           });
  //           print("app in paused");
  //           break;
  //         case AppLifecycleState.detached:
  //           FirebaseFirestore.instance
  //               .collection('customer_details')
  //               .doc(userdocid)
  //               .update({
  //             'state': 'offline',
  //             'lastseen': Timestamp.now(),
  //           });
  //           print("app in detached");
  //           break;
  //       }
  //     }
  //   }
  // }

  runApp(const MyApp());
}
// void didChangeAppLifecycleState(AppLifecycleState state) async {
//     final userdoc = await FirebaseFirestore.instance
//         .collection('customer_details')
//         .where('second_uid',
//             isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//         .get();
//     final userdocid = userdoc.docs.first.id;

//     switch (state) {
//       case AppLifecycleState.resumed:
//         FirebaseFirestore.instance
//             .collection('customer_details')
//             .doc(userdocid)
//             .update({'state': 'online'});
//         print("app in resumed");
//         break;
//       case AppLifecycleState.inactive:
//         FirebaseFirestore.instance
//             .collection('customer_details')
//             .doc(userdocid)
//             .update({'state': 'offline'});
//         print("app in inactive");
//         break;
//       case AppLifecycleState.paused:
//         FirebaseFirestore.instance
//             .collection('customer_details')
//             .doc(userdocid)
//             .update({'state': 'offline'});
//         print("app in paused");
//         break;
//       case AppLifecycleState.detached:
//         FirebaseFirestore.instance
//             .collection('customer_details')
//             .doc(userdocid)
//             .update({'state': 'offline'});
//         print("app in detached");
//         break;
//     }
//   }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (FirebaseAuth.instance.currentUser != null) {
      final userdoc = await FirebaseFirestore.instance
          .collection('customer_details')
          .where('second_uid',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (userdoc.docs.first.exists) {
        final userdocid = userdoc.docs.first.id;
        print(userdocid);
        print('userdocid');

        switch (state) {
          case AppLifecycleState.resumed:
            FirebaseFirestore.instance
                .collection('customer_details')
                .doc(userdocid)
                .update({
              'state': 'online',
              'lastseen': Timestamp.now(),
            });
            print("app in resumed");
            break;
          case AppLifecycleState.inactive:
            FirebaseFirestore.instance
                .collection('customer_details')
                .doc(userdocid)
                .update({
              'state': 'offline',
              'lastseen': Timestamp.now(),
            });
            print("app in inactive");
            break;
          case AppLifecycleState.paused:
            FirebaseFirestore.instance
                .collection('customer_details')
                .doc(userdocid)
                .update({
              'state': 'offline',
              'lastseen': Timestamp.now(),
            });
            print("app in paused");
            break;
          case AppLifecycleState.detached:
            FirebaseFirestore.instance
                .collection('customer_details')
                .doc(userdocid)
                .update({
              'state': 'offline',
              'lastseen': Timestamp.now(),
            });
            print("app in detached");
            break;
        }
      }
    }
  }

//class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    Future<void> _firebaseMessagingBackgroundHandler(
        RemoteMessage message) async {
      // If you're going to use other Firebase services in the background, such as Firestore,
      // make sure you call `initializeApp` before using other Firebase services.
      await Firebase.initializeApp();
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        FirebaseMessaging.instance
            .getInitialMessage()
            .then((RemoteMessage? message) {
          if (message != null) {
            // Navigator.pushNamed(
            //   context, '/',
            //   //  arguments: MessageArguments(message, true)
            // );
          }
        });

        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          final FlutterLocalNotificationsPlugin
              flutterLocalNotificationsPlugin =
              FlutterLocalNotificationsPlugin();
          RemoteNotification? notification = message.notification;
          AndroidNotification? android = message.notification?.android;

          if (notification != null && android != null) {
            flutterLocalNotificationsPlugin.show(
                notification.hashCode,
                notification.title,
                notification.body,
                const NotificationDetails(
                  android: AndroidNotificationDetails(
                    'widget.id',
                    'widget.storename',
                    //  widget.description,
                    // TODO add a proper drawable resource to android, for now using
                    //      one that already exists in example app.
                    icon: 'launch_background',
                  ),
                ));
          }
        });

        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          print('A new onMessageOpenedApp event was published!');
          // Navigator.pushNamed(
          //   context, '/',
          //   //  arguments: MessageArguments(message, true)
          // );
        });
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');

        if (message.notification != null) {
          print(
              'Message also contained a notification: ${message.notification}');
        }
      });
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      print('User granted permission: ${settings.authorizationStatus}');
      messaging.subscribeToTopic('notify');
      print("Handling a background message: ${message.messageId}");
    }

    Future<void> _onBackgroundMessage(RemoteMessage message) async {
      debugPrint('we have received a notification ${message.messageId}');
    }

    // void didChangeAppLifecycleStatee(AppLifecycleState state) async {
    //   // super.didChangeAppLifecycleState(state);
    //   if (FirebaseAuth.instance.currentUser != null) {
    //     final userdoc = await FirebaseFirestore.instance
    //         .collection('customer_details')
    //         .where('second_uid',
    //             isEqualTo: FirebaseAuth.instance.currentUser!.uid)
    //         .get();
    //     if (userdoc.docs.first.exists) {
    //       final userdocid = userdoc.docs.first.id;
    //       print(userdocid);
    //       print('userdocid');

    //       switch (state) {
    //         case AppLifecycleState.resumed:
    //           FirebaseFirestore.instance
    //               .collection('customer_details')
    //               .doc(userdocid)
    //               .update({
    //             'state': 'online',
    //             'lastseen': Timestamp.now(),
    //           });
    //           print("app in resumed");
    //           break;
    //         case AppLifecycleState.inactive:
    //           FirebaseFirestore.instance
    //               .collection('customer_details')
    //               .doc(userdocid)
    //               .update({
    //             'state': 'offline',
    //             'lastseen': Timestamp.now(),
    //           });
    //           print("app in inactive");
    //           break;
    //         case AppLifecycleState.paused:
    //           FirebaseFirestore.instance
    //               .collection('customer_details')
    //               .doc(userdocid)
    //               .update({
    //             'state': 'offline',
    //             'lastseen': Timestamp.now(),
    //           });
    //           print("app in paused");
    //           break;
    //         case AppLifecycleState.detached:
    //           FirebaseFirestore.instance
    //               .collection('customer_details')
    //               .doc(userdocid)
    //               .update({
    //             'state': 'offline',
    //             'lastseen': Timestamp.now(),
    //           });
    //           print("app in detached");
    //           break;
    //       }
    //     }
    //   }
    // }

    var phoneController;
    var accTypem;
    var pick;
    var uid;
    var uid2;
    var sup;
    var kok;
    var usern;
    var usern2;
    var id;
    var username;
    var storename;
    var stringo;
    var bus1;
    var bus2;
    var cusid;
    var idx;
    var idy;
    var basicusername;
    var basicstorename;
    var phx;
    var icc;
    var koje;
    // final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    return MaterialApp(
        // navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Alaaqy',
        theme: ThemeData(
          buttonTheme: ButtonThemeData(buttonColor: Colors.amber),
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          // primarySwatch: Colors.blue,
          primaryColor: Colors.white,
          // colorScheme: ColorScheme.light(
          //     onPrimary: Colors.amber,
          //     //   background: Colors.amber.shade700,
          //     primary: Colors.grey.shade400,
          //     secondary: Colors.green
          // )
        ),
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.white)),
        home: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (ctx, snap) =>
              snap.connectionState == ConnectionState.waiting
                  ?
//  const Center(
//                   child: Text('Loading...'),
                  SplashScreen()
                  //)
                  : StreamBuilder(
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: (ctx, snapShot) =>
                          snapShot.connectionState == ConnectionState.waiting
                              ?
//const Scaffold(body: Center(child: Text('Loading...')))
                              SplashScreen()
                              : snapShot.hasData
                                  ? opening()
                                  : const MyHomePage(title: 'Alaaqy')
                      //   : LoginScreen(),
                      ),
        ),
        routes: {
          Listing.routeName: (ctx) => Listing(),
          AlaaqyProcess.routeName: (ctx) => AlaaqyProcess(),
          UserMain.routeName: (ctx) => UserMain(idx),
          UserMainx.routeName: (ctx) => UserMainx(icc),
          SplashScreen.routeName: (ctx) => SplashScreen(),
          BusinessMain.routeName: (ctx) => BusinessMain(idy),
          BusinessMainx.routeName: (ctx) => BusinessMainx(idy, phx),

          AllOrders.routeName: (ctx) => AllOrders(),
          FoundOrders.routeName: (ctx) => FoundOrders(),
          LoginScreen.routeName: (ctx) => LoginScreen(accTypem, koje),
          userChoose.routeName: (ctx) => userChoose(),
          businessChoose.routeName: (ctx) => businessChoose(),
          AuthScreenUser.routeName: (ctx) =>
              AuthScreenUser(phoneController, uid, sup, kok),
          AuthScreenBusiness.routeName: (ctx) =>
              AuthScreenBusiness(phoneController, uid, sup, usern2),
          UserImagePicker.routeName: (ctx) => UserImagePicker(pick),
          UserToBusinessScreen.routeName: (ctx) =>
              UserToBusinessScreen(phoneController, uid, uid2, usern),
          ChatScreens.routeName: (ctx) => ChatScreens(id, username, storename,
              stringo, bus1, bus2, cusid, basicusername, basicstorename),
          UpdateUser.routeName: (ctx) => UpdateUser(),
          UpdateBusiness.routeName: (ctx) => UpdateBusiness(),

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

// void didChangeAppLifecycleStatee(AppLifecycleState state) async {
//   // super.didChangeAppLifecycleState(state);
//   if (FirebaseAuth.instance.currentUser != null) {
//     final userdoc = await FirebaseFirestore.instance
//         .collection('customer_details')
//         .where('second_uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//         .get();
//     if (userdoc.docs.first.exists) {
//       final userdocid = userdoc.docs.first.id;
//       print(userdocid);
//       print('userdocid');

//       switch (state) {
//         case AppLifecycleState.resumed:
//           FirebaseFirestore.instance
//               .collection('customer_details')
//               .doc(userdocid)
//               .update({
//             'state': 'online',
//             'lastseen': Timestamp.now(),
//           });
//           print("app in resumed");
//           break;
//         case AppLifecycleState.inactive:
//           FirebaseFirestore.instance
//               .collection('customer_details')
//               .doc(userdocid)
//               .update({
//             'state': 'offline',
//             'lastseen': Timestamp.now(),
//           });
//           print("app in inactive");
//           break;
//         case AppLifecycleState.paused:
//           FirebaseFirestore.instance
//               .collection('customer_details')
//               .doc(userdocid)
//               .update({
//             'state': 'offline',
//             'lastseen': Timestamp.now(),
//           });
//           print("app in paused");
//           break;
//         case AppLifecycleState.detached:
//           FirebaseFirestore.instance
//               .collection('customer_details')
//               .doc(userdocid)
//               .update({
//             'state': 'offline',
//             'lastseen': Timestamp.now(),
//           });
//           print("app in detached");
//           break;
//       }
//     }
//   }
// }

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  var bus = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  // void didChangeAppLifecycleState(AppLifecycleState state) async {
  //   super.didChangeAppLifecycleState(state);
  //   if (FirebaseAuth.instance.currentUser != null) {
  //     final userdoc = await FirebaseFirestore.instance
  //         .collection('customer_details')
  //         .where('second_uid',
  //             isEqualTo: FirebaseAuth.instance.currentUser!.uid)
  //         .get();
  //     if (userdoc.docs.first.exists) {
  //       final userdocid = userdoc.docs.first.id;
  //       print(userdocid);
  //       print('userdocid');

  //       switch (state) {
  //         case AppLifecycleState.resumed:
  //           FirebaseFirestore.instance
  //               .collection('customer_details')
  //               .doc(userdocid)
  //               .update({
  //             'state': 'online',
  //             'lastseen': Timestamp.now(),
  //           });
  //           print("app in resumed");
  //           break;
  //         case AppLifecycleState.inactive:
  //           FirebaseFirestore.instance
  //               .collection('customer_details')
  //               .doc(userdocid)
  //               .update({
  //             'state': 'offline',
  //             'lastseen': Timestamp.now(),
  //           });
  //           print("app in inactive");
  //           break;
  //         case AppLifecycleState.paused:
  //           FirebaseFirestore.instance
  //               .collection('customer_details')
  //               .doc(userdocid)
  //               .update({
  //             'state': 'offline',
  //             'lastseen': Timestamp.now(),
  //           });
  //           print("app in paused");
  //           break;
  //         case AppLifecycleState.detached:
  //           FirebaseFirestore.instance
  //               .collection('customer_details')
  //               .doc(userdocid)
  //               .update({
  //             'state': 'offline',
  //             'lastseen': Timestamp.now(),
  //           });
  //           print("app in detached");
  //           break;
  //       }
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final hightx = size.height;
    final widthx = size.width;
    final useid = FirebaseAuth.instance.currentUser == null
        ? ''
        : FirebaseAuth.instance.currentUser!.uid;

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    void initState() {
      super.initState();
      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? message) {
        if (message != null) {
          Navigator.pushNamed(
            context, '/',
            //  arguments: MessageArguments(message, true)
          );
        }
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'widget.id',
                  'widget.storename',
                  //  widget.description,
                  // TODO add a proper drawable resource to android, for now using
                  //      one that already exists in example app.
                  icon: 'launch_background',
                ),
              ));
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('A new onMessageOpenedApp event was published!');
        Navigator.pushNamed(
          context, '/',
          //  arguments: MessageArguments(message, true)
        );
      });
    }

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              centerTitle: true,
              toolbarHeight: 30,
              backgroundColor: Colors.grey,
            ),
            body:
// Center(
//             // Center is a layout widget. It takes a single child and positions it
//             // in the middle of the parent.
//             child:
                SingleChildScrollView(
                    child: Column(children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              Center(
                  child: SizedBox(
                      //   height: 100,
                      //   width: double.infinity,
                      child: Image.asset(
                'assets/alaqy.jpeg',
                fit: BoxFit.contain,
              ))),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  "تسجيل الدخول",
                  style: TextStyle(fontFamily: 'Tajawal', color: Colors.black),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      //    color: Colors.white,
                      width: widthx,
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 3,
                                      horizontal: 1,
                                    ),
                                    //width: 120,
                                    //  height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(4),
                                          topRight: Radius.circular(4),
                                          bottomLeft: Radius.circular(4),
                                          bottomRight: Radius.circular(4)),
                                      color: bus != true
                                          ? Color.fromARGB(226, 0, 0, 0)
                                          : Color.fromARGB(35, 158, 158, 158),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 2,
                                      horizontal: 2,
                                    ),
                                    child: Container(
                                        alignment: Alignment.center,
                                        //   width: 120,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(4),
                                              topRight: Radius.circular(4),
                                              bottomLeft: Radius.circular(4),
                                              bottomRight: Radius.circular(4)),
                                          color: bus != true
                                              ? Color.fromARGB(226, 0, 0, 0)
                                              : Color.fromARGB(
                                                  34, 255, 255, 255),
                                        ),
                                        child: TextButton.icon(
                                            label:
//  Text(
//                                               '🏬',
//                                               style: TextStyle(
//                                                   // textBaseline:
//                                                   //     TextBaseline.alphabetic,
//                                                   // height: -0.01,
//                                                   fontSize: 12,
//                                                   //   fontStyle: FontStyle.italic,
//                                                   fontWeight: (bus == true) ? FontWeight.normal : FontWeight.bold,
//                                                   shadows: [
//                                                     Shadow(
//                                                         blurRadius: bus == false
//                                                             ? 3
//                                                             : 0)
//                                                   ]),
//                                             ),
                                                //   Icon(
                                                //   bus == true
                                                //     ? Icons.person_outline_rounded
                                                //     : Icons.person,
                                                // size: 27,
                                                SizedBox(
                                                    // height: 100,
                                                    // width: double.infinity,
                                                    child: Image.asset(
                                              'assets/alaqyzz.jpeg',
                                              fit: BoxFit.contain,
                                            )),
                                            icon: Text(
                                              ' حساب عميل',
                                              style: TextStyle(
                                                  fontFamily: 'Tajawal',
                                                  color: bus == true
                                                      ? Color.fromARGB(
                                                          184, 0, 0, 0)
                                                      : Colors.white,
                                                  textBaseline:
                                                      TextBaseline.alphabetic,
                                                  height: -0.01,
                                                  fontSize: 12,
                                                  //      fontStyle: FontStyle.italic,
                                                  fontWeight: (bus == true) ? FontWeight.normal : FontWeight.bold,
                                                  shadows: [
                                                    Shadow(
                                                        blurRadius: bus == false
                                                            ? 3
                                                            : 0)
                                                  ]),
                                            ),
                                            //        textColor: Theme.of(context).primaryColor,
                                            onPressed: () async {
                                              print('user');
                                              if (FirebaseAuth
                                                      .instance.currentUser !=
                                                  null) {
                                                final active =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            'customer_details')
                                                        .where('second_uid',
                                                            isEqualTo:
                                                                FirebaseAuth
                                                                    .instance
                                                                    .currentUser!
                                                                    .uid)
                                                        .get();
                                                final usid =
                                                    active.docs.isNotEmpty
                                                        ? active.docs.first.id
                                                        : 'none';
                                                active.docs.isNotEmpty
                                                    ? FirebaseFirestore.instance
                                                        .collection(
                                                            'customer_details')
                                                        .doc(usid)
                                                        .update(
                                                            {'activated': true})
                                                    : null;
                                              }
                                              setState(() {
                                                bus = false;
                                              });
                                              print(bus);

                                              //  Navigator.of(context).pushNamed(userChoose.routeName);
                                            }))),
                                //   const Text('او'),
                                const SizedBox(width: 9),
                                Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 3,
                                      horizontal: 1,
                                    ),
                                    //width: 120,
                                    //    height: 500,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(4),
                                          topRight: Radius.circular(4),
                                          bottomLeft: Radius.circular(4),
                                          bottomRight: Radius.circular(4)),
                                      color: bus == true
                                          ? Color.fromARGB(226, 0, 0, 0)
                                          : Color.fromARGB(35, 158, 158, 158),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 2,
                                      horizontal: 2,
                                    ),
                                    child: Container(
                                        alignment: Alignment.center,
                                        //   width: 120,
                                        //      height: 500,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(4),
                                              topRight: Radius.circular(4),
                                              bottomLeft: Radius.circular(4),
                                              bottomRight: Radius.circular(4)),
                                          color: bus == true
                                              ? Color.fromARGB(226, 0, 0, 0)
                                              : Color.fromARGB(
                                                  34, 255, 255, 255),
                                        ),
                                        child: TextButton.icon(
                                          style: ButtonStyle(
                                            alignment: Alignment.center,
                                          ),
                                          label:
// Icon(
//                                             bus == false
//                                                 ? Icons
//                                                     .store_mall_directory_outlined //Icons.business_center_outlined
//                                                 : Icons.store_rounded,
//                                             color: Colors.redAccent,
//                                             size: 27,
//                                           ),
                                              SizedBox(
                                                  // height: 100,
                                                  // width: double.infinity,
                                                  child: Image.asset(
                                            'assets/alaqyz.jpeg',
                                            fit: BoxFit.contain,
                                          )),
                                          icon: Text(
                                            'حساب بيزنس',
                                            style: TextStyle(
                                                fontFamily: 'Tajawal',
                                                color: bus != true
                                                    ? Color.fromARGB(
                                                        184, 0, 0, 0)
                                                    : Colors.white,
                                                textBaseline:
                                                    TextBaseline.alphabetic,
                                                height: -0.01,
                                                fontSize: 12,
                                                //   fontStyle: FontStyle.italic,
                                                fontWeight: (bus == false) ? FontWeight.normal : FontWeight.bold,
                                                shadows: [
                                                  Shadow(
                                                      blurRadius:
                                                          bus == true ? 3 : 0)
                                                ]),
                                          ),
                                          //          textColor: Theme.of(context).primaryColor,
                                          onPressed: () {
                                            // print(FirebaseAuth.instance.currentUser!.phoneNumber);
                                            // print(FirebaseAuth.instance.currentUser!.uid);
                                            // Navigator.of(context)
                                            //     .pushNamed(businessChoose.routeName);
                                            setState(() {
                                              bus = true;
                                            });
                                            print(bus);
                                          },
                                        ))),
                              ])))),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  height: hightx - 100,
                  child: bus == true
                      ? AuthScreenBusiness('', 'result.user!.uid', false, '')
                      : AuthScreenUser('', 'result.user!.uid', false, false)),
            ])))
//)
        ;
  }
}
