import 'package:equatable/equatable.dart';
import '../../data/model/routes_model.dart';

enum RouteStatus { initial, success, failure, refresh, search }

class RoutesPageState extends Equatable {
  final RouteStatus status;
  final List<RoutesModel> lRoutes;
  final bool isReadEnd;
  final bool isLoading;
  final int? timeStamp;
  final bool isShowAdd;
  final bool isClickRadioButton;
  final bool isShowActionButton;
  final String keySearch;
  int nextPage;

  RoutesPageState({
    this.keySearch = '',
    this.status = RouteStatus.initial,
    this.lRoutes = const <RoutesModel>[],
    this.isReadEnd = false,
    this.isLoading = true,
    this.timeStamp = 0,
    this.nextPage = 1,
    this.isShowAdd = true,
    this.isClickRadioButton = false,
    this.isShowActionButton = false,
  });

  RoutesPageState copyWith({
          RouteStatus? status,
          String? keySearch,
          List<RoutesModel>? lRoutes,
          bool? isReadEnd,
          int? nextPage,
          bool? isLoading,
          int? timeStamp,
          bool? isShowAdd,
          bool? isClickRadioButton,
          bool? isShowActionButton}) =>
      RoutesPageState(
          keySearch: keySearch ?? this.keySearch,
          nextPage: nextPage ?? this.nextPage,
          timeStamp: timeStamp,
          isLoading: isLoading ?? this.isLoading,
          status: status ?? this.status,
          lRoutes: lRoutes ?? this.lRoutes,
          isReadEnd: isReadEnd ?? this.isReadEnd,
          isShowAdd: isShowAdd ?? this.isShowAdd,
          isClickRadioButton: isClickRadioButton ?? this.isClickRadioButton,
          isShowActionButton: isShowActionButton ?? this.isShowActionButton);

  @override
  List<Object?> get props => [status, lRoutes, isReadEnd, isLoading, timeStamp,isShowAdd, isClickRadioButton,isShowActionButton];
}
