import 'package:flutter/material.dart';
import 'package:hastagram/ui/hashtag_manager.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:hastagram/util/helper.dart';

class HashTagsView extends StatefulWidget {
  const HashTagsView({Key key, this.onSelected, this.onBuild})
      : super(key: key);
  final void Function(String value) onSelected;
  final void Function(String value) onBuild;
  @override
  _HashTagsViewState createState() => _HashTagsViewState();
}

class _HashTagsViewState extends State<HashTagsView> {
  Box _hashtagBox;

  @override
  void initState() {
    _hashtagBox = Hive.box('hashtags');
    selectedHashTag = _hashtagBox.values.first;
    WidgetsBinding.instance
        .addPostFrameCallback((_) => widget.onBuild(selectedHashTag));
    super.initState();
  }

  int selectedChip = 0;
  String selectedHashTag = '';
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ValueListenableBuilder(
          valueListenable: _hashtagBox.listenable(),
          builder: (BuildContext context, dynamic value, Widget child) {
            var values = _hashtagBox.values.cast<String>().toList();
            return Flexible(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                      values.length,
                      (index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedChip = index;
                                    selectedHashTag = values[index].toString();
                                  });
                                  widget.onSelected(values[index]);
                                },
                                child: selectedChip == index
                                    ? Chip(
                                        backgroundColor: Colors.blueAccent,
                                        label: Text(
                                          "#${values[index]}",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ))
                                    : Chip(label: Text('#${values[index]}'))),
                          )),
                ),
              ),
            );
          },
        ),
        IconButton(
          icon: Icon(
            Icons.edit,
            color: Colors.blueAccent,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (ctx) {
              return HashTagManager();
            })).then((value) {
              if (value != null) {
                setState(() {
                  selectedChip = 0;
                  selectedHashTag = value;
                });

                widget.onSelected(selectedHashTag);
              }
            });
          },
        ),
      ],
    );
  }
}
