import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/random_user/random_user_controller.dart';

import '../core/network_image.dart';

class RandomUserPage extends StatelessWidget {
  const RandomUserPage({super.key});

  //here we will implement calling api random user > https://randomuser.me/api/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              context.read<RandomUserController>().fetchRandomUser();
            },
          )
        ],
      ),
      body: Center(
        child: BlocBuilder<RandomUserController, RandomUserStates>(
          builder: (context, state) {
            //1) waiting state or loading
            if (state is RandomUserLoadingState) {
              return CircularProgressIndicator();
            }

            //2) error state
            if (state is RandomUserErrorState) {
              return Text('Error: ${state.errorMessage}');
            }

            //3) success and empty
            final data = context.read<RandomUserController>().userModel;
            if (data == null) {
              return Text('No user data found.');
            }

            //4) success and not empty
            return Column(
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.blue[900],
                  child: Container(
                      height: 150,
                      width: 150,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: WebImageWidget(data.picture?.large ?? '')),
                ),
                const SizedBox(height: 20),
                Text(
                  '${data.name?.title ?? ''}: ${data.name?.first ?? ''} ${data.name?.last ?? ''}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  data.email ?? '',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  data.phone ?? '',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
