class FilterParam {
  final String? author;
  int status;
  String conner;
  double authorGradeFrom;
  double authorGradeTo;
  double userGradeFrom;
  double userGradeTo;
  String designBy;

  FilterParam(
      {this.author,
      required this.status,
      required this.conner,
      required this.authorGradeFrom,
      required this.authorGradeTo,
      required this.userGradeFrom,
      required this.userGradeTo,
      required this.designBy}
      );
  @override
  String toString() {
    return super.toString();
  }
}
