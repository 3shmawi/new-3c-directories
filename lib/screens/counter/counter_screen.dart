import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/controller/counter_ctrl.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterCtrl(),
      child: Builder(builder: (context) {
        final cubit = context.read<CounterCtrl>();
        return Scaffold(
          appBar: AppBar(
            title: Text("Counter"),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              BlocBuilder<CounterCtrl, int>(
                builder: (context, counter) {
                  return Text(
                    "$counter",
                    style: TextStyle(fontSize: 50, color: Colors.blue[900]),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      cubit.increment();
                    },
                    icon: Icon(Icons.add),
                  ),
                  IconButton(
                    onPressed: () {
                      cubit.decrement();
                    },
                    icon: Icon(Icons.remove),
                  ),
                ],
              )
            ],
          ),
        );
      }),
    );
  }
}
