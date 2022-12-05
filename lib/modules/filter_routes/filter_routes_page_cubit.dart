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
        status: 0,
        conner: 'T',
        authorGradeFrom: 0,
        authorGradeTo: 20,
        userGradeFrom: 0,
        userGradeTo: 20,
        designBy: 'T');
  }

  void getFavorite() async {
    var response = await userRepository.getFavorite(
        type: FavType.Filter,
        nextPage: 1,
        status: state.filter?.status,
        hasConner: state.filter?.conner,
        authorGradeFrom: state.filter?.authorGradeFrom,
        authorGradeTo: state.filter?.authorGradeTo,
        userGradeFrom: state.filter?.userGradeFrom,
        userGardeTo: state.filter?.userGradeTo,
        setter: state.filter?.designBy);
    if (response.data != null && response.error == null) {
      try {
        var lResponse = routeModelFromJson(response.data);
        logE(lResponse.length.toString());
        emit(state.copyWith(lPlayList: lResponse));
      } catch (e) {
        emit(
          state.copyWith(lPlayList: []),
        );
      }
    } else {
      toast(response.error.toString());
    }
  }

  void setData(FilterParam? filter) {
    if (filter != null) {
      emit(state.copyWith(
        filter: filter,
        currentStatus: filter.currentStatus,
        currentConnerIndex: filter.currentConner,
        currentDesignBy: filter.currentDesignedBy,
      ));
      getFavorite();
    }
  }

  void setStatus(int selectedStatus) {
    state.filter?.status = selectedStatus;
    getFavorite();
    emit(state.copyWith(timeStamp: DateTime.now().microsecondsSinceEpoch));
  }

  void setCorner(List<dynamic> value) {
    state.filter?.conner = value[0];
    getFavorite();
    emit(state.copyWith(currentConnerIndex: value[1]));
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

  void setDesignBy(List<dynamic> value) {
    state.filter?.designBy = value[0];
    getFavorite();
    emit(state.copyWith(currentDesignBy: value[1]));
  }

  void removeFilter() {
    emit(FilterRoutesPageState(filter: FilterParam(
        status: 0,
        conner: 'T',
        authorGradeFrom: 0,
        authorGradeTo: 20,
        userGradeFrom: 0,
        userGradeTo: 20,
        designBy: 'T')));
    getFavorite();
  }
}
