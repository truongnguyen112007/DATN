import 'package:equatable/equatable.dart';

class TabRouteState extends Equatable{
  final int? timeStamp;
  const TabRouteState ({this.timeStamp});
  @override
  List<Object?> get props => [timeStamp];
}
