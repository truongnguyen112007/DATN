import 'package:equatable/equatable.dart';

class RegisterState extends Equatable {
  final String errorName;
  final String errorPhone;
  final String errorPassword;
  final String errorCfPassword;

  const RegisterState({
    this.errorName = '',
    this.errorPhone = '',
    this.errorPassword = '',
    this.errorCfPassword = '',
  });

  @override
  List<Object?> get props =>
      [errorName, errorPhone, errorPassword, errorCfPassword];

  RegisterState copyOf(
          {String? errorName,
          String? errorPhone,
          String? errorPassword,
          String? errorCfPassword}) =>
      RegisterState(
          errorName: errorName ?? this.errorName,
          errorPhone: errorPhone ?? this.errorPhone,
          errorPassword: errorPassword ?? this.errorPassword,
          errorCfPassword: errorCfPassword ?? this.errorCfPassword);
}
