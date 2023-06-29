import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'app_drawer2.dart';
import 'badge.dart';
import 'chat_screens.dart';

class OrderCardsDetailsScreen extends StatefulWidget {
  static const routeName = '/OrderCardsDetailsScreen';
  final String id;
  final Timestamp createdAt;
  final String title;
  final String imageurl;
  final String description;
  final String username;
  final String chatindicator;
  final String storename;
  final String basicstorename;
  final String basicusername;
  const OrderCardsDetailsScreen(
      this.id,
      this.createdAt,
      this.title,
      this.imageurl,
      this.description,
      this.username,
      this.chatindicator,
      this.storename,
      this.basicstorename,
      this.basicusername,
      {super.key});
  @override
  State<OrderCardsDetailsScreen> createState() =>
      OrderCardsDetailsScreenState();
}

class OrderCardsDetailsScreenState extends State<OrderCardsDetailsScreen> {
  int badgoo = 0;
  bool loading = false;
  String categoryx = '';
  String cityx = '';
  late String useridx;
  late String busidx;
  final busid2x = FirebaseAuth.instance.currentUser!.uid;
  bool loadingxx = false;

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

  @override
  void initState() {
    // setState(() {
    //   loadingxx = false;
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(const Duration(seconds: 3), (() {
    //   setState(() {
    //     loadingxx = false;
    //   });
    // }));
    return Scaffold(
        drawer: AppDrawer2(),
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView.builder(
          //             reverse: true,

          itemCount: 1,
// chatDocs.length,
          itemBuilder: (ctx, index) => Column(children: [
            SingleChildScrollView(
                child: Column(children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
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
                    height: 300,
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
                        fontStyle: FontStyle.italic, color: Colors.grey)),
              ),
              Center(
                child: Text('category: $categoryx',
                    style: const TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.purple)),
              ),
              Center(
                child: Text('city: $cityx',
                    style: const TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.deepPurple)),
              ),
              widget.chatindicator == 'on'
                  ? StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('listing')
                          .doc(widget.id.toString())
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

                        if (userSnapshot.hasData == true) {
                          final badgo1 = chatDocs!.data()![
                              'post_owner_reply_to_business${widget.storename}'];
                          final badgo2 = chatDocs.data()![
                              'post_owner_seen_by_business${widget.storename}'];

                          badgoo = badgo1 - badgo2;
                        }

                        return loadingxx == true
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : badgoo != 0
                                ? Badgee(
                                    value: badgoo.toString(),
                                    color:
                                        const Color.fromARGB(176, 244, 67, 54),
                                    child: GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          loadingxx = true;
                                        });
                                        Future.delayed(
                                            const Duration(seconds: 3), (() {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (ctx) => ChatScreens(
                                                      widget.id,
                                                      widget.username,
                                                      widget.storename,
                                                      'business',
                                                      busidx,
                                                      busid2x,
                                                      useridx,
                                                      widget.basicstorename,
                                                      widget.basicusername)));
                                          // setState(() {
                                          //   loadingxx = false;
                                          // });
                                        }));
                                        Future.delayed(
                                            const Duration(seconds: 3), (() {
                                          setState(() {
                                            loadingxx = false;
                                          });
                                        }));
                                        final targ = await FirebaseFirestore
                                            .instance
                                            .collection('listing')
                                            .doc(widget.id.toString())
                                            .get();
                                        final userid = targ.data()!['userid'];
                                        final repto = targ.data()![
                                            'post_owner_reply_to_business${widget.storename}'];
                                        FirebaseFirestore.instance
                                            .collection('listing')
                                            .doc(widget.id.toString())
                                            .update({
                                          'post_owner_seen_by_business${widget.storename}':
                                              repto
                                        });
                                        final chox = await FirebaseFirestore
                                            .instance
                                            .collection('business_details')
                                            .where('second_uid',
                                                isEqualTo: FirebaseAuth
                                                    .instance.currentUser!.uid)
                                            .get();
                                        final busid =
                                            chox.docs.last.data()['first_uid'];
                                        final busid2 = FirebaseAuth
                                            .instance.currentUser!.uid;
                                        // Navigator.of(context).push(
                                        //     MaterialPageRoute(
                                        //         builder: (ctx) => ChatScreens(
                                        //             widget.id,
                                        //             widget.username,
                                        //             widget.storename,
                                        //             'business',
                                        //             busid,
                                        //             busid2,
                                        //             userid,
                                        //             widget.basicstorename,
                                        //             widget.basicusername)));
                                        // setState(() {
                                        //   loadingxx = false;
                                        // });
                                      },
                                      child: IconButton(
                                        // need gesturedetecture  for doubletap
                                        icon:
                                            const Icon(Icons.messenger_outline),
                                        onPressed: () async {
                                          setState(() {
                                            loadingxx = true;
                                          });
                                          Future.delayed(
                                              const Duration(seconds: 3), (() {
                                            Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(
                                                    builder: (ctx) => ChatScreens(
                                                        widget.id,
                                                        widget.username,
                                                        widget.storename,
                                                        'business',
                                                        busidx,
                                                        busid2x,
                                                        useridx,
                                                        widget.basicstorename,
                                                        widget.basicusername)));
                                            // setState(() {
                                            //   loadingxx = false;
                                            // });
                                          }));
                                          Future.delayed(
                                              const Duration(seconds: 3), (() {
                                            setState(() {
                                              loadingxx = false;
                                            });
                                          }));
                                          final targ = await FirebaseFirestore
                                              .instance
                                              .collection('listing')
                                              .doc(widget.id.toString())
                                              .get();
                                          final userid = targ.data()!['userid'];
                                          final repto = targ.data()![
                                              'post_owner_reply_to_business${widget.storename}'];
                                          FirebaseFirestore.instance
                                              .collection('listing')
                                              .doc(widget.id.toString())
                                              .update({
                                            'post_owner_seen_by_business${widget.storename}':
                                                repto
                                          });
                                          final chox = await FirebaseFirestore
                                              .instance
                                              .collection('business_details')
                                              .where('second_uid',
                                                  isEqualTo: FirebaseAuth
                                                      .instance
                                                      .currentUser!
                                                      .uid)
                                              .get();
                                          final busid = chox.docs.last
                                              .data()['first_uid'];
                                          final busid2 = FirebaseAuth
                                              .instance.currentUser!.uid;
                                          print(widget.id);
                                          print(widget.username);
                                          print(widget.storename);
                                          print(busid);
                                          print(busid2);
                                          print(userid);

                                          // Navigator.of(context).push(
                                          //     MaterialPageRoute(
                                          //         builder: (ctx) => ChatScreens(
                                          //             widget.id,
                                          //             widget.username,
                                          //             widget.storename,
                                          //             'business',
                                          //             busid,
                                          //             busid2,
                                          //             userid,
                                          //             widget.basicstorename,
                                          //             widget.basicusername)));
                                          // setState(() {
                                          //   loadingxx = false;
                                          // });
                                        },
                                      ),
                                    ))
                                : GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        loadingxx = true;
                                      });
                                      Future.delayed(const Duration(seconds: 3),
                                          (() {
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (ctx) => ChatScreens(
                                                    widget.id,
                                                    widget.username,
                                                    widget.storename,
                                                    'business',
                                                    busidx,
                                                    busid2x,
                                                    useridx,
                                                    widget.basicstorename,
                                                    widget.basicusername)));
                                        // setState(() {
                                        //   loadingxx = false;
                                        // });
                                      }));
                                      Future.delayed(const Duration(seconds: 3),
                                          (() {
                                        setState(() {
                                          loadingxx = false;
                                        });
                                      }));
                                      final targ = await FirebaseFirestore
                                          .instance
                                          .collection('listing')
                                          .doc(widget.id.toString())
                                          .get();
                                      final userid = targ.data()!['userid'];
                                      final repto = targ.data()![
                                          'post_owner_reply_to_business${widget.storename}'];
                                      FirebaseFirestore.instance
                                          .collection('listing')
                                          .doc(widget.id.toString())
                                          .update({
                                        'post_owner_seen_by_business${widget.storename}':
                                            repto
                                      });
                                      final chox = await FirebaseFirestore
                                          .instance
                                          .collection('business_details')
                                          .where('second_uid',
                                              isEqualTo: FirebaseAuth
                                                  .instance.currentUser!.uid)
                                          .get();
                                      final busid =
                                          chox.docs.last.data()['first_uid'];
                                      final busid2 = FirebaseAuth
                                          .instance.currentUser!.uid;
                                      print(widget.id);
                                      print(widget.username);
                                      print(widget.storename);
                                      print(busid);
                                      print(busid2);
                                      print(userid);
                                      // Navigator.of(context).push(MaterialPageRoute(
                                      //     builder: (ctx) => ChatScreens(
                                      //         widget.id,
                                      //         widget.username,
                                      //         widget.storename,
                                      //         'business',
                                      //         busid,
                                      //         busid2,
                                      //         userid,
                                      //         widget.basicstorename,
                                      //         widget.basicusername)));
                                      // setState(() {
                                      //   loadingxx = false;
                                      // });
                                    },
                                    child: IconButton(
                                      // need gesturedetecture  for doubletap
                                      icon: const Icon(Icons.messenger_outline),
                                      onPressed: () async {
                                        setState(() {
                                          loadingxx = true;
                                        });
                                        Future.delayed(
                                            const Duration(seconds: 3), (() {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (ctx) => ChatScreens(
                                                      widget.id,
                                                      widget.username,
                                                      widget.storename,
                                                      'business',
                                                      busidx,
                                                      busid2x,
                                                      useridx,
                                                      widget.basicstorename,
                                                      widget.basicusername)));
                                          // setState(() {
                                          //   loadingxx = false;
                                          // });
                                        }));
                                        Future.delayed(
                                            const Duration(seconds: 3), (() {
                                          setState(() {
                                            loadingxx = false;
                                          });
                                        }));
                                        final targ = await FirebaseFirestore
                                            .instance
                                            .collection('listing')
                                            .doc(widget.id.toString())
                                            .get();
                                        final repto = targ.data()![
                                            'post_owner_reply_to_business${widget.storename}'];
                                        FirebaseFirestore.instance
                                            .collection('listing')
                                            .doc(widget.id.toString())
                                            .update({
                                          'post_owner_seen_by_business${widget.storename}':
                                              repto
                                        });
                                        final chox = await FirebaseFirestore
                                            .instance
                                            .collection('business_details')
                                            .where('second_uid',
                                                isEqualTo: FirebaseAuth
                                                    .instance.currentUser!.uid)
                                            .get();
                                        final busid =
                                            chox.docs.last.data()['first_uid'];
                                        final busid2 = FirebaseAuth
                                            .instance.currentUser!.uid;
                                        final userid = targ.data()!['userid'];

                                        print(widget.id);
                                        print(widget.username);
                                        print(widget.storename);
                                        print(busid);
                                        print(busid2);
                                        print(userid);
                                        // Navigator.of(context).push(
                                        //     MaterialPageRoute(
                                        //         builder: (ctx) => ChatScreens(
                                        //             widget.id,
                                        //             widget.username,
                                        //             widget.storename,
                                        //             'business',
                                        //             busid,
                                        //             busid2,
                                        //             userid,
                                        //             widget.basicstorename,
                                        //             widget.basicusername)));
                                        // setState(() {
                                        //   loadingxx = false;
                                        // });
                                      },
                                    ),
                                  );
                      })
                  : const SizedBox(),
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
                      final listdoc = await FirebaseFirestore.instance
                          .collection('listing')
                          .doc(widget.id)
                          .get();
                      final city = listdoc.data()!['city'];
                      final category = listdoc.data()!['category'];

                      final chox = await FirebaseFirestore.instance
                          .collection('business_details')
                          .where('second_uid',
                              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                          .get();
                      setState(() {
                        cityx = city;
                        categoryx = category;
                        useridx = listdoc.data()!['userid'];
                        busidx = chox.docs.first.data()['first_uid'];
                      });
                    }

                    setState(() {
                      loading = true;
                      //  loadingxx = false;
                    });
                  }),
            ])),
          ]),
        ));
  }
}
