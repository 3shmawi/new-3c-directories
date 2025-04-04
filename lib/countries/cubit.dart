import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const baseUrl = "https://restcountries.com/v3.1";

class CountriesCubit extends Cubit<CountriesState> {
  CountriesCubit() : super(InitialState());

  final dio = Dio();

  void getCountries() async {
    emit(InitialState());
    try {
      final response = await dio.get("https://restcountries.com/v3.1/all");
      emit(Data(response.data));
    } on DioException catch (error) {
      emit(Error(error.message ??
          error.response?.statusMessage ??
          error.error.toString()));
    } catch (error) {
      emit(Error(error.toString()));
    }
  }
}

sealed class CountriesState {}

class InitialState extends CountriesState {}

class Data extends CountriesState {
  final List countries;

  Data(this.countries);
}

class Error extends CountriesState {
  final String message;

  Error(this.message);
}
