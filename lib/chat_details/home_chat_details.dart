import 'package:flutter/material.dart';

class HomeChatDetails extends StatelessWidget {
  const HomeChatDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back,
              ),
            ),
            CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80"),
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "message...",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            )
          ],
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text("View Profile"),
              ),
              PopupMenuItem(
                value: 2,
                child: Text("Mute Notifications"),
              ),
              PopupMenuItem(
                value: 3,
                child: Text("Block"),
              ),
              PopupMenuItem(
                value: 4,
                child: Text("Delete Chat"),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Text("Chat Details Screen"),
      ),
      bottomNavigationBar: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Message...",
                  prefixIcon: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.sticky_note_2_outlined,
                    ),
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.attach_file),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.camera_alt_outlined),
                      ),
                    ],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                ),
              ),
            ),
          ),
          FloatingActionButton.small(
            shape: CircleBorder(),
            onPressed: () {},
            child: Icon(
              Icons.send,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
