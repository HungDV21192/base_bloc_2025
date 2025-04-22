import 'package:base_code/features/home/bloc/home_event.dart';
import 'package:base_code/features/home/bloc/home_state.dart';
import 'package:base_code/features/home/repository/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc(this.repository) : super(HomeInitial()) {
    on<UploadImageEvent>((event, emit) async {
      emit(HomeUploading());
      try {
        final url = await repository.uploadImage(event.image);
        emit(HomeImageUploaded(url));
      } catch (e) {
        emit(HomeError("Upload thất bại"));
      }
    });
  }
}
