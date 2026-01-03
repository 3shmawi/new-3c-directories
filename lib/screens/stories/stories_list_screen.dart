import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_3c/services/storage_service.dart';
import 'package:provider/provider.dart';

import '../../models/story_model.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/story_service.dart';
import '../../widgets/story_item.dart';
import 'story_viewer_screen.dart';

class StoriesListScreen extends StatefulWidget {
  const StoriesListScreen({super.key});

  @override
  State<StoriesListScreen> createState() => _StoriesListScreenState();
}

class _StoriesListScreenState extends State<StoriesListScreen> {
  final _picker = ImagePicker();
  final Map<String, UserModel> _users = {};
  bool isLoading = false;

  Future<void> _loadUser(String userId) async {
    if (_users.containsKey(userId)) return;

    final doc = await FirebaseFirestore.instance
        .collection('Omar/#/users')
        .doc(userId)
        .get();
    if (doc.exists) {
      setState(() {
        _users[userId] = UserModel.fromMap(
          doc.data()!,
          doc.id,
        );
      });
    }
  }

  Future<void> _createStory() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                await _pickAndUploadStory(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('Choose Video from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                await _pickAndUploadVideo(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () async {
                Navigator.pop(context);
                await _pickAndUploadStory(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('Record Video'),
              onTap: () async {
                Navigator.pop(context);
                await _pickAndUploadVideo(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndUploadStory(ImageSource source) async {
    setState(() {
      isLoading = true;
    });
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 85,
    );

    if (image == null) return;

    try {
      final storyService = Provider.of<StoryService>(context, listen: false);
      await storyService.createStory(
        mediaFile: File(image.path),
        mediaType: 'image',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Story created successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating story: $e')),
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _pickAndUploadVideo(ImageSource source) async {
    setState(() {
      isLoading = true;
    });
    final XFile? video = await _picker.pickVideo(
      source: source,
      maxDuration: const Duration(seconds: 60),
    );

    if (video == null) return;

    try {
      final storyService = Provider.of<StoryService>(context, listen: false);
      await storyService.createStory(
        mediaFile: File(video.path),
        mediaType: 'video',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Story created successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating story: $e')),
        );
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final storyService = Provider.of<StoryService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final currentUserId = authService.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Stories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: _createStory,
          ),
        ],
      ),
      body: Column(
        children: [
          if (isLoading)
            ValueListenableBuilder(
                valueListenable: progressNotifier,
                builder: (context, value, child) {
                  return LinearProgressIndicator(
                    value: value,
                  );
                }),
          Expanded(
            child: StreamBuilder<List<StoryModel>>(
              stream: storyService.getActiveStories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  log(snapshot.error.toString());

                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final stories = snapshot.data ?? [];

                if (stories.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.auto_stories,
                            size: 80, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text(
                          'No stories yet',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: _createStory,
                          icon: const Icon(Icons.add),
                          label: const Text('Create Your First Story'),
                        ),
                      ],
                    ),
                  );
                }
                // Group stories by user
                final Map<String, List<StoryModel>> storiesByUser = {};
                for (final story in stories) {
                  if (!storiesByUser.containsKey(story.userId)) {
                    storiesByUser[story.userId] = [];
                  }
                  storiesByUser[story.userId]!.add(story);
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: .7,
                  ),
                  itemCount: storiesByUser.isEmpty ? 1 : storiesByUser.length,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      final myStories = storiesByUser[currentUserId];
                      if (myStories == null || myStories.isEmpty) {
                        return InkWell(
                          onTap: _createStory,
                          child: DottedBorder(
                            childOnTop: true,
                            options: RoundedRectDottedBorderOptions(
                              radius: Radius.circular(10),
                              color: Colors.cyan,
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.add_circle,
                                    size: 80,
                                    color: Colors.grey,
                                  ),
                                  Text("Add your story")
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      return Card(
                        clipBehavior: Clip.hardEdge,
                        child: StoryItem(
                          stories: myStories,
                          userName: "Your Story",
                        ),
                      );
                    }

                    storiesByUser.remove(currentUserId);
                    final userId = storiesByUser.keys.elementAt(index - 1);
                    final userStories = storiesByUser[userId]!;
                    _loadUser(userId);

                    final user = _users[userId];
                    final userName = user?.name ?? 'Unknown';
                    final userImageUrl = user?.profileImageUrl;

                    return Card(
                      clipBehavior: Clip.hardEdge,
                      child: StoryItem(
                        stories: userStories,
                        userName: userName,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class StoryItem extends StatelessWidget {
  const StoryItem({required this.stories, required this.userName, super.key});

  final List<StoryModel> stories;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => StoryViewerScreen(
              stories: stories,
              initialIndex: 0,
              userId: stories.first.userId,
            ),
          ),
        );
      },
      child: Stack(
        alignment: AlignmentGeometry.bottomCenter,
        children: [
          Positioned.fill(
            child: Image.network(
              stories.first.mediaUrl,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(5),
              color: Colors.black38,
              child: Text(
                userName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          Positioned(
            top: 3,
            left: 3,
            child: Text(
              stories.length.toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
          Positioned(
            top: 3,
            right: 3,
            child: Text(
              "now",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                shadows: [
                  BoxShadow(
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
