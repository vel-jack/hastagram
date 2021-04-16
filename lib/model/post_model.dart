import 'package:hive/hive.dart';
part 'post_model.g.dart';

@HiveType(typeId: 1)
class InstaPost {
  @HiveField(0)
  String id;
  @HiveField(1)
  bool isVideo;
  @HiveField(2)
  String thumbnailUrl;
  @HiveField(3)
  String shortCode;
  InstaPost({this.isVideo, this.thumbnailUrl, this.id, this.shortCode});
}
