import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class TabProfileState extends Equatable {}

class TabProfileInitialState extends TabProfileState {
  @override
  List<Object?> get props => [];
}