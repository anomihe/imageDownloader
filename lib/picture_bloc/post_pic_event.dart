// part of 'post_pic_event.dart';

abstract class PictureEvent {}

class PostInitialEvent extends PictureEvent {}

class DownloadImage extends PictureEvent {
  final String link;

  DownloadImage({required this.link});
}
