import 'dart:io';

abstract class HomeEvent {}

class UploadImageEvent extends HomeEvent {
  final File image;

  UploadImageEvent(this.image);
}
