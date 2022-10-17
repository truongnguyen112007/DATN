import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class HomeState extends Equatable {}

class InitState extends HomeState {
  @override
  List<Object?> get props => [];
}

class HideBottomNavigationBarState extends HomeState {
  final bool isHide;

  HideBottomNavigationBarState(this.isHide);

  @override
  List<Object?> get props => [isHide];
}

class IndexChangeState extends HomeState {
  final int index;

  IndexChangeState(this.index);

  @override
  List<Object?> get props => [index];
}
