import 'package:equatable/equatable.dart';
import '../../data/model/person_model.dart';

enum StatusType { initial, success, failure, refresh, search}

class PersonsPageState extends Equatable {
  final StatusType status;
  final List<PersonModel> lFriend;
  final List<PersonModel> lTopRouteSetter;
  final bool readEnd;
  final int currentPage;

  const PersonsPageState(
      {this.readEnd = false,
        this.currentPage = 1,
        this.lFriend = const <PersonModel>[],
        this.lTopRouteSetter = const <PersonModel>[],
        this.status = StatusType.initial});

  @override
  List<Object?> get props =>
      [lFriend, lTopRouteSetter, currentPage, readEnd, status];

  PersonsPageState copyOf(
      {List<PersonModel>? lFriend,
        List<PersonModel>? lTopRouteSetter,
        bool? readEnd,
        int? currentPage,
        StatusType? status}) =>
      PersonsPageState(
          lFriend: lFriend ?? this.lFriend,
          lTopRouteSetter: lTopRouteSetter ?? this.lTopRouteSetter,
          readEnd: readEnd ?? this.readEnd,
          currentPage: currentPage ?? this.currentPage,
          status: status ?? this.status);
}


