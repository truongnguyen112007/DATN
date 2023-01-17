class StorageKey {
  StorageKey._();

  static const String CurrentToken = 'CurrentToken';
  static const String AccountInfo = 'AccountInfo';
  static const String doctorPromote = 'DoctorPromote';
  static const String ratingLatest = 'ratingLatest';
  static const String loginByFbOrGg = 'loginByFbOrGg';
  static const String isLogin = 'isLogin';
  static const String userModel = 'userModel';
  static const String playlistId = 'playlistId';
  static const String isGuideline = 'isGuideline';
  static const String languageCode = 'languageCode';
  static const String holdSet = 'holdSet';
  static const String userProfile = 'userProfile';
}

class ConstantKey {
  static const String USER = 'user';
  static const int aDAY=86400000;
  static const String DYNAMIC_LINK="https://docsify.page.link";
  static const String IOS_APP_STORE_ID="1634725173";
  static const int WEEK_INDEX_OFFSET = 5200;
  static const String TOKEN_EXPIRED = 'token expired';
  static const String CONNECTION_TIMED_OUT = 'Connection timed out';
  static const BASE_URL = 'http://83.171.249.207/api/v1/';
  static const IMAGE_URL = 'http://83.171.249.207/api/v1/hold/image/';
  static const PRIVATE = 0;
  static const FRIENDS = 1;
  static const PUBLIC = 2;
}

class MessageKey {
  static const String egCodeIsValid = 'Twoja sesja wygasła';
  static const String plCodeIsValid = 'Your code is invalid';
}

class ApiKey {
  static const email = 'email';
  static const token = 'token';
  static const password = 'password';
  static const device_id = 'device_id';
  static const device_name = 'device_name';
  static const device_model = 'device_model';
  static const name = 'name';
  static const user_id = 'user_id';
  static const route_id = 'route_id';
  static const route_ids = 'route_ids';
  static const limit_offset = 10;
  static const playlist_id = 'playlist_id';
  static const height = 'height';
  static const holds = 'holds';
  static const has_conner = 'has_conner';
  static const author_grade = 'author_grade';
  static const published = 'published';
  static const visibility = 'visibility';
  static const border = 'border';
  static const account_id = "account_id";
  static const first_name = "first_name";
  static const last_name = "last_name";
  static const gender = "gender";
  static const role = "role";
  static const birth_date = "birth_date";
  static const favorite_route_grade = "favorite_route_grade";
  static const photo = "photo";
  static const phone = "phone";
  static const user = "user";
  static const route_setter = "route_setter";
  static const trainer = "trainer";
}

class BottomNavigationConstant{
  static const TAB_HOME = 0;
  static const TAB_ROUTES = 1;
  static const TAB_CLIMB = 2;
  static const TAB_RESERVATIONS = 3;
  static const TAB_PROFILE = 4;
}

class SearchConstant {
  static const ALL = 0;
  static const PLACE = 1;
  static const ROUTE = 2;
  static const PERSONS = 3;
}

class BottomNavigationSearch{
  static const TAB_ALL = 0;
  static const TAB_PLACES = 1;
  static const TAB_ROUTES = 2;
  static const TAB_PERSON = 3;
}
