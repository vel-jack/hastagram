import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:hastagram/model/post_model.dart';
import 'package:hastagram/util/util.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';

class MediaView extends StatefulWidget {
  const MediaView({Key key, this.instaPost, this.title}) : super(key: key);
  final InstaPost instaPost;
  final String title;
  @override
  _MediaViewState createState() => _MediaViewState();
}

class _MediaViewState extends State<MediaView> {
  VideoPlayerController videoPlayerController;
  ChewieController chewieController;
  bool isVideo = false;
  Box<InstaPost> savedPost;
  @override
  void initState() {
    isVideo = widget.instaPost.isVideo;
    savedPost = Hive.box('savedpost');
    if (isVideo) {
      initPlayer();
    }
    super.initState();
  }

  void initPlayer() async {
    await getVideoUrl(widget.instaPost.shortCode).then((value) {
      videoPlayerController = VideoPlayerController.network(value);
    });
    await videoPlayerController.initialize();
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
    );
    setState(() {});
  }

  @override
  void dispose() {
    if (isVideo) {
      videoPlayerController.dispose();
      chewieController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('${widget.title}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Hero(
              tag: '${widget.instaPost.id}',
              child: Center(
                child: isVideo
                    ? chewieController != null &&
                            chewieController
                                .videoPlayerController.value.isInitialized
                        ? Chewie(
                            controller: chewieController,
                          )
                        : Stack(
                            children: [
                              // Center(
                              //   child: CachedNetworkImage(
                              //     imageUrl: widget.instaPost.thumbnailUrl,
                              //   ),
                              // ),
                              Center(child: CircularProgressIndicator())
                            ],
                          )
                    : CachedNetworkImage(
                        imageUrl: widget.instaPost.thumbnailUrl,
                      ),
                // : Icon(Icons.image),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.launch),
                  onPressed: () async {
                    String urlString =
                        'https://www.instagram.com/p/${widget.instaPost.shortCode}';
                    if (await canLaunch(urlString)) {
                      launch(urlString);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Can\'t open this link ')));
                    }
                  },
                  tooltip: 'Show original post',
                ),
                IconButton(
                  icon: Icon(Icons.link),
                  onPressed: () {
                    Clipboard.setData(new ClipboardData(
                        text:
                            'www.instagram.com/p/${widget.instaPost.shortCode}'));
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Link Copied')));
                  },
                  tooltip: 'Copy link',
                ),
                IconButton(
                    icon: savedPost.containsKey(widget.instaPost.id)
                        ? Icon(Icons.bookmark)
                        : Icon(Icons.bookmark_outline),
                    onPressed: () {
                      setState(() {
                        if (!savedPost.containsKey(widget.instaPost.id)) {
                          savedPost.put(widget.instaPost.id, widget.instaPost);
                        } else {
                          savedPost.delete(widget.instaPost.id);
                        }
                      });
                    },
                    tooltip: 'Save'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
