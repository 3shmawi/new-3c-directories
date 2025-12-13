import 'package:flutter/material.dart';
import 'package:new_3c/models/user_model.dart';
import 'package:new_3c/screens/auth/login_screen.dart';
import 'package:new_3c/screens/auth/profile_setup_screen.dart';
import 'package:new_3c/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final authServices = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: false,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.edit))],
      ),
      body: FutureBuilder<UserModel?>(
          future: authServices.getCurrentUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            }

            final userData = snapshot.data;

            if (userData == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10,
                  children: [
                    Text("No data, please setup your profile"),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => ProfileSetupScreen()),
                            (_) => false,
                          );
                        },
                        child: Text("Complete profile"))
                  ],
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: userData.profileImageUrl != null
                        ? NetworkImage(userData.profileImageUrl!)
                        : null,
                  ),
                  Text(
                    userData.email.split("@").first,
                    style: TextStyle(color: Colors.grey[400], fontSize: 13),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.drive_file_rename_outline),
                      title: Text(userData.name),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.email_outlined),
                      title: Text(userData.email),
                      trailing: Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                  Spacer(),
                  Card(
                    color: Colors.red,
                    child: ListTile(
                      onTap: () {
                        authServices.signOut();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                          (_) => false,
                        );
                      },
                      title: Center(
                        child: Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
