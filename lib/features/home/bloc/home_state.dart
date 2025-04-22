abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeUploading extends HomeState {}

class HomeImageUploaded extends HomeState {
  final String imageUrl;

  HomeImageUploaded(this.imageUrl);
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
