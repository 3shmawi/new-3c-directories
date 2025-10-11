import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../helpers/web_network_images.dart';

class DisplayUserProfile extends StatefulWidget {
  const DisplayUserProfile({super.key});

  @override
  State<DisplayUserProfile> createState() => _DisplayUserProfileState();
}

class _DisplayUserProfileState extends State<DisplayUserProfile> {
  final dio = Dio();
  bool isLoading = false;
  Map<String, dynamic> userProfile = {};

  void getUserProfile() async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await dio.get('https://randomuser.me/api/');
      userProfile = response.data['results'][0];
    } catch (error) {
      log('Error fetching user profile: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getUserProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedCrossFade(
          firstChild: Column(
            children: [
              const SizedBox(height: 50),
              //iamge
              if (userProfile['picture']?['large'] != null)
                Container(
                  height: 100,
                  width: 100,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: WebImageWidget(
                    userProfile['picture']['large'],
                  ),
                ),

              //name
              Text(
                '${userProfile['name']?['title']}: ${userProfile['name']?['first']} ${userProfile['name']?['last']}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          secondChild: CircularProgressIndicator(),
          crossFadeState:
              isLoading ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ),
    );
  }
}
