import 'package:base_bloc/data/model/user_profile_model.dart';
import 'package:equatable/equatable.dart';

enum EditAccountStatus { initial, success, failure }

class EditAccountState extends Equatable {
  final EditAccountStatus status;
  final UserProfileModel? model;

  const EditAccountState(
      {this.status = EditAccountStatus.initial,this.model, });

  @override
  List<Object?> get props => [status,model];

}
