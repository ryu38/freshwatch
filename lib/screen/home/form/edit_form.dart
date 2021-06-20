import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:freshwatch/features/database.dart';
import 'package:freshwatch/models/post.dart';
import 'package:provider/provider.dart';

class EditForm extends StatefulWidget {
  const EditForm({
    Key? key,
    required this.index,
  }) : 
    super(key: key);

  final int index;

  @override
  _EditFormState createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {

  final _formKey = GlobalKey<FormState>();

  String _name = '';
  int _gram = 0;

  @override
  Widget build(BuildContext context) {

    final _dailyPosts = Provider.of<DailyVegePosts>(context, listen: false);
    final _targetPost = _dailyPosts.posts[widget.index];

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          const SizedBox(
            width: double.infinity,
            child: Text(
              'Editing Vege',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          TextFormField(
            initialValue: _targetPost.name,
            validator: (val) => val?.isEmpty == true ? 'Enter a name' : null,
            onChanged: (val) {
              setState(() => _name = val);
            },
          ),
          TextFormField(
            initialValue: _targetPost.gram.toString(),
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
                    await _dailyPosts.updatePost(widget.index, newPost);
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