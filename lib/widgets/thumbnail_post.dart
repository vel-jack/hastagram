import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hastagram/model/post_model.dart';

class ThumbnailPost extends StatelessWidget {
  const ThumbnailPost({Key key, this.instaPost}) : super(key: key);
  final InstaPost instaPost;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(2),
      child: Stack(
        children: [
          CachedNetworkImage(imageUrl: instaPost.thumbnailUrl),
          if (instaPost.isVideo)
            Positioned(
                right: 2,
                top: 2,
                child: Icon(
                  Icons.slideshow,
                  color: Colors.white,
                ))
        ],
      ),
    );
  }
}
