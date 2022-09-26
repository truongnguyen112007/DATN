import 'package:equatable/equatable.dart';

enum EditSettingsStatus { initial, success, failure, refresh }

class EditSettingsState extends Equatable {
  final EditSettingsStatus status;

  const EditSettingsState(
      {this.status = EditSettingsStatus.initial});

  @override
  List<Object?> get props => [];

}
