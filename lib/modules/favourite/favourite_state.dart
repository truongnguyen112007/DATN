import 'package:base_bloc/components/sort_widget.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import '../../data/model/filter_param.dart';
import '../../data/model/routes_model.dart';
import '../../data/model/sort_param.dart';
import '../tab_home/tab_home_state.dart';

enum FavType { Default, Sort, Filter }

class FavouriteState extends Equatable {
  FavType favType;
  final FeedStatus status;
  final List<RoutesModel> lPlayList;
  final bool isReadEnd;
  final bool isLoading;
  final bool isShowAdd;
  final bool isClickRadioButton;
  final bool isShowActionButton;
  final int timeStamp;
  final int nextPage;
  late SortParam? sort;
  late FilterParam? filter;

  FavouriteState({
    this.favType = FavType.Default,
    this.status = FeedStatus.initial,
    this.lPlayList = const <RoutesModel>[],
    this.isReadEnd = false,
    this.timeStamp = 0,
    this.isLoading = true,
    this.isShowAdd = true,
    this.isClickRadioButton = false,
    this.isShowActionButton = false,
    this.nextPage = 1,
    this.sort,
    this.filter,
  });

  FavouriteState copyWith({
    FavType? favType,
    FeedStatus? status,
    List<RoutesModel>? lPlayList,
    int? timeStamp,
    bool? isReadEnd,
    bool? isLoading,
    bool? isShowAdd,
    bool? isClickRadioButton,
    bool? isShowActionButton,
    int? nextPage,
    SortParam? sort,
    FilterParam? filter,
  }) =>
      FavouriteState(
        favType: favType ?? this.favType,
        timeStamp: timeStamp ?? this.timeStamp,
        isLoading: isLoading ?? this.isLoading,
        status: status ?? this.status,
        lPlayList: lPlayList ?? this.lPlayList,
        isReadEnd: isReadEnd ?? this.isReadEnd,
        isShowAdd: isShowAdd ?? this.isShowAdd,
        isClickRadioButton: isClickRadioButton ?? this.isClickRadioButton,
        isShowActionButton: isShowActionButton ?? this.isShowActionButton,
        nextPage: nextPage ?? this.nextPage,
        sort: sort ?? this.sort,
        filter: filter ?? this.filter,
      );

  @override
  List<Object?> get props => [
        favType,
        status,
        lPlayList,
        isReadEnd,
        isLoading,
        isShowAdd,
        isClickRadioButton,
        isShowActionButton,
        timeStamp,
        nextPage,
        sort,
        filter,
      ];
}
