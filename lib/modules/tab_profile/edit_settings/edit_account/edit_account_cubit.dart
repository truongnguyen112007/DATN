import 'package:base_bloc/localizations/app_localazations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/model/profile_model.dart';
import 'edit_account_state.dart';

enum AccountFieldType {
  NICKNAME,
  NAME,
  SURNAME,
  TYPE,
  HEIGHT,
  FAVORITE_ROUTE_GRADE,
  EMAIL
}

extension AccountFieldTypeExtension on AccountFieldType {
  String get title {
    switch (this) {
      case AccountFieldType.NICKNAME:
        return LocaleKeys.account_nickname;
      case AccountFieldType.NAME:
        return LocaleKeys.account_name;
      case AccountFieldType.SURNAME:
        return LocaleKeys.account_surname;
      case AccountFieldType.TYPE:
        return LocaleKeys.account_type;
      case AccountFieldType.HEIGHT:
        return LocaleKeys.account_height;
      case AccountFieldType.FAVORITE_ROUTE_GRADE:
        return LocaleKeys.account_favorite_route_grade;
      case AccountFieldType.EMAIL:
        return LocaleKeys.account_email;
    }
  }
}

class EditAccountCubit extends Cubit<EditAccountState> {
  EditAccountCubit()
      : super(const EditAccountState(status: EditAccountStatus.initial)) {
    if (state.status == EditAccountStatus.initial) {}
  }

  Map<AccountFieldType, String?> commonFieldList(BuildContext context) => {
        AccountFieldType.NICKNAME: getCurrentUser().nickname,
        AccountFieldType.NAME: getCurrentUser().name,
        AccountFieldType.SURNAME: getCurrentUser().surname,
        AccountFieldType.TYPE: getCurrentUser().type,
        AccountFieldType.HEIGHT: getCurrentUser().height,
        AccountFieldType.FAVORITE_ROUTE_GRADE:
            getCurrentUser().favoriteRouteGrade,
        AccountFieldType.EMAIL: getCurrentUser().email,
      };

  ProfileModel getCurrentUser() {
    return ProfileModel.fakeCurrentUser();
  }
}
