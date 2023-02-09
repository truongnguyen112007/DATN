import 'package:equatable/equatable.dart';

enum EditSettingsStatus { initial, success, failure, refresh }

class EditSettingsState extends Equatable {
  final EditSettingsStatus status;
  final int? timeStamp;

  const EditSettingsState(
      {this.status = EditSettingsStatus.initial,this.timeStamp});

  @override
  List<Object?> get props => [status,timeStamp];

}
