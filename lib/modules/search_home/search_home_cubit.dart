import 'package:base_bloc/modules/search_home/search_home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchHomeCubit extends Cubit<SearchHomeState>{
  SearchHomeCubit() : super(InitState());

  void jumToPage (int index) => emit(ChangeTabState(index));
}