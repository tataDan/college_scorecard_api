part of 'page_cubit.dart';

class PageState extends Equatable {
  final int page;
  const PageState({required this.page});

  factory PageState.initial() {
    return const PageState(page: 0);
  }

  @override
  List<Object> get props => [page];

  @override
  String toString() => 'PageState(counter: $page)';

  PageState copyWith({
    int? page,
  }) {
    return PageState(
      page: page ?? this.page,
    );
  }
}
