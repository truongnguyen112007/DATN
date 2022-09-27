import 'package:equatable/equatable.dart';

enum EditAccountStatus { initial, success, failure }

class EditAccountState extends Equatable {
  final EditAccountStatus status;

  const EditAccountState(
      {this.status = EditAccountStatus.initial});

  @override
  List<Object?> get props => [];

}
