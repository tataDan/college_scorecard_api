part of 'search_values_cubit.dart';

class SearchValuesState extends Equatable {
  final Map<String, String> searchValues;
  const SearchValuesState({required this.searchValues});

  factory SearchValuesState.initial() {
    return const SearchValuesState(searchValues: {});
  }

  @override
  List<Object> get props => [searchValues];

  @override
  String toString() => 'SearchValuesState(page: $searchValues)';

  SearchValuesState copyWith({
    Map<String, String>? searchValues,
  }) {
    return SearchValuesState(
      searchValues: searchValues ?? this.searchValues,
    );
  }
}
