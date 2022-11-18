import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable{}

class InitSearchState extends SearchState {
  @override
  List<Object?> get props => [];
}

class ChangeTabState extends SearchState{

  final int index;

  ChangeTabState (this.index);

  @override
  List<Object?> get props => [index];
}
