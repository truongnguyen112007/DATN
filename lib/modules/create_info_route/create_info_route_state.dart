import 'package:base_bloc/data/model/routes_model.dart';
import 'package:equatable/equatable.dart';

class CreateInfoRouteState extends Equatable {
  final int grade;
  final int currentIndexGrade;
  final String errorRouteName;
  final bool isCorner;
  final String routeName;
  final bool isEdit;
  final RoutesModel? model;
  final int height;

  const CreateInfoRouteState(
      {this.height = 3,
      this.grade = 5,
      this.isEdit = false,
      this.model,
      this.isCorner = false,
      this.routeName = '',
      this.currentIndexGrade = 6,
      this.errorRouteName = ''});

  CreateInfoRouteState copyOf(
          {int? grade,
          int? height,
          RoutesModel? model,
          bool? isEdit,
          bool? isCorner,
          String? routeName,
          String? errorRouteName,
          int? currentIndexGrade}) =>
      CreateInfoRouteState(
          height: height ?? this.height,
          model: model ?? this.model,
          isEdit: isEdit ?? this.isEdit,
          routeName: routeName ?? this.routeName,
          isCorner: isCorner ?? this.isCorner,
          errorRouteName: errorRouteName ?? this.errorRouteName,
          grade: grade ?? this.grade,
          currentIndexGrade: currentIndexGrade ?? this.currentIndexGrade);

  @override
  List<Object?> get props =>
      [grade, currentIndexGrade, errorRouteName, isCorner, isEdit, height];
}
