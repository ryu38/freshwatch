import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freshwatch/features/database.dart';
import 'package:freshwatch/models/post.dart';
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

  @override
  Widget build(BuildContext context) {

    final _dailyPosts = Provider.of<DailyVegePosts>(context, listen: false);

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          const SizedBox(
            width: double.infinity,
            child: Text(
              'Adding new Vege',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          TextFormField(
            validator: (val) => val?.isEmpty == true ? 'Enter a name' : null,
            onChanged: (val) {
              setState(() => _name = val);
            },
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            validator: (val) => val == '' ? 'Enter an amount' : null,
            onChanged: (val) {
              final valueNum = val == '' ? 0 : int.parse(val);
              setState(() => _gram = valueNum);
            },
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
                ),
                child: const Text('add'),
                onPressed: () async {
                  if (_formKey.currentState?.validate() == true) {
                    final newPost = VegePost(
                      name: _name, gram: _gram,
                    );
                    await _dailyPosts.addPost(newPost);
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}