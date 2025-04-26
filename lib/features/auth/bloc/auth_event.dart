abstract class AuthEvent {}

class RegisterEvent extends AuthEvent {
  final String username;
  final String password;

  RegisterEvent(this.username, this.password);
}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;
  final bool isSaveAccount;

  LoginEvent(this.username, this.password, this.isSaveAccount);
}
