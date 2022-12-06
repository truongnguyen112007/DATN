class FilterParam {
  final String? author;
  List<Map<String, dynamic>> status;
  List<Map<String, dynamic>> corner;
  double authorGradeFrom;
  double authorGradeTo;
  double userGradeFrom;
  double userGradeTo;
  List<Map<String,dynamic>> designBy;

  FilterParam(
      {
      this.author,
      required this.status,
      required this.corner,
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
