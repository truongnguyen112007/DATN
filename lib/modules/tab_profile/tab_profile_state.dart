import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
 class TabProfileState extends Equatable {
  final int? timeStamp;

  const TabProfileState({this.timeStamp});
  @override
  List<Object?> get props => [timeStamp];
}
