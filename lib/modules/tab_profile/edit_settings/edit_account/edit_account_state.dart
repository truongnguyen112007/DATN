import 'package:base_bloc/data/model/user_profile_model.dart';
import 'package:equatable/equatable.dart';

enum EditAccountStatus { initial, success, failure }

class EditAccountState extends Equatable {
  final EditAccountStatus status;
  // final UserProfileModel? model;
  final bool? isOnChangeInfo;
  final String? errorName;
  final String? errorSurname;
  final String? errorType;
  final String? errorHeight;
  final String? errorFav;
  final String? errorEmail;

  const EditAccountState({
    this.errorName,
    this.errorSurname,
    this.errorType,
    this.errorHeight,
    this.errorFav,
    this.errorEmail,
    this.status = EditAccountStatus.initial,
    // this.model,
    this.isOnChangeInfo = false,
  });

  EditAccountState copyWith(
          {EditAccountStatus? status,
          // UserProfileModel? model,
          bool? isOnChangeInfo,
          String? errorName,
          String? errorSurname,
          String? errorType,
          String? errorHeight,
          String? errorFav,
          String? errorEmail}) =>
      EditAccountState(
          status: status ?? this.status,
          // model: model ?? this.model,
          isOnChangeInfo: isOnChangeInfo ?? this.isOnChangeInfo,
          errorName: errorName ?? this.errorName,
          errorSurname: errorSurname ?? this.errorSurname,
          errorType: errorType ?? this.errorType,
          errorHeight: errorHeight ?? this.errorHeight,
          errorFav: errorFav ?? this.errorFav,
          errorEmail: errorEmail ?? this.errorEmail);

  @override
  List<Object?> get props => [status, isOnChangeInfo,errorName,errorSurname,errorType,errorFav,errorHeight,errorEmail];
}
