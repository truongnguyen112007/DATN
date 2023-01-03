import 'package:base_bloc/data/model/user_profile_model.dart';
import 'package:equatable/equatable.dart';

enum EditAccountStatus { initial, success, failure }

class EditAccountState extends Equatable {
  final EditAccountStatus status;
  final UserProfileModel? model;
  final bool? isOnChangeInfo;

  const EditAccountState({
    this.status = EditAccountStatus.initial,
    this.model,
    this.isOnChangeInfo = false,
  });

  EditAccountState copyWith(
          {EditAccountStatus? status,
          UserProfileModel? model,
          bool? isOnChangeInfo}) =>
      EditAccountState(
          status: status ?? this.status,
          model: model ?? this.model,
          isOnChangeInfo: isOnChangeInfo ?? this.isOnChangeInfo);

  @override
  List<Object?> get props => [status, model, isOnChangeInfo];
}
