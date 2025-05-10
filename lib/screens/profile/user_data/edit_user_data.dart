import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/app/extension.dart';
import 'package:new_3c/app/toast.dart';
import 'package:new_3c/controller/auth_ctrl.dart';
import 'package:new_3c/models/author.dart';

class EditUserDataView extends StatefulWidget {
  const EditUserDataView(this.userModel, {super.key});

  final AuthorModel userModel;

  @override
  State<EditUserDataView> createState() => _EditUserDataViewState();
}

class _EditUserDataViewState extends State<EditUserDataView> {
  late final TextEditingController nameCtrl =
      TextEditingController(text: widget.userModel.name);
  late final TextEditingController emailCtrl =
      TextEditingController(text: widget.userModel.email);
  late final TextEditingController passwordCtrl =
      TextEditingController(text: widget.userModel.password);
  late final TextEditingController phoneCtrl =
      TextEditingController(text: widget.userModel.phone);
  late final TextEditingController bioCtrl =
      TextEditingController(text: widget.userModel.bio);
  late final TextEditingController avatarCtrl =
      TextEditingController(text: widget.userModel.avatar);

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit User Data"),
      ),
      body: BlocListener<AuthCtrl, AuthStates>(
        listener: (context, state) {
          if (state is EditMyUserDataSuccessState) {
            AppToast.showSuccess("User data updated successfully");
            context.navigateBack();
          }
          if (state is EditMyUserDataErrorState) {
            AppToast.showError(state.error);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                spacing: 20,
                children: [
                  TextFormField(
                    controller: nameCtrl,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your name";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      labelText: "Full Name",
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.cyan,
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: emailCtrl,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      labelText: "Email Address",
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.cyan,
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: phoneCtrl,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your phone";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      labelText: "Phone number",
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Colors.cyan,
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: avatarCtrl,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your img url";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      labelText: "User Image",
                      prefixIcon: Icon(
                        Icons.photo_album_outlined,
                        color: Colors.cyan,
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: passwordCtrl,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      labelText: "Password",
                      prefixIcon: Icon(
                        Icons.password,
                        color: Colors.cyan,
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: bioCtrl,
                    minLines: 5,
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your bio";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      hintText: "Bio",
                    ),
                  ),
                  // Spacer(),
                  BlocBuilder<AuthCtrl, AuthStates>(
                    builder: (context, state) {
                      final cubit = context.read<AuthCtrl>();
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 45),
                          backgroundColor: Colors.cyan,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: state is EditMyUserDataLoadingState
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  cubit
                                      .editMyUserData(widget.userModel.copyWith(
                                    name: nameCtrl.text,
                                    avatar: avatarCtrl.text,
                                    phone: phoneCtrl.text,
                                    bio: bioCtrl.text,
                                  ));
                                }
                              },
                        child: state is EditMyUserDataLoadingState
                            ? CircularProgressIndicator()
                            : Text("EDIT MY DATA"),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
