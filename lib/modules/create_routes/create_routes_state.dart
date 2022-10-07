import 'package:equatable/equatable.dart';

import '../persons_page/persons_page_state.dart';

class CreateRoutesState extends Equatable {
  final StatusType status;

  const CreateRoutesState({this.status = StatusType.initial});
  CreateRoutesState copyOf(StatusType? status) =>
      CreateRoutesState(status: status ?? this.status);
  @override
  List<Object?> get props => [status];
}
