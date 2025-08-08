import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/controller/layout_ctrl.dart';

import '../../../controller/post_ctrl.dart';

class CreateFeedView extends StatelessWidget {
  const CreateFeedView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = PostCtrl.get(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Post"),
      ),
      body: BlocConsumer<PostCtrl, PostStates>(
        listener: (context, state) {
          if (state is PostSuccessState) {
            LayoutCtrl.get(context).changeBottomNav(0);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Post created successfully")),
            );
          } else if (state is PostErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: ctrl.titleCtrl,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: ctrl.descriptionCtrl,
                  decoration: const InputDecoration(
                      hintText: 'Description',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      )),
                  maxLines: 4,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: ctrl.authorNameCtrl,
                  decoration: const InputDecoration(labelText: 'Author Name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: ctrl.pictureCtrl,
                  decoration: const InputDecoration(labelText: 'Picture URL'),
                  onChanged: (value) {
                    ctrl.onImageUrlChanged(value);
                  },
                ),
                const SizedBox(height: 16),

                /// Image preview
                BlocBuilder<PostCtrl, PostStates>(
                  builder: (context, state) {
                    final url = ctrl.pictureCtrl.text;
                    if (url.isNotEmpty &&
                        Uri.tryParse(url)?.hasAbsolutePath == true) {
                      return Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey),
                          image: DecorationImage(
                            image: NetworkImage(url),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        width: double.infinity,
                        height: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.image,
                                size: 50, color: Colors.grey),
                            const Text(
                              "Image preview",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: state is PostLoadingState
                          ? null
                          : () => ctrl.createPost(),
                      child: state is PostLoadingState
                          ? const Center(child: CircularProgressIndicator())
                          : ctrl.selectedPost == null
                              ? const Text("Submit Post")
                              : const Text(
                                  "Update Post",
                                )),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
