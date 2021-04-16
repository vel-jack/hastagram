import 'package:flutter/material.dart';
import 'package:hastagram/model/post_model.dart';
import 'package:hastagram/ui/saved_posts.dart';
import 'package:hastagram/widgets/hashtags_view.dart';
import 'package:hastagram/widgets/new_post.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  String currentTag = '';
  String postType = 'Top';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Hashtagram'), elevation: 0, actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              tooltip: 'Refresh',
              onPressed: () {
                Hive.box('hashtags').keys.cast<String>().forEach((element) {
                  if (Hive.isBoxOpen(element)) {
                    Box<InstaPost> a = Hive.box(element);
                    a.deleteAll(a.keys);
                  }
                });
              }),
          IconButton(
              tooltip: 'Saved Posts',
              icon: Icon(Icons.bookmark),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                  return SavedPosts();
                }));
              }),
          PopupMenuButton(
              tooltip: 'More',
              onSelected: (value) async {
                if (value == 1) {
                  String urlString =
                      'https://vel-jack.github.io/nothingbox/policy/hashtagram';
                  if (await canLaunch(urlString)) {
                    launch(urlString);
                  }
                }
              },
              itemBuilder: (ctx) {
                return [
                  PopupMenuItem(
                    child: Text('Privacy policy'),
                    value: 1,
                  )
                ];
              })
        ]),
        body: Column(
          children: [
            HashTagsView(
              onBuild: (value) {
                setState(() {
                  currentTag = value;
                });
              },
              onSelected: (hashtag) {
                setState(() {
                  currentTag = hashtag;
                });
              },
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: Text(
                  '#$currentTag',
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueAccent),
                ),
              ),
              Expanded(flex: 1, child: Container()),
              DropdownButton<String>(
                  value: postType,
                  onChanged: (value) {
                    setState(() {
                      postType = value;
                    });
                    Hive.box('hashtags').keys.cast<String>().forEach((element) {
                      if (Hive.isBoxOpen(element)) {
                        Box<InstaPost> a = Hive.box(element);
                        a.deleteAll(a.keys);
                      }
                    });
                  },
                  items: [
                    DropdownMenuItem<String>(child: Text('Top'), value: 'Top'),
                    DropdownMenuItem<String>(child: Text('New'), value: 'New'),
                  ])
            ]),
            SizedBox(height: 10),
            // PostsView(hash: currentTag),
            Flexible(
              child: FutureBuilder(
                builder: (ctx, snapshot) {
                  if (snapshot.hasData) {
                    return NewView(
                      hash: snapshot.data as Box<InstaPost>,
                      postType: postType,
                    );
                  } else {
                    return Text('Please Restart the App');
                  }
                },
                future: Hive.openBox<InstaPost>(currentTag),
              ),
            )
          ],
        ));
  }
}
