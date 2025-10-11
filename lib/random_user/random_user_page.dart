import 'package:flutter/material.dart';
import 'package:new_3c/model/user_model.dart';

import '../core/network_image.dart';
import '../services/dio_service.dart';

class RandomUserPage extends StatefulWidget {
  const RandomUserPage({super.key});

  @override
  State<RandomUserPage> createState() => _RandomUserPageState();
}

class _RandomUserPageState extends State<RandomUserPage> {
  //here we will implement calling api random user > https://randomuser.me/api/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          )
        ],
      ),
      body: Center(
        child: FutureBuilder<UserModel?>(
          future: fetchRandomUserData(),
          builder: (context, snapshot) {
            //1) waiting state or loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            //2) error state
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            //3) success and empty
            final data = snapshot.data;
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

Future<UserModel?> fetchRandomUserData() async {
  final response = await HttpUtil().get<Map<String, dynamic>>('');
  final data = response?["results"]?[0];
  if (data != null) {
    return UserModel.fromJson(data);
  }
  return null;
}
