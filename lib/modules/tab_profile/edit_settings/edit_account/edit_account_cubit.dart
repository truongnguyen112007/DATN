import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/model/profile_model.dart';
import '../../../../localization/locale_keys.dart';
import '../../../../utils/storage_utils.dart';
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
        return LocaleKeys.account_nickname.tr();
      case AccountFieldType.NAME:
        return LocaleKeys.account_name.tr();
      case AccountFieldType.SURNAME:
        return LocaleKeys.account_surname.tr();
      case AccountFieldType.TYPE:
        return LocaleKeys.account_type.tr();
      case AccountFieldType.HEIGHT:
        return LocaleKeys.account_height.tr();
      case AccountFieldType.FAVORITE_ROUTE_GRADE:
        return LocaleKeys.account_favorite_route_grade.tr();
      case AccountFieldType.EMAIL:
        return LocaleKeys.account_email.tr();
    }
  }
}

class EditAccountCubit extends Cubit<EditAccountState> {
  EditAccountCubit()
      : super(const EditAccountState(status: EditAccountStatus.initial)) {
    if (state.status == EditAccountStatus.initial) {}
    getData();
  }

  void getData()async{
    var userModel = await StorageUtils.getUserProfile();
    emit(EditAccountState(model: userModel));
  }

  Map<AccountFieldType, String?> commonFieldList(BuildContext context) => {
        AccountFieldType.NICKNAME:state.model?.username,
        AccountFieldType.NAME: state.model?.firstName,
        AccountFieldType.SURNAME: state.model?.lastName,
        AccountFieldType.TYPE: state.model?.role,
        AccountFieldType.HEIGHT: "170",
        AccountFieldType.FAVORITE_ROUTE_GRADE:
            "5A+",
        AccountFieldType.EMAIL: state.model?.email,
      };

}
