import 'package:base_bloc/modules/search/search_page_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<SearchState>{
  SearchCubit() : super(InitSearchState());

  void jumToPage (int index) => emit(ChangeTabState(index));
}