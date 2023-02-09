import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final String errorPhone;
  final String errorPassword;

  const LoginState({
    this.errorPhone = '',
    this.errorPassword = '',
  });

  @override
  List<Object?> get props => [errorPhone, errorPassword];

  LoginState copyOf({String? errorPhone, String? errorPassword}) => LoginState(
      errorPhone: errorPhone ?? this.errorPhone,
      errorPassword: errorPassword ?? this.errorPassword);
}
