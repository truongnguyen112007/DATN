class RoutesModel {
  final String name;
  final int height;
  final String author;
  final String grade;
  final String? status;

  RoutesModel(
      {required this.name,
      required this.height,
      required this.author,
      required this.grade,
       this.status});
}
