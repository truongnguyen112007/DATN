class FilterParam {
  final String? author;
  List<Map<String,dynamic>> status;
  List<Map<String,dynamic>> conner;
  double authorGradeFrom;
  double authorGradeTo;
  double userGradeFrom;
  double userGradeTo;
  String designBy;
  int currentStatus;
  int currentConner;
  int currentDesignedBy;

  FilterParam(
      {this.currentConner = 0,
      this.currentStatus = 0,
      this.currentDesignedBy = 0,
      this.author,
      required this.status,
      required this.conner,
      required this.authorGradeFrom,
      required this.authorGradeTo,
      required this.userGradeFrom,
      required this.userGradeTo,
      required this.designBy});

  @override
  String toString() {
    return super.toString();
  }
}
