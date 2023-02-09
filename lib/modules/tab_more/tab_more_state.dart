import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
 class TabMoreState extends Equatable {
  final int? timeStamp;

  const TabMoreState({this.timeStamp});
  @override
  List<Object?> get props => [timeStamp];
}
