enum RefreshType { ADDRESS, EXP, RATE ,FILTER,PLAYLIST,FAVORITE}

class RefreshEvent {
  final RefreshType type;

  RefreshEvent(this.type);
}
