import 'package:flutter_bloc/flutter_bloc.dart';

///flutter_bloc

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  int countBy = 1;

  void increment() {
    if (state < 100) {
      emit(state + countBy);
    }
  }

  void decrement() {
    if (state > 0) {
      emit(state - countBy);
    }
  }

  void changeCountBy(int count) {
    if (count > 0) {
      countBy = count;
      emit(state);
    }
  }
}
