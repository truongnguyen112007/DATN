import 'package:equatable/equatable.dart';

abstract class SearchHomeState extends Equatable{}

class InitState extends SearchHomeState {
  @override
  List<Object?> get props => [];
}

class ChangeTabState extends SearchHomeState{

  final int index;

  ChangeTabState (this.index);

  @override
  List<Object?> get props => [index];
}
