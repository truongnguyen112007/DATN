import 'package:base_bloc/data/model/user_profile_model.dart';
import 'package:base_bloc/modules/tab_profile/edit_settings/edit_account/edit_account_cubit.dart';
import 'package:equatable/equatable.dart';

import '../../../../components/type_profile_widget.dart';

enum EditAccountStatus { initial, success, failure }

class EditAccountState extends Equatable {
  final EditAccountStatus status;

  // final UserProfileModel? model;
  TypeProfile? typeProfile;
  final bool? isOnChangeInfo;
  final String? errorName;
  final String? errorSurname;
  final String? errorHeight;
  final String? errorFav;
  final String? errorEmail;

  EditAccountState({
    this.typeProfile = TypeProfile.USER,
    this.errorName,
    this.errorSurname,
    this.errorHeight,
    this.errorFav,
    this.errorEmail,
    this.status = EditAccountStatus.initial,
    this.isOnChangeInfo = false,
  });

  EditAccountState copyWith({
    EditAccountStatus? status,
    TypeProfile? typeProfile,
    bool? isOnChangeInfo,
    String? errorName,
    String? errorSurname,
    String? errorHeight,
    String? errorFav,
    String? errorEmail,
  }) =>
      EditAccountState(
        status: status ?? this.status,
        isOnChangeInfo: isOnChangeInfo ?? this.isOnChangeInfo,
        typeProfile: typeProfile ?? this.typeProfile,
        errorName: errorName ?? this.errorName,
        errorSurname: errorSurname ?? this.errorSurname,
        errorHeight: errorHeight ?? this.errorHeight,
        errorFav: errorFav ?? this.errorFav,
        errorEmail: errorEmail ?? this.errorEmail,
      );

  @override
  List<Object?> get props => [
        status,
        isOnChangeInfo,
        errorName,
        errorSurname,
        errorFav,
        errorHeight,
        errorEmail,
        typeProfile
      ];
}
