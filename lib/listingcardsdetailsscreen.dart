import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alaqy/updatelisting.dart';
import 'package:intl/intl.dart';

import 'app_drawer.dart';
import 'listingcardsdetailsitem.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ListingCardsDetailsScreen extends StatefulWidget {
  static const routeName = '/ListingCardsDetailsScreen';
  final String id;
  final Timestamp createdAt;
  final String title;
  final String imageurl;
  final String description;
  const ListingCardsDetailsScreen(
      this.id, this.createdAt, this.title, this.imageurl, this.description,
      {super.key});
  // final String oppi;
//  final String oppoo;

//  Messagess(this.oppoo, this.oppi);
  @override
  State<ListingCardsDetailsScreen> createState() =>
      ListingCardsDetailsScreenState();
}

class ListingCardsDetailsScreenState extends State<ListingCardsDetailsScreen> {
  var _showOnlyFavorites = false;
  List businessareasids = [];
  List businessareas = [];
  List<Widget> nnn = [];
  List<DropdownMenuItem> mmm = [];
  var area = '';
  bool loading = false;
  @override
  final _transformationController = TransformationController();

  TapDownDetails? _doubleTapDetails;

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails!.localPosition;
      // For a 3x zoom
      _transformationController.value = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);
      // Fox a 2x zoom
      // ..translate(-position.dx, -position.dy)
      // ..scale(2.0);
    }
  }
  // void initState() {
  //   super.initState();
  //   final fbm = FirebaseMessaging.instance;
  //   fbm.requestNotificationPermissions();
  //   fbm.configure(onMessage: (msg) {
  //     print(msg);
  //     return;
  //   }, onLaunch: (msg) {
  //     print(msg);
  //     return;
  //   }, onResume: (msg) {
  //     print(msg);
  //     return;
  //   });
  //   fbm.getToken();
  //   //  fbm.unsubscribeFromTopic('beek');
  // }
  // void initState() {
  //   super.initState();
  //   FirebaseMessaging.instance
  //       .getInitialMessage()
  //       .then((RemoteMessage message) {
  //         if (message != null) {
  //           // Navigator.pushNamed(context, '/message',
  //           //     arguments: MessageArguments(message, true));
  //         }
  //       } as FutureOr Function(RemoteMessage? value));
  // }

  Widget build(BuildContext context) {
    final userid = FirebaseAuth.instance.currentUser!.uid;

    final fbm = FirebaseMessaging.instance;
    fbm.getToken();
    //  fbm.subscribeToTopic(notyu);
    fbm.onTokenRefresh;
    print('$area xxxxxx');
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
            toolbarHeight: 50,
            title: Text(
              widget.title,
              style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (ctx) => UpdateListing(
                              widget.id,
                            )));
                  }, //=> Navigator.popAndPushNamed(context, '/'),
                  icon: const Icon(Icons.update)),
              // PopupMenuButton(
              //   onSelected: (FilterOptions selectedValue) {
              //     setState(() {
              //       if (selectedValue == FilterOptions.Favorites) {
              //         _showOnlyFavorites = true;
              //       } else {
              //         _showOnlyFavorites = false;
              //       }
              //     });
              //   },
              //   icon: const Icon(
              //     Icons.more_vert,
              //   ),
              //   itemBuilder: (_) => [
              //     const PopupMenuItem(
              //       value: FilterOptions.Favorites,
              //       child: Text('filter by area'),
              //     ),
              //     const PopupMenuItem(
              //       value: FilterOptions.All,
              //       child: Text('Show All'),
              //     ),
              //   ],
              // ),
              // DropdownButton(
              //   underline: Text(
              //     'filter by Area',
              //     style: TextStyle(
              //         color: _showOnlyFavorites == false
              //             ? Colors.grey
              //             : Colors.blueGrey),
              //   ),
              //   icon: Icon(Icons.location_on,
              //       color: _showOnlyFavorites == false
              //           ? Colors.grey
              //           : Colors.deepPurple),
              //   onChanged: (value) {
              //     for (var r = 0; r < businessareas.length; r++) {
              //       if (value == businessareas[r]) {
              //         area = businessareas[r];
              //         setState(() {
              //           _showOnlyFavorites = !_showOnlyFavorites;
              //         });
              //       }
              //     }
              //   },
              //   selectedItemBuilder: (BuildContext context) {
              //     return nnn;
              //   },
              //   items: mmm,
              // ),
            ]),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('listing')
                .doc(widget.id.toString())
                .snapshots(),
            builder: (ctx, chatSnapshottt) {
              if (chatSnapshottt.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatDocs =
                  chatSnapshottt.hasData ? chatSnapshottt.data : null;
              List storesidzx = chatDocs!.data()!['storesidz'];
              storesidzx.remove(storesidzx.first);
              // for (var r = 0; r < storesidzx.length; r++) {
              //   var busname = FirebaseFirestore.instance
              //       .collection('business_details')
              //       .doc(storesidzx[r])
              //       .get();
              //   businessareasids
              //       .add(busname.then((value) => value.data()!['area_id']));
              // }
              // for (var x = 0; x < businessareasids.length; x++) {
              //   var areaname = FirebaseFirestore.instance
              //       .collection('area')
              //       .doc(businessareasids[x])
              //       .get();
              //   businessareas
              //       .add(areaname.then((value) => value.data()!['name']));
              // }
              return chatSnapshottt.hasData == false
                  ? const Center(
                      child: Text('no valid orders yet'),
                    )
                  : SizedBox(
                      height: 900,
                      width: double.infinity,
                      child: Column(children: [
                        SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: Center(
                              child: DropdownButton(
                                alignment: Alignment.bottomRight,
                                underline: loading == false
                                    ? const CircularProgressIndicator()
                                    : Text(
                                        'filter by Area',
                                        style: TextStyle(
                                            color: _showOnlyFavorites == false
                                                ? Colors.grey
                                                : Colors.blueGrey),
                                      ),
                                icon: Icon(Icons.location_on,
                                    color: _showOnlyFavorites == false
                                        ? Colors.grey
                                        : Colors.deepPurple),
                                onChanged: (value) {
                                  if (businessareas.isEmpty) {
                                    null;
                                  }
                                  if (businessareas.isNotEmpty) {
                                    for (var m = 0;
                                        m < businessareas.length;
                                        m++) {
                                      if (value == businessareas[m]) {
                                        area = businessareasids[m];
                                        setState(() {
                                          _showOnlyFavorites =
                                              !_showOnlyFavorites;
                                        });
                                      }
                                    }
                                  }
                                },
                                selectedItemBuilder: (BuildContext context) {
                                  return nnn;
                                },
                                items: mmm,
                              ),
                            )),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (ctx) => GestureDetector(
                                        onDoubleTapDown: _handleDoubleTapDown,
                                        onDoubleTap: _handleDoubleTap,
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Center(
                                            child: InteractiveViewer(
                                                transformationController:
                                                    _transformationController,
                                                child: Container(
                                                    child: Image.network(
                                                  widget.imageurl,
                                                  fit: BoxFit.contain,
                                                )))))));
                          },
                          child: Container(
                              height: 200,
                              width: double.infinity,
                              child: Image.network(
                                widget
                                    .imageurl, //                                        loadedProduct.imageUrlxxxxxxxx,
                                fit: BoxFit.fill,
                              )),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          width: double.infinity,
                          child: Text(
                            widget.description,
                            textAlign: TextAlign.center,
                            softWrap: true,
                          ),
                        ),
                        Center(
                          child: Text(
                              'date:${DateFormat('dd/MM/yyyy hh:mm').format(widget.createdAt.toDate())}',
                              style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey)),
                        ),
                        SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: ListView.builder(
                                //  reverse: true,
                                itemCount: storesidzx.length,
                                itemBuilder: (ctx, index) => SizedBox(
                                      //  height: 160,
                                      width: double.infinity,
                                      child: ListingCardsDetailsItem(
                                          storesidzx[index],
                                          widget.id,
                                          _showOnlyFavorites,
                                          area),
                                    ))),
                        const Divider(),
                        AnimatedTextKit(
                          animatedTexts: [
                            TyperAnimatedText(
                              '',
                              textStyle: const TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 13),
                              speed: const Duration(milliseconds: 200),
                            )
                          ],
                          totalRepeatCount: 1,
                          //  repeatForever: true,
                          // onFinished: () => setState(() {
                          //   loading = true;
                          // }),
                          onNext: (p0, p1) async {
                            if (loading == false) {
                              if (storesidzx.isEmpty) {}
                              for (var r = 0; r < storesidzx.length; r++) {
                                var busname = await FirebaseFirestore.instance
                                    .collection('business_details')
                                    .doc(storesidzx[r])
                                    .get();
                                businessareasids
                                    .add(busname.data()!['area_id']);
                              }
                              for (var x = 0;
                                  x < businessareasids.length;
                                  x++) {
                                var areaname = await FirebaseFirestore.instance
                                    .collection('area')
                                    .doc(businessareasids[x])
                                    .get();
                                businessareas.add(areaname.data()!['name']);
                              }
                              businessareas.getRange(0, storesidzx.length);
                              if (businessareas.isEmpty) {
                                mmm.add(DropdownMenuItem(
                                    value: 'no stores yet',
                                    child: Container(
                                      child: Row(
                                        children: const <Widget>[
                                          Icon(Icons.location_on),
                                          SizedBox(width: 2),
                                          Text('no stores yet'),
                                        ],
                                      ),
                                    )));
                                nnn.add(const Text('no stores yet'));
                              }
                              if (businessareas.isNotEmpty) {
                                for (var z = 0; z < businessareas.length; z++) {
                                  nnn.add(Text(businessareas[z]));
                                  mmm.add(DropdownMenuItem(
                                      value: businessareas[z],
                                      child: Container(
                                        child: Row(
                                          children: <Widget>[
                                            const Icon(Icons.location_on),
                                            const SizedBox(width: 2),
                                            Text(businessareas[z]),
                                          ],
                                        ),
                                      )));
                                }
                              }
                              setState(() {
                                loading = true;
                              });
                            }
                          },
                        ),
                      ]));
            }));
  }
}
