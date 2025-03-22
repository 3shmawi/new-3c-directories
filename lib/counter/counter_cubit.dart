import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() {
    emit(state + 1);
    // setState(() {
    //   counter++;
    // });
  }

  void decrement() {
    emit(state - 1);
    // setState(() {
    //   counter--;
    // });
  }

  void reset() {
    emit(0);
    // setState(() {
    //   counter = 0;
    // });
  }
}
