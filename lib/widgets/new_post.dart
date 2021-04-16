import 'package:flutter/material.dart';
import 'package:hastagram/model/post_model.dart';
import 'package:hastagram/ui/media_view.dart';
import 'package:hastagram/util/util.dart';
import 'package:hastagram/widgets/thumbnail_post.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NewView extends StatefulWidget {
  NewView({Key key, this.hash, this.postType}) : super(key: key);
  final Box<InstaPost> hash;
  final String postType;
  @override
  _NewViewState createState() => _NewViewState();
}

class _NewViewState extends State<NewView> {
  Map<String, List<InstaPost>> bigMap = Map<String, List<InstaPost>>();
  String oldBox = '';
  ScrollController _scrollController;
  @override
  void initState() {
    bigMap = {};
    oldBox = widget.hash.name;
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        loadToHive();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder(
          valueListenable: widget.hash.listenable(),
          builder:
              (BuildContext context, Box<InstaPost> snapshot, Widget child) {
            if (snapshot.length > 0) {
              List<int> keys = snapshot.keys.cast<int>().toList();
              // return ListView.builder(
              //   shrinkWrap: true,
              //   controller: _scrollController,
              //   physics: ScrollPhysics(),
              //   itemCount: snapshot.length,
              //   itemBuilder: (BuildContext context, int index) {
              //     return Text(snapshot.get(keys[index]).shortCode);
              //   },
              // );

              return Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        children: List.generate(snapshot.length, (i) {
                          if (oldBox != widget.hash.name &&
                              _scrollController.hasClients) {
                            _scrollController.jumpTo(0);
                            oldBox = widget.hash.name;
                          }
                          return InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (ctx) {
                                return MediaView(
                                    title: '#${widget.hash.name}',
                                    instaPost: snapshot.get(keys[i]));
                              }));
                            },
                            child: Hero(
                              tag: '${snapshot.get(keys[i]).id}',
                              child: ThumbnailPost(
                                instaPost: snapshot.get(keys[i]),
                              ),
                            ),
                          );
                        })),
                  ),
                ),
              );
            } else {
              fetchData(widget.hash.name, widget.postType).then((value) {
                if (value != null) {
                  List<InstaPost> postData = [];
                  value.forEach((element) {
                    postData.add(element);
                    // widget.hash.put(element.id, element);
                  });
                  bigMap[widget.hash.name] = postData;

                  loadToHive();
                }
              });
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ],
    );
  }

  void loadToHive() {
    var start = widget.hash.length;
    var end = start + 18;
    if (end > bigMap[widget.hash.name].length) {
      end = bigMap[widget.hash.name].length;
    }
    print(end);
    for (int i = start; i < end; i++) {
      widget.hash.add(bigMap[widget.hash.name][i]);
    }
  }
}
