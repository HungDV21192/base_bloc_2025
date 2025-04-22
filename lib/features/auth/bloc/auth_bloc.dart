import 'package:base_code/features/auth/bloc/auth_event.dart';
import 'package:base_code/features/auth/bloc/auth_state.dart';
import 'package:base_code/features/auth/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repo;

  AuthBloc(this.repo) : super(AuthInitial()) {
    on<RegisterEvent>((event, emit) async {
      emit(AuthLoading());
      final success = await repo.register(event.username, event.password);
      success ? emit(AuthSuccess()) : emit(AuthFailure("Đăng ký thất bại"));
    });

    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      final success = await repo.login(event.username, event.password);
      success
          ? emit(AuthSuccess())
          : emit(AuthFailure("Sai tài khoản hoặc mật khẩu"));
    });
  }
}
