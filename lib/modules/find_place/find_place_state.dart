import 'package:equatable/equatable.dart';

import '../../data/model/list_places_model.dart';
import '../persons_page/persons_page_state.dart';

enum FindPlaceStatus { initial, success, failure, refresh, search }

class FindPlaceState extends Equatable {
  final FindPlaceStatus status;
  final List<PlacesModel> lPlayList;
  final bool isReadEnd;
  final bool isLoading;
  final bool isShowMap;

  const FindPlaceState(
      {this.status = FindPlaceStatus.initial,
      this.isShowMap = false,
      this.lPlayList = const <PlacesModel>[],
      this.isReadEnd = false,
      this.isLoading = true});

  FindPlaceState copyWith(
          {FindPlaceStatus? status,
          List<PlacesModel>? lPlayList,
          bool? isReadEnd,
          bool? isShowMap,
          bool? isLoading}) =>
      FindPlaceState(
          isLoading: isLoading ?? this.isLoading,
          isShowMap: isShowMap ?? this.isShowMap,
          status: status ?? this.status,
          lPlayList: lPlayList ?? this.lPlayList,
          isReadEnd: isReadEnd ?? this.isReadEnd);

  @override
  List<Object?> get props =>
      [status, lPlayList, isReadEnd, isLoading, isShowMap];
}
