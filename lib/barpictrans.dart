import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'barpictranspicker.dart';

class Barpictrans extends StatefulWidget {
  Barpictrans(
    this.submitFn,
  );

  final void Function(
    String title,
    File? image,
    BuildContext ctx,
  ) submitFn;

  @override
  _BarpictransState createState() => _BarpictransState();
}

class _BarpictransState extends State<Barpictrans> {
  final _formKey = GlobalKey<FormState>();

  var _title = Timestamp.now().toString();
  File? _userImageFile;
  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please pick an image.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    _formKey.currentState!.save();
    widget.submitFn(
      _title,
      _userImageFile,
      context,
    );
    {
      setState(() {
        _usecash = !_usecash;
      });
    }
  }

  void _pickedImage(File? image) {
    print('nnnnnnnnn');
    _userImageFile = image;
    print('zzzzzzzz');

    _trySubmit();
    print('vvvvvvvvv');
  }

  bool _usecash = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(4),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Barpictranspicker(
                    _pickedImage,
                  ),
                  // IconButton(
                  //   icon: Icon(Icons.send_and_archive),
                  //   onPressed: _trySubmit,
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
