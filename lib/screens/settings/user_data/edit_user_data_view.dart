import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/app/extension.dart';
import 'package:new_3c/controller/user_ctrl/user_cubit.dart';
import 'package:new_3c/models/user.dart';

class EditUserDataView extends StatefulWidget {
  const EditUserDataView(this.userModel, {super.key});

  final UserModel userModel;

  @override
  State<EditUserDataView> createState() => _EditUserDataViewState();
}

class _EditUserDataViewState extends State<EditUserDataView> {
  late final TextEditingController nameCtrl =
      TextEditingController(text: widget.userModel.name);
  late final TextEditingController phoneCtrl =
      TextEditingController(text: widget.userModel.phone);
  late final TextEditingController bioCtrl =
      TextEditingController(text: widget.userModel.bio);
  late final TextEditingController imgUrlCtrl =
      TextEditingController(text: widget.userModel.imgUrl);

  late bool isMale = widget.userModel.isMale;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit User Data"),
      ),
      body: BlocListener<UserCubit, UserStates>(
        listener: (context, state) {
          if (state is EditMyUserDataSuccessState) {
            context.showSuccess("User data updated successfully");
            context.pop();
          }
          if (state is EditMyUserDataErrorState) {
            context.showError(state.error);
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
                  SegmentedButton(
                    showSelectedIcon: false,
                    style: SegmentedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.transparent,
                      selectedBackgroundColor: Colors.cyan,
                    ),
                    onSelectionChanged: (v) {
                      setState(() {
                        isMale = v.first == "Male";
                      });
                    },
                    segments: [
                      ButtonSegment(
                        value: "Male",
                        label: Text("Male"),
                        icon: Icon(Icons.male),
                      ),
                      ButtonSegment(
                        value: "Female",
                        label: Text("Female"),
                        icon: Icon(Icons.female),
                      ),
                    ],
                    selected: {isMale ? "Male" : "Female"},
                  ),
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
                    controller: imgUrlCtrl,
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
                  BlocBuilder<UserCubit, UserStates>(
                    builder: (context, state) {
                      final cubit = context.read<UserCubit>();
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
                                    imgUrl: imgUrlCtrl.text,
                                    phone: phoneCtrl.text,
                                    isMale: isMale,
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
