import 'package:base_bloc/components/visibility_route_widget.dart';

class InfoRouteModel {
  final int grade;
  final String routeName;
  final bool isCorner;
  final int height;
  final VisibilityType type;

  const InfoRouteModel(
      {required this.grade,
      required this.routeName,
      required this.isCorner,
      required this.height,
      required this.type});
}
