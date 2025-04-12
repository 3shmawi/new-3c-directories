import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/app/constants.dart';
import 'package:new_3c/models/user.dart';

userCubit(context) => BlocProvider.of<UserCubit>(context);

class UserCubit extends Cubit<UserStates> {
  UserCubit() : super(UserInitialState());

  UserModel? myUserData;

  final _auth = FirebaseAuth.instance;

  //check if user not logged in
  bool isUserLoggedIn() {
    return _auth.currentUser != null;
  }

//getMyUserData
  void getMyUserData() async {
    emit(GetMyUserDataLoadingState());
    try {
      if (!isUserLoggedIn()) {
        emit(GetMyUserDataErrorState("User not logged in"));
        return;
      }
      myUserData = await getUserData(_auth.currentUser!.uid);
      emit(GetMyUserDataSuccessState());
    } catch (error) {
      emit(GetMyUserDataErrorState("Failed to get user data\n$error"));
    }
  }

//getUserData
  Future<UserModel> getUserData(String uid) async {
    final userDoc = AppConstants.collectionPath.collection("users").doc(uid);
    final userData = await userDoc.get();
    if (userData.exists) {
      return UserModel.fromJson(userData.data()!);
    } else {
      throw Exception("User not found");
    }
  }

//editMyUserData
  void editMyUserData(UserModel userModel) async {
    emit(EditMyUserDataLoadingState());
    try {
      if (!isUserLoggedIn()) {
        emit(EditMyUserDataErrorState("User not logged in"));
        return;
      }
      final userDoc = AppConstants.collectionPath
          .collection("users")
          .doc(_auth.currentUser!.uid);
      await userDoc.update(userModel.toJson());
      myUserData = userModel;
      emit(EditMyUserDataSuccessState());
    } catch (error) {
      emit(EditMyUserDataErrorState("Failed to edit user data\n$error"));
    }
  }

//deleteMyUserData
  void deleteMyUserData() async {
    emit(DeleteMyUserDataLoadingState());
    try {
      if (!isUserLoggedIn()) {
        emit(DeleteMyUserDataErrorState("User not logged in"));
        return;
      }
      final userDoc = AppConstants.collectionPath
          .collection("users")
          .doc(_auth.currentUser!.uid);
      await userDoc.delete();
      myUserData = null;
      emit(DeleteMyUserDataSuccessState());
    } catch (error) {
      emit(DeleteMyUserDataErrorState("Failed to delete user data\n$error"));
    }
  }

  //getAllUsersData
  Future<List<UserModel>> getAllUsers({bool isUsersAndMe = false}) async {
    final usersDocs = AppConstants.collectionPath.collection("users");
    final usersData = await usersDocs.get();
    List<UserModel> users = [];
    for (final doc in usersData.docs) {
      if (isUserLoggedIn() && isUsersAndMe) {
        users.add(UserModel.fromJson(doc.data()));
      } else if (isUserLoggedIn()) {
        if (doc.id != _auth.currentUser!.uid) {
          users.add(UserModel.fromJson(doc.data()));
        }
      }
    }
    return users;
  }

//getAllUsersData

//getAllFilteredUsersData
  Future<List<UserModel>> getAllFilteredUsersData(String query) async {
    final users = await getAllUsers();
    return users
        .where((users) =>
            users.name.toLowerCase().contains(query.toLowerCase()) ||
            users.email.toLowerCase().contains(query.toLowerCase()) ||
            users.phone.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}

abstract class UserStates {}

class UserInitialState extends UserStates {}

//get my user data
class GetMyUserDataLoadingState extends UserStates {}

class GetMyUserDataSuccessState extends UserStates {}

class GetMyUserDataErrorState extends UserStates {
  final String error;

  GetMyUserDataErrorState(this.error);
}

//edit my user data
class EditMyUserDataLoadingState extends UserStates {}

class EditMyUserDataSuccessState extends UserStates {}

class EditMyUserDataErrorState extends UserStates {
  final String error;

  EditMyUserDataErrorState(this.error);
}

//delete my user data
class DeleteMyUserDataLoadingState extends UserStates {}

class DeleteMyUserDataSuccessState extends UserStates {}

class DeleteMyUserDataErrorState extends UserStates {
  final String error;

  DeleteMyUserDataErrorState(this.error);
}
