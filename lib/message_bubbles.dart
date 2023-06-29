import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MessageBubbles extends StatefulWidget {
  // final Key key;
  final String message;
  final String userName;
  final String userImage;
  final String storeImage;
  final String store_name;
  final bool isMe;
  final String type;
  final String to;
  final String me;
  final String listidflagtyping;
  const MessageBubbles(
      this.message,
      this.userName,
      this.userImage,
      this.storeImage,
      this.store_name,
      this.isMe,
      this.type,
      this.to,
      this.me,
      this.listidflagtyping,
      {super.key});

  @override
  State<MessageBubbles> createState() => _MessageBubblesState();
}

class _MessageBubblesState extends State<MessageBubbles> {
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
  Widget build(BuildContext context) {
    // final oppa = Provider.of<Auth>(context, listen: false).userId;
    final name =
        widget.type == 'business' ? widget.store_name : widget.userName;
    final image =
        widget.type == 'business' ? widget.storeImage : widget.userImage;
    final othername =
        widget.type == 'customer' ? widget.store_name : widget.userName;
    final otherimage =
        widget.type == 'customer' ? widget.storeImage : widget.userImage;

    return (widget.message == widget.to || widget.message == widget.me)
        ? widget.listidflagtyping != 'flag for typing'
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    !widget.isMe
                        ? Text(
                            'seen by ${(othername).trim().replaceAll(RegExp(r'_'), ' ')}')
                        : Text(
                            'seen by ${(name).trim().replaceAll(RegExp(r'_'), ' ')}')
                  ])
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    !widget.isMe
                        ? Text(
                            ' ${(othername).trim().replaceAll(RegExp(r'_'), ' ')} is typing')
                        : Text(
                            ' ${(name).trim().replaceAll(RegExp(r'_'), ' ')} is typing')
                  ])
        : widget.message == 'loadingxbus??!!' ||
                widget.message == 'loadingxcus??!!'
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                clipBehavior: Clip.none,
                children: [
                  Row(
                    mainAxisAlignment: !widget.isMe
                        //    oppa == 'xB1Q3KzEaIUNQGM4Fvf88MqUj1g2'
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: !widget.isMe
                              //   oppa == 'xB1Q3KzEaIUNQGM4Fvf88MqUj1g2'
                              ? Colors.grey[300]
                              : Colors.grey[200],
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(12),
                            topRight: const Radius.circular(12),
                            bottomLeft: widget.isMe
//                      oppa != 'xB1Q3KzEaIUNQGM4Fvf88MqUj1g2'
                                ? const Radius.circular(0)
                                : const Radius.circular(12),
                            bottomRight: !widget.isMe
                                //         oppa == 'xB1Q3KzEaIUNQGM4Fvf88MqUj1g2'
                                ? const Radius.circular(0)
                                : const Radius.circular(12),
                          ),
                        ),
                        width: 140,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        margin: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: !widget.isMe
                              //   oppa == 'xB1Q3KzEaIUNQGM4Fvf88MqUj1g2'
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: <Widget>[
                            SelectableText(
                              !widget.isMe
                                  ? (name).trim().replaceAll(RegExp(r'_'), ' ')
                                  : (othername)
                                      .trim()
                                      .replaceAll(RegExp(r'_'), ' '),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: !widget.isMe
                                    ? Colors.grey.shade700
                                    : Colors.blueGrey,
                              ),
                            ),
                            (widget.message.startsWith(
                                    'https://firebasestorage.googleapis.com/v0/b/alaqy-64208.appspot.com/o/user_image'))
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              fullscreenDialog: true,
                                              builder: (ctx) => GestureDetector(
                                                  onDoubleTapDown:
                                                      _handleDoubleTapDown,
                                                  onDoubleTap: _handleDoubleTap,
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    //   Navigator.of(context).pop();
                                                  },
                                                  child: Center(
                                                      child: InteractiveViewer(
                                                          transformationController:
                                                              _transformationController,
                                                          child: Container(
                                                              child:
                                                                  Image.network(
                                                            widget.message,
                                                            fit: BoxFit.contain,
                                                          )))))));
                                    },
                                    child: Container(
                                        height: 150,
                                        width: double.infinity,
                                        child: Image.network(
                                          widget.message,
                                          fit: BoxFit.fill,
                                        )))
                                : (widget.message.startsWith(
                                        'https://www.google.com/maps/search/?api=1&query='))
                                    ? Center(
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: widget.message,
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                              TextSpan(
                                                text: widget.message,
                                                style: const TextStyle(
                                                    color: Colors.blue),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () {
                                                        launch(widget.message);
                                                      },
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : SelectableText(
                                        widget.message,
                                        style: TextStyle(
                                          color: !widget.isMe
                                              //                        oppa == 'xB1Q3KzEaIUNQGM4Fvf88MqUj1g2'
                                              ? Colors.black
                                              : Colors.black54,
                                        ),
                                        textAlign: !widget.isMe
//                        oppa == 'xB1Q3KzEaIUNQGM4Fvf88MqUj1g2'
                                            ? TextAlign.end
                                            : TextAlign.start,
                                      ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    left: !widget.isMe
//              oppa == 'xB1Q3KzEaIUNQGM4Fvf88MqUj1g2'
                        ? null
                        : 120,
                    right: !widget.isMe
//              oppa == 'xB1Q3KzEaIUNQGM4Fvf88MqUj1g2'
                        ? 120
                        : null,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        !widget.isMe ? image : otherimage,
                      ),
                    ),
                  ),
                ],
              );
  }
}
//https://www.google.com/maps/search/?api=1&query=31.223968,29.948638