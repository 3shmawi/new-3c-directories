import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/model/user_model.dart';
import 'package:new_3c/services/dio_service.dart';

class RandomUserController extends Cubit<RandomUserStates> {
  RandomUserController() : super(RandomUserInitialState());

  final _http = HttpUtil();
  UserModel? userModel;

  void fetchRandomUser() async {
    try {
      emit(RandomUserLoadingState());
      final response = await _http.get("");
      final data = response?["results"]?[0];
      if (data != null) {
        userModel = UserModel.fromJson(data);
        emit(RandomUserSuccessState());
      } else {
        emit(RandomUserErrorState("Data is null"));
      }
    } catch (error) {
      emit(RandomUserErrorState(error.toString()));
    }
  }
}

abstract class RandomUserStates {}

class RandomUserInitialState extends RandomUserStates {}

class RandomUserLoadingState extends RandomUserStates {}

class RandomUserSuccessState extends RandomUserStates {}

class RandomUserErrorState extends RandomUserStates {
  final String errorMessage;

  RandomUserErrorState(this.errorMessage);
}
