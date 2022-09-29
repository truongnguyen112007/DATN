import 'dart:async';
import 'package:base_bloc/data/model/person_model.dart';
import 'package:base_bloc/modules/persons_page/persons_page_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonsPageCubit extends Cubit<PersonsPageState> {
  PersonsPageCubit()
      : super(const PersonsPageState(status: StatusType.initial)) {
    if (state.status == StatusType.initial) {
      getFeed();
    }
  }

  void getFeed({bool isPaging = false}) {
    if (state.readEnd) return;
    if (isPaging) {
      Timer(const Duration(seconds: 1), () {
        emit(state.copyOf(
            lFriend: List.of(state.lFriend)..addAll(fakeData()),
            readEnd: true));
      });
    } else {
      Timer(const Duration(seconds: 1), () {
        emit(PersonsPageState(
            readEnd: false,
            lFriend: fakeData(),
            lTopRouteSetter: fakeData(),
            status: StatusType.success,
            currentPage: 1));
      });
    }
  }

  void refresh() {
    emit(const PersonsPageState(status: StatusType.refresh));
    getFeed();
  }

  void search(String keySearch) {
    if (keySearch.isEmpty) {
      emit(state.copyOf(status: StatusType.success));
    } else {
      emit(state.copyOf(status: StatusType.search));
    }
  }

  List<PersonModel> fakeData() => [
        PersonModel(
            image: '', nickName: 'Adam Kowalski', typeUser: 'Route setter'),
        PersonModel(
            image: '', nickName: 'Adam Kowalski', typeUser: 'Route setter'),
        PersonModel(
            image: '', nickName: 'Adam Kowalski', typeUser: 'Route setter'),
      ];
}
