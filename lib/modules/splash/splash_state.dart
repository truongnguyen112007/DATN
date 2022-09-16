import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
abstract class SplashState extends Equatable {}

class InitState extends SplashState {
  @override
  List<Object?> get props => [];
}
class OpenHomeState extends SplashState {
  @override
  List<Object?> get props => [DateTime.now().millisecondsSinceEpoch];
}
