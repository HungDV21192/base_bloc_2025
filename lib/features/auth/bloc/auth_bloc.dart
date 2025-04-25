import 'package:base_code/features/auth/bloc/auth_event.dart';
import 'package:base_code/features/auth/bloc/auth_state.dart';
import 'package:base_code/features/auth/repository/auth_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repo;

  AuthBloc(this.repo) : super(AuthInitial()) {
    on<RegisterEvent>((event, emit) async {
      await _handleAuth(
        emit,
        () => repo.register(username: event.username, password: event.password),
        failureMessage: 'register_failed'.tr(),
      );
    });

    on<LoginEvent>((event, emit) async {
      await _handleAuth(
        emit,
        () => repo.login(username: event.username, password: event.password),
        failureMessage: 'login_failed'.tr(),
      );
    });
  }

  Future<void> _handleAuth(
    Emitter<AuthState> emit,
    Future<bool> Function() authAction, {
    required String failureMessage,
  }) async {
    emit(AuthLoading());
    try {
      final success = await authAction();
      if (success) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure(failureMessage));
      }
    } catch (e) {
      emit(AuthFailure("Đã xảy ra lỗi: ${e.toString()}"));
    }
  }
}
