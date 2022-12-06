import 'package:base_bloc/modules/favourite/favourite_state.dart';
import 'package:base_bloc/modules/filter_routes/filter_routes_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/filter_param.dart';
import '../../data/model/routes_model.dart';
import '../../data/repository/user_repository.dart';
import '../../utils/log_utils.dart';
import '../../utils/toast_utils.dart';
import 'filter_routes_page_state.dart';

class FilterRoutesPageCubit extends Cubit<FilterRoutesPageState> {
  var userRepository = UserRepository();

  FilterRoutesPageCubit() : super(FilterRoutesPageState()) {
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

  void setData(FilterParam? filter) {
    if (filter != null) {
      emit(state.copyWith(
        filter: filter,
      ));
      getFavorite();
    }
  }

  void setStatus(Map<String, dynamic> value, bool isSelect) {
    if (isSelect) {
      state.filter!.status.add(value);
    } else {
      state.filter!.status.remove(value);
    }
    getFavorite();
    emit(state.copyWith(timeStamp: DateTime.now().microsecondsSinceEpoch));
  }

  void setCorner(Map<String, dynamic> value, bool isSelect) {
    if (isSelect) {
      state.filter!.corner.add(value);
    } else {
      state.filter!.corner.remove(value);
    }
    getFavorite();
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
      state.filter!.designBy.remove(value);
    }
    getFavorite();
    emit(state.copyWith(timeStamp: DateTime.now().microsecondsSinceEpoch));
  }

  void removeFilter() {
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
  }
}
