import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../models/story_model.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../services/story_service.dart';

class StoryViewerScreen extends StatefulWidget {
  final List<StoryModel> stories;
  final int initialIndex;
  final String userId;

  const StoryViewerScreen({
    super.key,
    required this.stories,
    required this.initialIndex,
    required this.userId,
  });

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen> {
  late int _currentIndex;
  VideoPlayerController? _videoController;
  UserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _loadUser();
    _loadStory();
  }

  Future<void> _loadUser() async {
    final doc = await FirebaseFirestore.instance
        .collection('Omar/#/users')
        .doc(widget.userId)
        .get();
    if (doc.exists) {
      setState(() {
        _user = UserModel.fromMap(
          doc.data()!,
          doc.id,
        );
      });
    }
  }

  void _loadStory() {
    setState(() => _isLoading = true);

    final story = widget.stories[_currentIndex];
    final authService = Provider.of<AuthService>(context, listen: false);
    final currentUserId = authService.currentUser?.uid;

    // Mark as seen
    if (currentUserId != null && !story.seenBy.contains(currentUserId)) {
      final storyService = Provider.of<StoryService>(context, listen: false);
      storyService.markStoryAsSeen(story.id);
    }

    if (story.mediaType == 'video') {
      _videoController?.dispose();
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(story.mediaUrl),
      );
      _videoController!.initialize().then((_) {
        setState(() => _isLoading = false);
        _videoController!.play();
      });
    } else {
      _videoController?.dispose();
      _videoController = null;
      setState(() => _isLoading = false);
    }
  }

  void _nextStory() {
    if (_currentIndex < widget.stories.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _loadStory();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _previousStory() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _loadStory();
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.stories.isEmpty) {
      Navigator.of(context).pop();
      return const SizedBox.shrink();
    }

    final story = widget.stories[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) {
          final screenWidth = MediaQuery.of(context).size.width;
          if (details.localPosition.dx < screenWidth / 2) {
            _previousStory();
          } else {
            _nextStory();
          }
        },
        child: Stack(
          children: [
            // Story content
            Center(
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : story.mediaType == 'video'
                      ? _videoController != null &&
                              _videoController!.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: _videoController!.value.aspectRatio,
                              child: VideoPlayer(_videoController!),
                            )
                          : const CircularProgressIndicator(color: Colors.white)
                      : CachedNetworkImage(
                          imageUrl: story.mediaUrl,
                          fit: BoxFit.contain,
                          placeholder: (context, url) => const Center(
                            child:
                                CircularProgressIndicator(color: Colors.white),
                          ),
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(Icons.error, color: Colors.white),
                          ),
                        ),
            ),
            // Top bar with user info
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: _user?.profileImageUrl != null
                          ? NetworkImage(_user!.profileImageUrl!)
                          : null,
                      child: _user?.profileImageUrl == null
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _user?.name ?? 'Unknown',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_currentIndex + 1} / ${widget.stories.length}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ),
            // Progress indicators
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: Row(
                children: List.generate(
                  widget.stories.length,
                  (index) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      height: 3,
                      decoration: BoxDecoration(
                        color: index <= _currentIndex
                            ? Colors.white
                            : Colors.white30,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
