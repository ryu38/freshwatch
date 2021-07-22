import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freshwatch/features/image.dart';
import 'package:freshwatch/models/post.dart';
import 'package:freshwatch/models/user.dart';
import 'package:freshwatch/service/storage.dart';
import 'package:freshwatch/theme/colors.dart';
import 'package:provider/provider.dart';

class PostForm extends StatefulWidget {
  const PostForm({ Key? key }) : super(key: key);

  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {

  final _formKey = GlobalKey<FormState>();

  String _name = '';
  int _gram = 0;
  String? _imagePath;

  Future<String> _imgSaver(BuildContext context, String imgPath) async {
    final userData = Provider.of<UserData?>(context, listen: false) ?? UserData();
    return userData.isLogin
        ? StorageService(userData.uid!).uploadFile(imgPath)
        : ImageController.saveLocalImage(imgPath);
  }

  @override
  Widget build(BuildContext context) {

    final dailyPosts = Provider.of<DailyVegePosts>(context, listen: false);

    Widget imageDisplay() {
      const size = 70.0;

      const gallary = 'gallary';
      const camera = 'camera';
      const delete = 'delete';

      return PopupMenuButton<String>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onSelected: (String commandVal) async {
          String? imagePath;
          switch (commandVal) {
            case gallary:
              imagePath = await ImageController.getFromGallery();
              break;
            case camera:
              imagePath = await ImageController.getFromCamera();
              break;
            case delete:
              setState(() {
                _imagePath = null;
              });
              return;
            default:
              return;
          }

          if (imagePath != null) {
            setState(() {
              _imagePath = imagePath;
            });
          }
        },
        itemBuilder: (context) => <PopupMenuEntry<String>>[
          PopupMenuItem(
            value: camera,
            child: Center(
              child: Text(
                'take photo',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          PopupMenuItem(
            value: gallary,
            child: Center(
              child: Text(
                'choose existing photo',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          PopupMenuItem(
            value: delete,
            child: Center(
              child: Text(
                'delete set photo',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
        child: _imagePath == null
            ? Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                child: const Icon(
                  Icons.photo_camera,
                  color: Colors.grey,
                ),
              )
            : CircleAvatar(
              radius: size / 2,
              backgroundColor: Colors.transparent,
              backgroundImage: Image.file(
                  File(_imagePath!)
                ).image
            ),
      );
    }

    InputDecoration inputDecoration({String? hintText, String? suffixText}) {

      OutlineInputBorder outlineInputBorder(Color color, double width) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(90),
        borderSide: BorderSide(color: color, width: width),
      );

      return InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(90)),
        enabledBorder: outlineInputBorder(Colors.grey, 1),
        focusedBorder: outlineInputBorder(AppColors.main, 2),
        isDense: true,
        contentPadding: const EdgeInsets.all(12),
        hintText: hintText,
        suffixText: suffixText,
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: Text(
              'Adding new Vege',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 25),
          TextFormField(
            decoration: inputDecoration(
              hintText: 'name',
            ),
            inputFormatters: [
              LengthLimitingTextInputFormatter(30),
            ],
            validator: (val) => val?.isEmpty == true ? 'Enter a name' : null,
            onChanged: (val) {
              setState(() => _name = val);
            },
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              imageDisplay(),
              const SizedBox(width: 20),
              Expanded(
                child: TextFormField(
                  decoration: inputDecoration(
                    hintText: 'gram',
                    suffixText: 'g',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  validator: (val) => val == '' ? 'Enter an amount' : null,
                  onChanged: (val) {
                    final valueNum = val == '' ? 0 : int.parse(val);
                    setState(() => _gram = valueNum);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Container(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  primary: AppColors.main,
                ),
                onPressed: () async {
                  if (_formKey.currentState?.validate() == true) {
                    Navigator.pop(context);
                    final imgSavedPath = _imagePath != null
                        ? await _imgSaver(context, _imagePath!) : '';
                    final newPost = VegePost(
                      name: _name, gram: _gram, imgUrl: imgSavedPath,
                    );
                    await dailyPosts.addPost(newPost);
                  }
                },
                child: const Text('add'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}