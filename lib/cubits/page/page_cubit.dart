import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'page_state.dart';

class PageCubit extends Cubit<PageState> {
  PageCubit() : super(PageState.initial());

  void increment() {
    emit(state.copyWith(page: state.page + 1));
  }

  void decrement() {
    emit(state.copyWith(page: state.page - 1));
  }

  void resetToZero() {
    emit(state.copyWith(page: 0));
  }
}
