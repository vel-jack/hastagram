import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hastagram/model/post_model.dart';
import 'package:hastagram/util/util.dart';
import 'package:hive/hive.dart';

class HashTagManager extends StatefulWidget {
  HashTagManager({Key key}) : super(key: key);

  @override
  _HashTagManagerState createState() => _HashTagManagerState();
}

class _HashTagManagerState extends State<HashTagManager> {
  Box _hashtagbox;
  List<String> _hashtags = [];
  List<Box<InstaPost>> _deletedTags = [];
  List<String> _suggestedTags = [];
  Random r = new Random();
  TextEditingController _addController;
  @override
  void initState() {
    _addController = TextEditingController();
    _hashtagbox = Hive.box('hashtags');
    _hashtags = _hashtagbox.values.cast<String>().toList();
    _suggestedTags = getSuggestedTags();
    super.initState();
  }

  @override
  void dispose() {
    _addController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Hashtags'),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (_hashtagbox.isNotEmpty) {
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Add at least one hashtag')));
            }
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              if (_hashtags.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Add at least one hashtag')));
                return;
              }
              _deletedTags.forEach((element) {
                element.deleteAll(element.keys);
              });
              _hashtagbox.deleteAll(_hashtagbox.keys);

              _hashtags.forEach((element) async {
                _hashtagbox.put(element, element);
              });

              Navigator.pop(context, _hashtagbox.getAt(0));
            },
            tooltip: 'Done',
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              SizedBox(width: 10),
              Flexible(
                child: TextField(
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      _hashtags.add(_addController.text);
                      _addController.clear();
                      setState(() {});
                    }
                  },
                  controller: _addController,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-z0-9]")),
                  ],
                  maxLength: 30,
                  decoration: InputDecoration(
                    prefix: Text('#'),
                    counterText: '',
                    hintText: 'Add your hashtags here',
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
              ),
              TextButton(
                  onPressed: () {
                    if (_addController.text.isNotEmpty) {
                      _hashtags.add(_addController.text);
                      _addController.clear();
                      setState(() {});
                    }
                  },
                  child: Text('Add')),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView(children: [
              Wrap(
                children: List.generate(_hashtags.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Chip(
                        backgroundColor: Colors.blueAccent,
                        deleteIconColor: Colors.white,
                        label: Text(
                          '#${_hashtags[i]}',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                        onDeleted: () {
                          if (Hive.isBoxOpen(_hashtags[i])) {
                            _deletedTags.add(Hive.box(_hashtags[i]));
                          }
                          _hashtags.removeAt(i);

                          setState(() {});
                        },
                        deleteIcon: Icon(Icons.close)),
                  );
                }).toList(),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Text('Suggested tags:'),
              ),
              Wrap(
                children: List.generate(_suggestedTags.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Chip(
                      backgroundColor: Colors.cyan,
                      deleteIconColor: Colors.white,
                      label: Text(
                        '#${_suggestedTags[i]}',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      onDeleted: () {
                        _hashtags.add(_suggestedTags.removeAt(i));
                        setState(() {});
                      },
                      deleteIcon: Icon(Icons.add),
                      deleteButtonTooltipMessage: 'Add',
                    ),
                  );
                }).toList(),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
