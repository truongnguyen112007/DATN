import 'package:equatable/equatable.dart';
import '../../data/model/filter_param.dart';
import '../../data/model/routes_model.dart';
import '../../data/model/sort_param.dart';
import '../favourite/favourite_state.dart';

enum RouteStatus { initial, success, failure, refresh, search }

enum SearchRouteType { Default, Sort, Filter }

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
  SearchRouteType typeSearchRoute;
  late SortParam? sort;
  final int nextPage;
  late FilterParam? filter;

  RoutesPageState({
    this.typeSearchRoute = SearchRouteType.Default,
    this.keySearch = '',
    this.status = RouteStatus.initial,
    this.lRoutes = const <RoutesModel>[],
    this.isReadEnd = false,
    this.isLoading = true,
    this.timeStamp = 0,
    this.nextPage = 1,
    this.isShowAdd = true,
    this.sort,
    this.isClickRadioButton = false,
    this.isShowActionButton = false,
    this.filter,
  });

  RoutesPageState copyWith({
    RouteStatus? status,
    SearchRouteType? typeSearchRoute,
    String? keySearch,
    List<RoutesModel>? lRoutes,
    bool? isReadEnd,
    int? nextPage,
    bool? isLoading,
    int? timeStamp,
    bool? isShowAdd,
    SortParam? sort,
    bool? isClickRadioButton,
    bool? isShowActionButton,
    FilterParam? filter,
  }) =>
      RoutesPageState(
        typeSearchRoute: typeSearchRoute ?? this.typeSearchRoute,
        keySearch: keySearch ?? this.keySearch,
        nextPage: nextPage ?? this.nextPage,
        timeStamp: timeStamp,
        isLoading: isLoading ?? this.isLoading,
        status: status ?? this.status,
        lRoutes: lRoutes ?? this.lRoutes,
        isReadEnd: isReadEnd ?? this.isReadEnd,
        isShowAdd: isShowAdd ?? this.isShowAdd,
        sort: sort ?? this.sort,
        isClickRadioButton: isClickRadioButton ?? this.isClickRadioButton,
        isShowActionButton: isShowActionButton ?? this.isShowActionButton,
        filter: filter ?? this.filter,
      );

  @override
  List<Object?> get props => [
        status,
        lRoutes,
        isReadEnd,
        isLoading,
        timeStamp,
        isShowAdd,
        isClickRadioButton,
        isShowActionButton,
        typeSearchRoute,
        sort,
        filter,
      ];
}
