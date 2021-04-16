import 'package:flutter/material.dart';
import 'package:hastagram/model/post_model.dart';
import 'package:hastagram/widgets/thumbnail_post.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'media_view.dart';

class SavedPosts extends StatefulWidget {
  SavedPosts({Key key}) : super(key: key);

  @override
  _SavedPostsState createState() => _SavedPostsState();
}

class _SavedPostsState extends State<SavedPosts> {
  Box<InstaPost> savedPost;
  @override
  void initState() {
    savedPost = Hive.box<InstaPost>('savedpost');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Saved Posts'),
      ),
      body: ValueListenableBuilder(
        valueListenable: savedPost.listenable(),
        builder: (BuildContext context, dynamic snapshot, Widget child) {
          List<String> keys = snapshot.keys.cast<String>().toList();
          if (keys.length > 0) {
            return GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: List.generate(snapshot.length, (i) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return MediaView(
                            title: '', instaPost: snapshot.get(keys[i]));
                      }));
                    },
                    child: Hero(
                      tag: '${snapshot.get(keys[i]).id}',
                      child: ThumbnailPost(
                        instaPost: snapshot.get(keys[i]),
                      ),
                    ),
                  );
                }));
          } else {
            return Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(Icons.bookmarks_outlined),
                  Text('You don\'t have any saved post'),
                  SizedBox(height: 100)
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
