import 'package:flutter/material.dart';
import 'package:new_3c/services/dio_service.dart';
import 'package:new_3c/widgets/empty_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DogApiPage extends StatefulWidget {
  const DogApiPage({super.key});

  @override
  State<DogApiPage> createState() => _DogApiPageState();
}

class _DogApiPageState extends State<DogApiPage> {
  late Future<String?> _dogImageFuture;

  @override
  void initState() {
    super.initState();
    _dogImageFuture = fetchDogImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dog API Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 350,
              width: double.infinity,
              child: FutureBuilder<String?>(
                future: _dogImageFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Skeletonizer(
                      enabled: true,
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return ErrorWidget(snapshot.error.toString());
                  }
                  final imageUrl = snapshot.data;
                  if (imageUrl == null || imageUrl.isEmpty) {
                    return EmptyWidget();
                  }
                  return Container(
                    margin: const EdgeInsets.all(10),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    _dogImageFuture = fetchDogImage();
                  });
                },
                child: Text("Refresh"))
          ],
        ),
      ),
    );
  }
}

Future<String?> fetchDogImage() async {
  final response = await HttpUtil().get<Map<String, dynamic>>('');
  return response?["message"];
}
