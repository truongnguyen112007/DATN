import 'package:equatable/equatable.dart';

enum RoutesStatus { initial, success, failure, refresh }

class RoutesDetailState extends Equatable {
  final RoutesStatus status;

  const RoutesDetailState({required this.status});

  RoutesDetailState copyOf(RoutesStatus? status) =>
      RoutesDetailState(status: status ?? this.status);

  @override
  List<Object?> get props => [status];
}
