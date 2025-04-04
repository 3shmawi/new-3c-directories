import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/countries/cubit.dart';
import 'package:new_3c/theme/theme_cubit.dart';

import '../counter/counter_cubit.dart';

class CountriesView extends StatelessWidget {
  const CountriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("All Countries"),
        actions: [
          IconButton(
            onPressed: context.read<ThemeCubit>().changeTheme,
            icon: Icon(Icons.brightness_4),
          ),
        ],
      ),
      body: BlocBuilder<CountriesCubit, CountriesState>(
        builder: (context, state) {
          return switch (state) {
            InitialState() => Center(child: CircularProgressIndicator()),
            Data() => ListView.builder(
                itemCount: state.countries.length,
                itemBuilder: (context, index) {
                  final country = state.countries[index];
                  return ListTile(
                    title: Text(country["name"]["common"]),
                    subtitle: Text(country["region"]),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        country["flags"]["png"],
                      ),
                    ),
                  );
                },
              ),
            Error() => Center(
                child: Text(
                  state.message,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          };
        },
      ),
    );
  }
}

class CounterExample extends StatelessWidget {
  const CounterExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            context.read<CounterCubit>().decrement();
          },
          icon: Icon(Icons.remove),
        ),
        BlocBuilder<CounterCubit, int>(
          builder: (context, count) {
            return Text(
              "$count",
              style: TextStyle(fontSize: 30),
            );
          },
        ),
        IconButton(
          onPressed: () {
            context.read<CounterCubit>().increment();
          },
          icon: Icon(Icons.add),
        ),
      ],
    );
  }
}
