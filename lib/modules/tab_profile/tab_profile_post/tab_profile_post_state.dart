import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../data/model/feed_model.dart';

enum ProfilePostStatus { initial, success, failure, refresh }

class TabProfilePostState extends Equatable {
  final List<FeedModel> lFeed;
  final bool readEnd;
  final int currentPage;
  final ProfilePostStatus status;

  const TabProfilePostState(
      {this.readEnd = false,
        this.currentPage = 1,
        this.lFeed = const <FeedModel>[],
        this.status = ProfilePostStatus.initial});

  @override
  List<Object?> get props =>
      [lFeed, readEnd, currentPage];

  @override
  String toString() {
    return "TAB PROFILE POST STATE: lFeed readEnd currentPage";
  }

  TabProfilePostState copyOf(
      {List<FeedModel>? lFeed,
        bool? readEnd,
        int? currentPage,
        ProfilePostStatus? status}) =>
      TabProfilePostState(
          lFeed: lFeed ?? this.lFeed,
          readEnd: readEnd ?? this.readEnd,
          currentPage: currentPage ?? this.currentPage,
          status: status ?? this.status);
}
