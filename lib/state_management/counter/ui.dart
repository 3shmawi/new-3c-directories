import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/state_management/counter/controller.dart';
import 'package:new_3c/state_management/theme/controller.dart';

class CounterExample extends StatefulWidget {
  const CounterExample({super.key});

  @override
  State<CounterExample> createState() => _CounterExampleState();
}

class _CounterExampleState extends State<CounterExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Counter Example"),
        actions: [
          IconButton(
              onPressed: () {
                context.read<ThemeController>().toggleTheme();
              },
              icon: Icon(Icons.dark_mode_outlined)),
        ],
      ),
      body: Center(
        child: BlocBuilder<CounterCubit, int>(
          builder: (context, counter) {
            return Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: CircularProgressIndicator(
                    value: counter / 100,
                    strokeWidth: 10,
                    color: Colors.green,
                  ),
                ),
                if (counter < 100)
                  Text(
                    "$counter/100",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 25,
                    ),
                  )
                else
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 100,
                  )
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FloatingActionButton(
              onPressed: context.read<CounterCubit>().decrement,
              backgroundColor: Colors.red,
              child: Icon(
                Icons.remove,
                color: Colors.white,
              ),
            ),
            BlocBuilder<CounterCubit, int>(
              builder: (context, state) {
                return PopupMenuButton(
                  icon: Text("+${context.read<CounterCubit>().countBy}"),
                  onSelected: context.read<CounterCubit>().changeCountBy,
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(value: 1, child: Text("+1")),
                      PopupMenuItem(value: 5, child: Text("+5")),
                      PopupMenuItem(value: 10, child: Text("+10")),
                    ];
                  },
                );
              },
            ),
            FloatingActionButton(
              onPressed: context.read<CounterCubit>().increment,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
