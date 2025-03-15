import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class GetDogImage extends StatefulWidget {
  const GetDogImage({super.key});

  @override
  State<GetDogImage> createState() => _GetDogImageState();
}

class _GetDogImageState extends State<GetDogImage> {
  String? image;
  bool isLoading = false;
  final dio = Dio(BaseOptions(baseUrl: "https://dog.ceo/api/"));

  void getImage() async {
    setState(() {
      isLoading = true;
    });
    final response = await dio.get('breeds/image/random');
    setState(() {
      image = response.data['message'];
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            onPressed: getImage,
            icon: Icon(Icons.api),
          ),
        ],
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 100,
                backgroundImage: NetworkImage(image!),
              ),
      ),
    );
  }
}
