import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/counter/counter_cubit.dart';

import '../cubit/theme.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.dark_mode_outlined),
            onPressed: context.read<ThemeCubit>().toggleTheme,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<CounterCubit, int>(
              builder: (context, counter) {
                return Text(
                  "$counter",
                  style: TextStyle(
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyan,
                  ),
                );
              },
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: context.read<CounterCubit>().increment,
                      child: Text("Increment"),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: context.read<CounterCubit>().decrement,
                      child: Text("Decrement"),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: context.read<CounterCubit>().reset,
                  child: Text("Reset"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
