class PlayListModel {
  final String name;
  final int height;
  final String author;
  final String grade;
  final String? status;

  PlayListModel(
      {required this.name,
      required this.height,
      required this.author,
      required this.grade,
       this.status});
}
