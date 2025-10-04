import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../helpers/web_network_images.dart';

class DisplayDogImage extends StatefulWidget {
  const DisplayDogImage({super.key});

  @override
  State<DisplayDogImage> createState() => _DisplayDogImageState();
}

class _DisplayDogImageState extends State<DisplayDogImage> {
  final dio = Dio();
  final _controller = FixedExtentScrollController();
  Timer? _autoTimer;
  int _currentIndex = 0;
  bool _isUserInteracting = false;

  List<String> imagesUrl = [];

  Future<String> getImage() async {
    final response = await dio.get('https://dog.ceo/api/breeds/image/random');
    return response.data['message'];
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _maybeStartAutoScroll() {
    if (imagesUrl.isEmpty) return;
    _autoTimer?.cancel(); // restart cleanly

    // Auto-scroll كل 1.5 ثانية للي بعده مع أنيميشن ناعمة
    _autoTimer = Timer.periodic(const Duration(milliseconds: 1500), (_) async {
      if (!mounted) return;
      if (_isUserInteracting) return; // لو المستخدم بيتفاعل، وقّف مؤقتًا

      // زوّد الاندكس ولف لو تعدّى الطول (loop)
      _currentIndex = (_currentIndex + 1) % imagesUrl.length;

      // تحريك بالعُنصر (smooth)
      try {
        await _controller.animateToItem(
          _currentIndex,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOutCubic,
        );
      } catch (_) {
        // أحيانًا لو حصل rebuild أثناء التحريك بيترمي استثناء—نتجاهله
      }
    });
  }

  void _onAddImagePressed() async {
    try {
      final imageUrl = await getImage();
      setState(() {
        imagesUrl.add(imageUrl);
        if (imagesUrl.length == 1) {
          // أول صورة—ابدأ الأوتو سكرول
          _currentIndex = 0;
          _maybeStartAutoScroll();
        }
      });
    } catch (e) {
      debugPrint('Error fetching image: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasData = imagesUrl.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dog Image'),
        actions: [
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: _onAddImagePressed,
            tooltip: 'Add random dog image',
          ),
        ],
      ),
      body: GestureDetector(
        onTapDown: (_) {
          _isUserInteracting = true;
        },
        onTapUp: (_) {
          _isUserInteracting = false;
        },
        onTapCancel: () {
          _isUserInteracting = false;
        },
        onPanDown: (_) {
          _isUserInteracting = true;
        },
        onPanEnd: (_) {
          _isUserInteracting = false;
        },
        child: hasData
            ? ListWheelScrollView.useDelegate(
                controller: _controller,
                physics: const FixedExtentScrollPhysics(),
                itemExtent: 200,
                perspective: 0.0025, // منظور خفيف for modern look
                diameterRatio: 3.0, // يقلل الانحناء
                onSelectedItemChanged: (i) {
                  _currentIndex = i % imagesUrl.length;
                },
                childDelegate: ListWheelChildLoopingListDelegate(
                  children: List.generate(
                    imagesUrl.length,
                    (index) => Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: WebImageWidget(imagesUrl[index]),
                      ),
                    ),
                  ),
                ),
              )
            : _EmptyState(onAdd: _onAddImagePressed),
      ),
      floatingActionButton: hasData
          ? FloatingActionButton.extended(
              onPressed: () {
                if (_autoTimer == null) {
                  _maybeStartAutoScroll();
                } else {
                  // toggle play/pause
                  if (_isUserInteracting) _isUserInteracting = false;
                  if (_autoTimer!.isActive) {
                    _autoTimer!.cancel();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Auto-scroll paused')),
                    );
                  } else {
                    _maybeStartAutoScroll();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Auto-scroll resumed')),
                    );
                  }
                }
              },
              icon: const Icon(Icons.autorenew),
              label: const Text('Auto'),
            )
          : null,
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.pets, size: 56, color: cs.primary),
          const SizedBox(height: 12),
          Text(
            'No images yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            'Tap the image icon to add random dogs',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.image_outlined),
            label: const Text('Add image'),
          ),
        ],
      ),
    );
  }
}
