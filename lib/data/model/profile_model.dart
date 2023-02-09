import 'package:base_bloc/data/globals.dart';

import '../../gen/assets.gen.dart';
import '../../modules/tab_profile/edit_settings/edit_settings_cubit.dart';

class ProfileModel {
  String? name;
  String? surname;
  String? nickname;
  String? avatar;
  String? type;
  String? height;
  String? favoriteRouteGrade;
  String? email;
  int passed = 0;
  int designed = 0;
  int friends = 0;

  ProfileModel(
      {String? name = null,
      String? surname = null,
      String? nickname: null,
      String? avatar: null,
      String? type: null,
      String? height: null,
      String? favoriteRouteGrade: null,
      String? email: null,
      int passed: 0,
      int designed: 0,
      int friends: 0}) {
    this.name = name;
    this.surname = surname;
    this.nickname = nickname;
    this.avatar = avatar;
    this.type = type;
    this.height = height;
    this.favoriteRouteGrade = favoriteRouteGrade;
    this.email = email;
    this.passed = passed;
    this.designed = designed;
    this.friends = friends;
  }

  static ProfileModel fakeCurrentUser() {
    return ProfileModel(
        name: 'Marcin Kowalski',
        surname: 'Kowalski',
        nickname: 'Kowal',
        avatar:
            'https://thegioidienanh.vn/stores/news_dataimages/anhvu/092022/05/07/4955_300520026_497051069095370_6964118069725518096_n.jpg?rt=20220905075129',
        type: 'Climb, Route setter',
        height: '170',
        favoriteRouteGrade: '5A+',
        email: 'adamkowalski@gmail.com',
        passed: 32,
        designed: 12,
        friends: 24);
  }
}
