import 'package:flutter/material.dart';
import 'package:hastagram/ui/media_view.dart';
import 'package:hastagram/util/util.dart';
import 'package:hastagram/widgets/thumbnail_post.dart';

class PostsView extends StatefulWidget {
  PostsView({Key key, this.hash}) : super(key: key);
  final String hash;
  @override
  _PostsViewState createState() => _PostsViewState();
}

class _PostsViewState extends State<PostsView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: List.generate(snapshot.data.length, (i) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                        return MediaView(instaPost: snapshot.data[i]);
                      }));
                    },
                    child: Hero(
                      tag: '${snapshot.data[i].id}',
                      child: ThumbnailPost(
                        instaPost: snapshot.data[i],
                      ),
                    ),
                  );
                }));
          } else {
            return Center(child: LinearProgressIndicator());
          }
        },
        future: fetchData(widget.hash, 'top'));
  }
}
