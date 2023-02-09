import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final String errorEmail;
  final String errorPassword;

  const LoginState({this.errorEmail = '', this.errorPassword = '',});

  @override
  List<Object?> get props => [errorEmail, errorPassword];

  LoginState copyOf({String? errorEmail, String? errorPassword}) => LoginState(
      errorEmail: errorEmail ?? this.errorEmail,
      errorPassword: errorPassword ?? this.errorPassword);
}
