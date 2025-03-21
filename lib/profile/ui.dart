import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Map<String, dynamic> data;
  bool isLoading = false;

  //https://randomuser.me/api/
  final dio = Dio(BaseOptions(baseUrl: "https://randomuser.me/api/"));

  void getData() async {
    setState(() {
      isLoading = true;
    });
    final response = await dio.get('');
    if (response.statusCode == 200) {
      setState(() {
        data = response.data['results'][0];
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 10,
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          data['picture']['large'],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _item(CupertinoIcons.person,
                      "${data['name']['title']}: ${data['name']['first']} ${data['name']['last']}"),
                  _item(CupertinoIcons.mail, data['email']),
                  _item(CupertinoIcons.phone, data['phone']),
                  _item(CupertinoIcons.location, data['location']['country']),
                  ElevatedButton(onPressed: getData, child: Text("REFRESH"))
                ],
              ),
            ),
    );
  }

  Widget _item(IconData icon, String text) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 10),
            Text(text),
          ],
        ),
      ),
    );
  }
}
