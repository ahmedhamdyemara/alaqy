import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:intl/intl_standalone.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePickerForm extends StatefulWidget {
  static const routeName = '/UserImagePicker';
  final void Function(dynamic pickedImage) imagePickFn;
  final dynamic pik;
  final bool click;
  const UserImagePickerForm(this.imagePickFn, this.pik, this.click);

  @override
  _UserImagePickerFormState createState() => _UserImagePickerFormState();
}

class _UserImagePickerFormState extends State<UserImagePickerForm> {
  dynamic _pickedImage;

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      // final pickedImageFile = await ImagePicker.platform.pickImage(
//.pickImage(

      source: ImageSource.gallery,
      imageQuality: 100,
      //   maxWidth: 150,
    );
    dynamic pickedImageFile;
    pickedImage != null ? pickedImageFile = File(pickedImage.path) : null;

    setState(() {
      pickedImage != null ? _pickedImage = pickedImageFile : null;
    });
    widget.imagePickFn(pickedImageFile);
  }

  void _pickImagex() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      // final pickedImageFile = await ImagePicker.platform.pickImage(
//.pickImage(

      source: ImageSource.camera,
      imageQuality: 100,
      //   maxWidth: 150,
    );
    dynamic pickedImageFile;
    pickedImage != null ? pickedImageFile = File(pickedImage.path) : null;

    setState(() {
      pickedImage != null ? _pickedImage = pickedImageFile : null;
    });
    widget.imagePickFn(pickedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      const Text(
        'choose image',
        style: TextStyle(color: Colors.blue, fontStyle: FontStyle.italic),
      ),
      Container(
        width: 100,
        height: 100,
        margin: const EdgeInsets.only(
          top: 8,
          right: 10,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.grey,
          ),
        ),
        child: FittedBox(
          child: _pickedImage == null
              ? widget.pik == null
                  ? const SizedBox()
                  : Image.network(
                      widget.pik,
                      fit: BoxFit.fill,
                    )
              : Image.file(
                  _pickedImage,
                  fit: BoxFit.fill,
                ),
        ),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
        IconButton(
          color: Colors.blue,
          onPressed: widget.click == true ? null : _pickImage,
          icon: const Icon(Icons.image),
          // label: const Text('Add Logo'),
        ),
        IconButton(
          color: Colors.blue,
          onPressed: widget.click == true
              ? null
              :
//             showDialog(
//               context: context,
//               builder: (ctx) => AlertDialog(
//                 title: const Text('updated successfully!'),
//                 content: const CircularProgressIndicator(),
//                 actions: <Widget>[
//                   TextButton(
//                     child: AnimatedTextKit(
//                       animatedTexts: [
//                         TyperAnimatedText(
//                           '',
//                           textStyle: const TextStyle(
//                             fontSize: 20,
//                             color: Colors.cyanAccent,
//                             overflow: TextOverflow.visible,
//                           ),
//                           speed: const Duration(seconds: 3),
//                         )
//                       ],
//                       totalRepeatCount: 2,
//                       // repeatForever: true,
//                       onNext: (p1, p2) {
// //  Navigator.of(context).pushReplacementNamed(UpdateUser.routeName);
//                         Navigator.of(ctx).pop(false);
//                       },
//                     ),
//                     onPressed: () {},
//                   ),
//                 ],
//               ),
//             );
              _pickImagex,

          icon: const Icon(Icons.camera_alt),
          // label: const Text('Add Logo'),
        ),
      ]),
    ]);
  }
}









//  Container(
//                                         width: 100,
//                                         height: 100,
//                                         margin: EdgeInsets.only(
//                                           top: 8,
//                                           right: 10,
//                                         ),
//                                         decoration: BoxDecoration(
//                                           border: Border.all(
//                                             width: 1,
//                                             color: Colors.grey,
//                                           ),
//                                         ),
//                                         child: _imageUrlController.text.isEmpty
//                                             ? Text('Enter a URL')
//                                             : FittedBox(
//                                                 child: Image.network(
//                                                   _imageUrlController.text,
//                                                   fit: BoxFit.fill,
//                                                 ),
//                                               ),
//                                       ),



//  CircleAvatar(
//           radius: 40,
//           backgroundColor: Colors.grey,
//           backgroundImage:
//               _pickedImage != null ? FileImage(_pickedImage as File) : null,
//         ),