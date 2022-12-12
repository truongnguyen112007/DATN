import 'package:base_bloc/modules/favourite/favourite_state.dart';
import 'package:base_bloc/modules/filter_routes/filter_routes_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/filter_param.dart';
import '../../data/model/routes_model.dart';
import '../../data/repository/user_repository.dart';
import '../../router/router_utils.dart';
import '../../utils/log_utils.dart';
import '../../utils/toast_utils.dart';
import '../routes_page/routes_page_state.dart';
import 'filter_routes_page_state.dart';

class FilterRoutesPageCubit extends Cubit<FilterRoutesPageState> {
  var userRepository = UserRepository();
  final FilterType type;

  FilterRoutesPageCubit(this.type) : super(FilterRoutesPageState()) {
    state.filter = FilterParam(
        status: [],
        corner: [],
        authorGradeFrom: 0,
        authorGradeTo: 20,
        userGradeFrom: 0,
        userGradeTo: 20,
        designBy: []);
  }

  void getFavorite() async {
    var response = await userRepository.getFavorite(
      type: FavType.Filter,
      nextPage: 1,
      status: state.filter?.status != null && state.filter!.status.isNotEmpty
          ? state.filter?.status[0][state.filter?.status[0].keys.first]
          : null,
      hasConner: state.filter?.corner != null && state.filter!.corner.isNotEmpty
          ? state.filter?.corner[0][state.filter?.corner[0].keys.first]
          : null,
      authorGradeFrom: state.filter?.authorGradeFrom,
      authorGradeTo: state.filter?.authorGradeTo,
      userGradeFrom: state.filter?.userGradeFrom,
      userGardeTo: state.filter?.userGradeTo,
      setter:
          state.filter?.designBy != null && state.filter!.designBy.isNotEmpty
              ? state.filter?.designBy[0][state.filter?.designBy[0].keys.first]
              : null,
    );
    if (response.data != null && response.error == null) {
      try {
        var lResponse = routeModelFromJson(response.data);
        emit(state.copyWith(lPlayList: lResponse));
      } catch (e) {
        emit(state.copyWith(lPlayList: []));
      }
    } else {
      toast(response.error.toString());
    }
  }


  void getSearchRoute() async{
    var response = await userRepository.searchRoute(
      type: SearchRouteType.Filter,
      nextPage: 1,
      status: state.filter?.status != null && state.filter!.status.isNotEmpty
          ? state.filter?.status[0][state.filter?.status[0].keys.first]
          : null,
      hasConner: state.filter?.corner != null && state.filter!.corner.isNotEmpty
          ? state.filter?.corner[0][state.filter?.corner[0].keys.first]
          : null,
      authorGradeFrom: state.filter?.authorGradeFrom,
      authorGradeTo: state.filter?.authorGradeTo,
      userGradeFrom: state.filter?.userGradeFrom,
      userGardeTo: state.filter?.userGradeTo,
      setter:
      state.filter?.designBy != null && state.filter!.designBy.isNotEmpty
          ? state.filter?.designBy[0][state.filter?.designBy[0].keys.first]
          : null,
    );
    if (response.data != null && response.error == null) {
      try {
        var lResponse = routeModelBySearchFromJson(response.data);
        emit(state.copyWith(lPlayList: lResponse));
      } catch (e) {
        emit(state.copyWith(lPlayList: []));
      }
    } else {
      toast(response.error.toString());
    }
  }

  void setData(FilterParam? filter) {
    if (filter != null) {
      emit(state.copyWith(
        filter: filter,
      ));
      setType();
    }
  }

  void setStatus(Map<String, dynamic> value, bool isSelect) {
    if (isSelect) {
      state.filter!.status.add(value);
    } else {
      for (int i = 0; i < state.filter!.status.length; i++) {
        if (state.filter!.status[i].keys.first == value.keys.first) {
          state.filter!.status.removeAt(i);
          break;
        }
      }
    }
   setType();
    emit(state.copyWith(timeStamp: DateTime.now().microsecondsSinceEpoch));
  }

  void setCorner(Map<String, dynamic> value, bool isSelect) {
    if (isSelect) {
      state.filter!.corner.add(value);
    } else {
      for (int i = 0; i < state.filter!.corner.length; i++) {
        if (state.filter!.corner[i].keys.first == value.keys.first) {
          state.filter!.corner.removeAt(i);
          break;
        }
      }
    }
    setType();
    emit(state.copyWith(timeStamp: DateTime.now().microsecondsSinceEpoch));
  }

  void setAuthorGrade(double authorGradeFrom, double authorGradeTo) {
    state.filter?.authorGradeFrom = authorGradeFrom;
    state.filter?.authorGradeTo = authorGradeTo;
    emit(state.copyWith(timeStamp: DateTime.now().microsecondsSinceEpoch));
  }

  void setUserGrade(double userGradeFrom, double userGradeTo) {
    state.filter?.userGradeFrom = userGradeFrom;
    state.filter?.userGradeTo = userGradeTo;
    emit(state.copyWith(timeStamp: DateTime.now().microsecondsSinceEpoch));
  }

  void setDesignBy(Map<String, dynamic> value, bool isSelect) {
    if (isSelect) {
      state.filter!.designBy.add(value);
    } else {
      for (int i = 0; i < state.filter!.designBy.length; i++) {
        if (state.filter!.designBy[i].keys.first == value.keys.first) {
          state.filter!.designBy.removeAt(i);
          break;
        }
      }
    }
   setType();
    emit(state.copyWith(timeStamp: DateTime.now().microsecondsSinceEpoch));
  }

  void removeFilter(Function(FilterParam) removeFilterCallBack) {
    emit(
      FilterRoutesPageState(
        filter: FilterParam(
          authorGradeFrom: 0,
          authorGradeTo: 20,
          userGradeFrom: 0,
          userGradeTo: 20,
          designBy: [],
          status: [],
          corner: [],
        ),
      ),
    );
    removeFilterCallBack.call(state.filter!);
  }

  void setType() {
    switch (type) {
      case FilterType.Favorite:
        getFavorite();
        break;
      case FilterType.SearchRoute:
        getSearchRoute();
        break;
    }
  }
}
