import 'package:base_bloc/data/model/user_profile_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
 class TabProfileState extends Equatable {
  final int? timeStamp;
  final UserProfileModel? model;

   TabProfileState({this.timeStamp, this.model});
  @override
  List<Object?> get props => [timeStamp,model];
}
