import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  Map<String, dynamic> userData = {};
  final _dio = Dio();
  bool isLoading = true;

  void getData() async {
    setState(() {
      isLoading = true;
    });
    final response = await _dio.get("https://randomuser.me/api/");
    if (response.statusCode == 200) {
      setState(() {
        userData = response.data['results'][0];
      });
    } else {
      print("Error fetching data: ${response.statusCode}");
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Column(
                children: [
                  CircleAvatar(
                    radius: 62,
                    backgroundColor: Colors.blue,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                        userData["picture"]["medium"],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "${userData["name"]["title"]}: ${userData["name"]["first"]} ${userData["name"]["last"]}",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
