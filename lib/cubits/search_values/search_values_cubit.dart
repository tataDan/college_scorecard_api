import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_values_state.dart';

class SearchValuesCubit extends Cubit<SearchValuesState> {
  final Map<String, String> newSearchValues;

  SearchValuesCubit({
    required this.newSearchValues,
  }) : super(SearchValuesState.initial());

  void updateSearchValues(Map<String, String> newSearchValues) {
    emit(state.copyWith(searchValues: newSearchValues));
  }
}
