import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';
import '../../services/chat_service.dart';
import '../../models/group_model.dart';
import '../../models/user_model.dart';
import '../chat/chat_list_screen.dart';

class GroupInfoScreen extends StatefulWidget {
  final String groupId;

  const GroupInfoScreen({super.key, required this.groupId});

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  GroupModel? _group;
  final Map<String, UserModel> _members = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadGroup();
  }

  Future<void> _loadGroup() async {
    final chatService = Provider.of<ChatService>(context, listen: false);
    final group = await chatService.getGroup(widget.groupId);
    if (group != null) {
      setState(() {
        _group = group;
      });
      _loadMembers(group.members);
    }
  }

  Future<void> _loadMembers(List<String> memberIds) async {
    for (final memberId in memberIds) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(memberId)
          .get();
      if (doc.exists) {
        setState(() {
          _members[memberId] = UserModel.fromMap(
            doc.data()!,
            doc.id,
          );
        });
      }
    }
  }

  Future<void> _removeMember(String userId) async {
    if (_group == null) return;

    setState(() => _isLoading = true);

    try {
      final chatService = Provider.of<ChatService>(context, listen: false);
      await chatService.removeMemberFromGroup(widget.groupId, userId);
      _loadGroup(); // Reload group data
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _leaveGroup() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Group'),
        content: const Text('Are you sure you want to leave this group?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Leave'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      final chatService = Provider.of<ChatService>(context, listen: false);
      await chatService.leaveGroup(widget.groupId);

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const ChatListScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final currentUserId = authService.currentUser?.uid ?? '';
    final isAdmin = _group?.adminId == currentUserId;

    if (_group == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Info'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _group!.imageUrl != null
                        ? NetworkImage(_group!.imageUrl!)
                        : null,
                    child: _group!.imageUrl == null
                        ? Text(
                            _group!.name.isNotEmpty
                                ? _group!.name[0].toUpperCase()
                                : 'G',
                            style: const TextStyle(fontSize: 40),
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _group!.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('${_group!.members.length} members'),
                  const SizedBox(height: 24),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Members',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ..._group!.members.map((memberId) {
                          final member = _members[memberId];
                          final isMemberAdmin = memberId == _group!.adminId;
                          final canRemove = isAdmin &&
                              memberId != currentUserId &&
                              !isMemberAdmin;

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  member?.profileImageUrl != null
                                      ? NetworkImage(member!.profileImageUrl!)
                                      : null,
                              child: member?.profileImageUrl == null
                                  ? const Icon(Icons.person)
                                  : null,
                            ),
                            title: Row(
                              children: [
                                Text(member?.name ?? 'Loading...'),
                                if (isMemberAdmin) ...[
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Colors.amber,
                                  ),
                                ],
                              ],
                            ),
                            subtitle: Text(member?.email ?? ''),
                            trailing: canRemove
                                ? IconButton(
                                    icon: const Icon(Icons.remove_circle),
                                    onPressed: () => _removeMember(memberId),
                                  )
                                : null,
                          );
                        }),
                      ],
                    ),
                  ),
                  const Divider(),
                  if (!isAdmin)
                    ListTile(
                      leading: const Icon(Icons.exit_to_app, color: Colors.red),
                      title: const Text(
                        'Leave Group',
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: _leaveGroup,
                    ),
                ],
              ),
            ),
    );
  }
}

