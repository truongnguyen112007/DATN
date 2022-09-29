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
        author: 'Adam Kowasaki',
        grade: '8A',
        status: 'corner'),
    RoutesModel(
      name: 'Adam 2022-05-22',
      height: 122,
      author: 'TSU Tokoda',
      grade: '7B',
    ),
    RoutesModel(
      name: 'Adam 2022-05-22',
      height: 11,
      author: 'AI Kowasaki',
      grade: '6A',
    ),
    RoutesModel(
      name: 'Adam 2022-05-22',
      height: 12,
      author: 'Adam Kowasaki',
      grade: '6A',
    ),
    RoutesModel(
        name: 'Adam 2022-05-22',
        height: 122,
        author: 'TSU Tokoda',
        grade: '5B',
        status: 'corner'),
    RoutesModel(
        name: 'Adam 2022-05-22',
        height: 11,
        author: 'AI Kowasaki',
        grade: '6A',
        status: 'corner'),
    RoutesModel(
        name: 'Adam 2022-05-22',
        height: 11,
        author: 'AI Kowasaki',
        grade: '6A',
        status: 'corner')
  ];
}