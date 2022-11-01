enum RefreshType { ADDRESS, EXP, RATE ,FILTER}

class RefreshEvent {
  final RefreshType type;

  RefreshEvent(this.type);
}
