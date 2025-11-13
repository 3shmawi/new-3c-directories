import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterCubit(),
      child: Builder(builder: (context) {
        return Scaffold(
          body: Center(
            child: BlocBuilder<CounterCubit, int>(
              builder: (context, count) {
                return Text(
                  "$count",
                  style: TextStyle(fontSize: 52),
                );
              },
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              if (index == 0) {
                //add
                // counter++;
                context.read<CounterCubit>().increment();
              } else if (index == 1) {
                //subtract
                // counter--;
                context.read<CounterCubit>().decrement();
              }
              // setState(() {});
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.remove), label: "Subtract"),
            ],
          ),
        );
      }),
    );
  }
}

//state management [flutter_bloc]
//data management

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}
// class CounterController extends Cubit<CounterState> {
//   CounterController() : super(InitialState());
//
//   int counter = 0;
//
//   void increment() {
//     counter++;
//     emit(IncrementState());
//   }
//
//   void decrement() {
//     counter--;
//     emit(DecrementState());
//   }
// }
//
// abstract class CounterState {}
//
// class InitialState extends CounterState {}
//
// class IncrementState extends CounterState {}
//
// class DecrementState extends CounterState {}
