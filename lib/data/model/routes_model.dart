class RoutesModel {
  final String name;
  final int height;
  final String author;
  final String grade;
  final String? status;
   bool isSelect;

  RoutesModel(
      {required this.name,
      this.isSelect = false,
      required this.height,
      required this.author,
      required this.grade,
      this.status});
}
