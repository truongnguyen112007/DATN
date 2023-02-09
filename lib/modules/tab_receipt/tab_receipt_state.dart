import 'package:equatable/equatable.dart';
import '../../data/model/calender_param.dart';

class TabReceiptState extends Equatable {
  final int? timeStamp;
  late CalenderParam? calender;

  TabReceiptState({
    this.timeStamp,
    this.calender,
  });

  @override
  List<Object?> get props => [timeStamp, calender];

  TabReceiptState copyOf({
    int? timeStamp,
    CalenderParam? calender,
  }) =>
      TabReceiptState(
          timeStamp: timeStamp ?? this.timeStamp,
          calender: calender ?? this.calender);
}
