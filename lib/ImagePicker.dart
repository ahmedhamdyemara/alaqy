import 'package:intl/intl_standalone.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  static const routeName = '/UserImagePicker';

  const UserImagePicker(this.imagePickFn);

  final void Function(File? pickedImage) imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      // final pickedImageFile = await ImagePicker.platform.pickImage(
//.pickImage(

      source: ImageSource.gallery,
      imageQuality: 100,
      //   maxWidth: 150,
    );
    File? pickedImageFile;
    pickedImage != null ? pickedImageFile = File(pickedImage.path) : null;

    setState(() {
      pickedImage != null ? _pickedImage = pickedImageFile : null;
    });
    widget.imagePickFn(pickedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage as File) : null,
        ),
        TextButton.icon(
          //     textColor: Theme.of(context).primaryColor,
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: const Text('Add Logo'),
        ),
      ],
    );
  }
}
