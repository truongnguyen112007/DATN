import 'package:base_bloc/components/dialogs.dart';
import 'package:base_bloc/data/repository/user_repository.dart';
import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:base_bloc/modules/create_info_route/create_info_route_state.dart';
import 'package:base_bloc/modules/home/home_page.dart';
import 'package:base_bloc/router/router_utils.dart';
import 'package:base_bloc/utils/app_utils.dart';
import 'package:base_bloc/utils/log_utils.dart';
import 'package:base_bloc/utils/toast_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/hold_set_model.dart';

class CreateInfoRouteCubit extends Cubit<CreateInfoRouteState> {
  final List<HoldSetModel> lHoldSet;
  var userRepository = UserRepository();

  CreateInfoRouteCubit(this.lHoldSet) : super(const CreateInfoRouteState());

  void increase() {
    if (state.currentIndexGrade == lGrade.length - 1) return;
    emit(state.copyOf(
        grade: lGrade[state.currentIndexGrade + 1],
        currentIndexGrade: state.currentIndexGrade + 1));
  }

  void decrease() {
    if (state.currentIndexGrade == 0) return;
    emit(state.copyOf(
        grade: lGrade[state.currentIndexGrade - 1],
        currentIndexGrade: state.currentIndexGrade - 1));
  }

  void setCorner() => emit(state.copyOf(isCorner: !state.isCorner));

  void publishOnclick(String routeName, BuildContext context) async {
    if (routeName.isEmpty) {
      emit(state.copyOf(errorRouteName: LocaleKeys.please_input_hold_set));
    } else {
      emit(state.copyOf(errorRouteName: ''));
      Utils.hideKeyboard(context);
      Dialogs.showLoadingDialog(context);
      var response = await userRepository.createRoute(
          name: routeName,
          lHold: lHoldSet.map((e) => e.index).toList(),
          hasCorner: state.isCorner,
          authorGrade: state.grade);
      await Dialogs.hideLoadingDialog();
      if (response.error != null) {
        toast(response.error.toString());
      } else {
        toast(response.message.toString());
        RouterUtils.openNewPage(const HomePage(), context, isReplace: true);
      }
    }
  }

  var lGrade = [
    '4A',
    '4B',
    '4C',
    '5A',
    '5B',
    '5C',
    '6A',
    '6B',
    '6C',
    '6C+',
    '7A',
    '7B',
    '7C',
    '7C+',
    '8A',
    '8B',
    '8C',
    '8C+'
  ];
}
