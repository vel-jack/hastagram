import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hastagram/model/post_model.dart';

Future<List<InstaPost>> fetchData(String hash, String postType) async {
  List<InstaPost> id = [];

  //https://www.instagram.com/explore/tags/tamizhan/?__a=1
  // https://raw.githubusercontent.com/vel-jack/nothingbox/master/hashtagram/sampledata.html
  Uri url = Uri.https('www.instagram.com', '/explore/tags/$hash', {'__a': '1'});
  // Uri.https('raw.githubusercontent.com',
  //     '/vel-jack/nothingbox/master/hashtagram/sampledata.html');
  try {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var toppost = postType == 'Top'
          ? jsonData['graphql']['hashtag']['edge_hashtag_to_top_posts']['edges']
          : jsonData['graphql']['hashtag']['edge_hashtag_to_media']['edges'];

      for (var post in toppost) {
        // print(post['node']['__typename']);
        var isVideo = post['node']['is_video'];
        var thumbUrl = post['node']['thumbnail_src'];
        var postId = post['node']['id'];
        var shortCode = post['node']['shortcode'];
        id.add(InstaPost(
            isVideo: isVideo,
            thumbnailUrl: thumbUrl,
            id: postId,
            shortCode: shortCode));
      }
    }
    return id;
  } catch (e) {
    return Future.value();
  }
}

Future<String> getVideoUrl(shortCode) async {
  Uri url = Uri.https('www.instagram.com', '/p/$shortCode', {'__a': '1'});
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var jsonData = jsonDecode(response.body);
    var video = jsonData['graphql']['shortcode_media']['video_url'];
    return video;
  }
  return Future.value();
}

List<String> getSuggestedTags() {
  List<String> tags = [
    'apple',
    'acer',
    'adidas',
    'allah',
    'art',
    'bahrain',
    'emirates',
    'boat',
    'education',
    'falls',
    'feelings',
    'gift',
    'god',
    'horse',
    'highway',
    'health',
    'kfc',
    'king',
    'love',
    'mango',
    'cat',
    'dog',
    'snake',
    'food',
    'night',
    'peace',
    'rose',
    'ride',
    'study',
    'flutter',
    'instagram',
    'speed',
    'spider',
    'trick',
    'truck',
    'sky',
    'tshirt',
    'usa',
    'india',
    'pakistan',
    'china',
    'america',
    'football',
    'hollywood',
    'movies'
  ];
  tags.shuffle();

  return tags.sublist(0, 5);
}
