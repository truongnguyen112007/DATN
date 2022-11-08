import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/routes_model.dart';
import '../tab_home/tab_home_state.dart';
import 'all_page_state.dart';

class AllPageCubit extends Cubit<AllPageState> {
  AllPageCubit() : super(const AllPageState()) {
    if (state.status == FeedStatus.initial) {}
  }
  List<RoutesModel> fakeData() => [
    RoutesModel(
        name: 'Adam 2022-05-22',
        height: 12,
       ),
    RoutesModel(
      name: 'Adam 2022-05-22',
      height: 122,

    ),
    RoutesModel(
      name: 'Adam 2022-05-22',
      height: 11,

    ),
    RoutesModel(
      name: 'Adam 2022-05-22',
      height: 12,

    ),
    RoutesModel(
        name: 'Adam 2022-05-22',
        height: 122,
     ),
    RoutesModel(
        name: 'Adam 2022-05-22',
        height: 11),
    RoutesModel(
        name: 'Adam 2022-05-22',
        height: 11)
  ];
}