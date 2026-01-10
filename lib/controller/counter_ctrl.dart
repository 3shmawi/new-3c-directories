import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCtrl extends Cubit<int> {
  // CounterCtrl(super.initialState);
  CounterCtrl() : super(0);

  //this => child
  //super => parent

  void increment() {
    emit(state + 1);
  }

  void decrement() {
    if (state > 0) {
      emit(state - 1);
    }
  }

  void reset() {
    emit(0);
  }
}

// Provider

// Builder
