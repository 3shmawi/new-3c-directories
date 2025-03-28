import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CountriesView extends StatefulWidget {
  const CountriesView({super.key});

  @override
  State<CountriesView> createState() => _CountriesViewState();
}

class _CountriesViewState extends State<CountriesView> {
  bool isLoading = false;
  late List countries;
  final dio = Dio(BaseOptions(baseUrl: "https://restcountries.com/v3.1/all"));

  void getCountries() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await dio.get("/");
      countries = response.data;
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("All Countries"),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : ListWheelScrollView(
                itemExtent: 50,
                diameterRatio: 1.5,
                children: List.generate(
                  countries.length,
                  (index) => ListTile(
                    title: Text(countries[index]['name']['common']),
                    subtitle: Text(countries[index]['name']['official']),
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(countries[index]['flags']['png']),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
