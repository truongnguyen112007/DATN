import 'package:equatable/equatable.dart';

class CreateInfoRouteState extends Equatable {
  final String grade;
  final int currentIndexGrade;
  final String errorRouteName;
  final bool isCorner;

  const CreateInfoRouteState(
      {this.grade = '6A',
      this.isCorner = false,
      this.currentIndexGrade = 6,
      this.errorRouteName = ''});

  CreateInfoRouteState copyOf(
          {String? grade,
          bool? isCorner,
          String? errorRouteName,
          int? currentIndexGrade}) =>
      CreateInfoRouteState(
          isCorner: isCorner ?? this.isCorner,
          errorRouteName: errorRouteName ?? this.errorRouteName,
          grade: grade ?? this.grade,
          currentIndexGrade: currentIndexGrade ?? this.currentIndexGrade);

  @override
  List<Object?> get props =>
      [grade, currentIndexGrade, errorRouteName, isCorner];
}
