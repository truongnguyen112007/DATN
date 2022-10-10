import 'package:equatable/equatable.dart';

import '../persons_page/persons_page_state.dart';

class CreateRoutesState extends Equatable {
  final int column;
  final int row;
  final StatusType status;
  final int sizeBox;
  final List<String> lBox;
  final int selectIndex;
  final int timeStamp;

  const CreateRoutesState(
      {this.status = StatusType.initial,
      this.timeStamp = 0,
      this.sizeBox = 10,
      this.column = 0,
      this.row = 0,
      this.selectIndex = 0,
      this.lBox = const <String>[]});

  CreateRoutesState copyOf(
          {StatusType? status,
          int? column,
          int? selectIndex,
          int? row,
          int? sizeBox,
          List<String>? lBox,
          int? timeStamp}) =>
      CreateRoutesState(
          selectIndex: selectIndex ?? this.selectIndex,
          status: status ?? this.status,
          column: column ?? this.column,
          row: row ?? this.row,
          sizeBox: sizeBox ?? this.sizeBox,
          lBox: lBox ?? this.lBox,
          timeStamp: timeStamp ?? this.timeStamp);

  @override
  List<Object?> get props =>
      [status, sizeBox, column, row, lBox, selectIndex, timeStamp];
}
