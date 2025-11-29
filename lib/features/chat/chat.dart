import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_3c/features/auth/auth.dart';

import 'controller/message_ctrl.dart';
import 'model/message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _listController = ScrollController();
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  bool _showScrollToBottom = false;
  bool _recording = false;
  bool _recordingCancelled = false;
  late AnimationController _recordPulse;
  late AnimationController _typingDots;

  // For “slide to cancel”
  Offset _dragOffset = Offset.zero;
  double _cancelThreshold = 120; // drag left to cancel

  @override
  void initState() {
    super.initState();
    context.read<MessageCtrl>().fetchProfileData();

    _recordPulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: 0.9,
      upperBound: 1.05,
    )..repeat(reverse: true);

    _typingDots = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    _listController.addListener(() {
      final nearBottom = _listController.offset <= 50;
      if (_showScrollToBottom == nearBottom) return;
      setState(() => _showScrollToBottom = !nearBottom);
    });
  }

  @override
  void dispose() {
    _listController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    _recordPulse.dispose();
    _typingDots.dispose();
    super.dispose();
  }

  void _sendText() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    context.read<MessageCtrl>().sendMessage(text);
    _textController.clear();
    _scrollToBottomSmooth();
  }

  void _scrollToBottomSmooth() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_listController.hasClients) return;
      _listController.animateTo(
        0,
        curve: Curves.easeOutCubic,
        duration: const Duration(milliseconds: 300),
      );
    });
  }

  void _openAttachSheet() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _AttachItem(
                icon: Icons.photo,
                label: "Gallery",
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _AttachItem(
                icon: Icons.photo_camera,
                label: "Camera",
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              _AttachItem(
                icon: Icons.insert_drive_file,
                label: "File",
                onTap: () {
                  Navigator.pop(context);
                  _showSnack("File picker UI here");
                },
              ),
              _AttachItem(
                icon: Icons.location_on,
                label: "Location",
                onTap: () {
                  Navigator.pop(context);
                  _showSnack("Location picker UI here");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // ————— MIC (hold to record) —————

  void _startRecording() {
    setState(() {
      _recording = true;
      _recordingCancelled = false;
      _dragOffset = Offset.zero;
    });
  }

  void _updateDrag(Offset delta) {
    // Only horizontal slide matters (left to cancel)
    setState(() {
      _dragOffset += delta;
      if (_dragOffset.dx < -_cancelThreshold) {
        _recordingCancelled = true;
      } else {
        _recordingCancelled = false;
      }
    });
  }

  void _stopRecording() {
    final cancelled = _recordingCancelled;
    setState(() {
      _recording = false;
      _recordingCancelled = false;
      _dragOffset = Offset.zero;
    });
    if (cancelled) {
      _showSnack("Recording cancelled");
      return;
    }

    _scrollToBottomSmooth();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return BlocProvider(
      create: (context) => MessageCtrl()..fetchProfileData(),
      child: Builder(builder: (context) {
        return BlocConsumer<MessageCtrl, MessageStates>(
          listener: (context, state) {
            if (state is MessageErrorState) {
              _showSnack(state.error);
            }
          },
          builder: (context, state) {
            final ctrl = context.read<MessageCtrl>();
            return Scaffold(
              backgroundColor: cs.surface,
              appBar: _buildAppBar(cs),
              body: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: NotificationListener<UserScrollNotification>(
                          onNotification: (_) => false,
                          child: StreamBuilder<List<Message>>(
                              stream: ctrl.getMessages(),
                              builder: (context, snapshot) {
                                //first state, connection state
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }

                                //second error state
                                if (snapshot.hasError) {
                                  return Center(
                                    child: Text(
                                        "Error: ${snapshot.error.toString()}"),
                                  );
                                }

                                //success but empty
                                final messages = snapshot.data;
                                if (messages == null || messages.isEmpty) {
                                  return const Center(
                                      child: Text("No messaged yet"));
                                }

                                //success and data
                                return StreamBuilder<bool>(
                                    stream: ctrl.isTypingStream(),
                                    builder: (context, snapshot) {
                                      final isTyping = snapshot.data ?? false;
                                      return ListView.builder(
                                        controller: _listController,
                                        reverse: true,
                                        padding: const EdgeInsets.fromLTRB(
                                            12, 8, 12, 12),
                                        itemCount: messages.length +
                                            (isTyping ? 1 : 0),
                                        itemBuilder: (context, index) {
                                          if (isTyping && index == 0) {
                                            return const _TypingIndicator();
                                          }
                                          final msg = messages[
                                              isTyping ? index - 1 : index];
                                          final next = (isTyping
                                                      ? index - 2
                                                      : index - 1) >=
                                                  0
                                              ? messages[isTyping
                                                  ? index - 2
                                                  : index - 1]
                                              : null;
                                          final showAvatar =
                                              !(msg.profileAvatar == null) &&
                                                  (next == null ||
                                                      _minGap(next, msg));
                                          return _MessageRow(
                                            message: msg,
                                            showAvatar: showAvatar,
                                          );
                                        },
                                      );
                                    });
                              }),
                        ),
                      ),
                      _Composer(
                        controller: _textController,
                        focusNode: _focusNode,
                        onAttach: _openAttachSheet,
                        onSend: _sendText,
                        onStartRecord: _startRecording,
                        onStopRecord: _stopRecording,
                        onDragUpdate: _updateDrag,
                      ),
                      SizedBox(height: MediaQuery.of(context).padding.bottom),
                    ],
                  ),
                  // Recording overlay

                  if (_showScrollToBottom)
                    Positioned(
                      right: 16,
                      bottom: 96,
                      child: FloatingActionButton.small(
                        heroTag: 'scroll_bottom',
                        onPressed: _scrollToBottomSmooth,
                        child: const Icon(Icons.keyboard_arrow_down),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  bool _minGap(Message a, Message b) {
    return b.time.difference(a.time).inMinutes.abs() >= 3;
  }

  PreferredSizeWidget _buildAppBar(ColorScheme cs) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 2,
      titleSpacing: 0,
      title: Row(
        children: [
          const SizedBox(width: 8),
          Stack(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  "https://images.unsplash.com/photo-1577563908411-5077b6dc7624?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Y2hhdHxlbnwwfHwwfHx8MA%3D%3D",
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: cs.surface, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("World Chat",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    )),
                Row(
                  children: [
                    Icon(Icons.lock, size: 12, color: Colors.grey[400]),
                    const SizedBox(width: 4),
                    Text(
                      "End-to-end encrypted",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();

            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
              builder: (context) {
                return const AuthPage();
              },
            ), (_) => false);
          },
          icon: const Icon(
            Icons.logout,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            CupertinoIcons.profile_circled,
          ),
        ),
      ],
    );
  }
}

// ————————————————————————————————————————————————
// Message Row & Bubbles
// ————————————————————————————————————————————————

class _MessageRow extends StatelessWidget {
  const _MessageRow({
    required this.message,
    required this.showAvatar,
  });

  final Message message;
  final bool showAvatar;

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final isMe = auth.currentUser?.uid == message.senderId;
    return Padding(
      padding: EdgeInsets.only(
        top: 6,
        bottom: 6,
        left: isMe ? 48 : 8,
        right: isMe ? 8 : 48,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            AnimatedOpacity(
              opacity: showAvatar ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: const CircleAvatar(
                radius: 14,
                backgroundImage: NetworkImage(
                  "https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=400",
                ),
                foregroundColor: Colors.transparent,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              child: _Bubble(message: message),
            ),
          ),
          if (isMe) const SizedBox(width: 4),
          if (isMe)
            Icon(
              message.seen ? Icons.done_all : Icons.check,
              size: 16,
              color: message.seen
                  ? const Color(0xFF4C7CF5)
                  : Theme.of(context).colorScheme.outline,
            ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isMe = message.isMe;

    final bg = isMe
        ? const LinearGradient(
            colors: [const Color(0xFF4C7CF5), const Color(0xFF6AA4FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : LinearGradient(
            colors: [
              cs.surfaceContainerHighest,
              cs.surfaceContainerHigh,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    final bubble = Container(
      decoration: BoxDecoration(
        gradient: bg,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: Radius.circular(isMe ? 18 : 4),
          bottomRight: Radius.circular(isMe ? 4 : 18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.only(
        left: 12,
        right: 12,
        top: 8,
        bottom: 8,
      ),
      child: _bubbleContent(context, isMe),
    );

    return bubble;
  }

  Widget _bubbleContent(BuildContext context, bool isMe) {
    final onMyBubble =
        isMe ? Colors.white : Theme.of(context).colorScheme.onSurface;
    final timeStyle = TextStyle(
      fontSize: 10,
      color: isMe
          ? Colors.white.withValues(alpha: 0.85)
          : Theme.of(context).colorScheme.onSurfaceVariant,
    );
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        SelectableText(
          message.text,
          style: TextStyle(
            color: isMe ? Colors.white : onMyBubble,
            fontSize: 15,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 4),
        Text(_formatTime(message.time), style: timeStyle),
      ],
    );
  }

  String _formatTime(DateTime t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return "$h:$m";
  }
}
// ————————————————————————————————————————————————
// Composer
// ————————————————————————————————————————————————

class _Composer extends StatefulWidget {
  const _Composer({
    required this.controller,
    required this.focusNode,
    required this.onAttach,
    required this.onSend,
    required this.onStartRecord,
    required this.onStopRecord,
    required this.onDragUpdate,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onAttach;
  final VoidCallback onSend;
  final VoidCallback onStartRecord;
  final VoidCallback onStopRecord;
  final void Function(Offset delta) onDragUpdate;

  @override
  State<_Composer> createState() => _ComposerState();
}

class _ComposerState extends State<_Composer> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_watchText);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_watchText);
    context.read<MessageCtrl>().changeTypingValue(false);

    super.dispose();
  }

  void _watchText() {
    final v = widget.controller.text.trim().isNotEmpty;
    if (v != _hasText) setState(() => _hasText = v);
    context.read<MessageCtrl>().changeTypingValue(true);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        decoration: BoxDecoration(
          color: cs.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, -2),
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                      color: cs.outlineVariant.withValues(alpha: 0.5)),
                ),
                child: TextField(
                  controller: widget.controller,
                  focusNode: widget.focusNode,
                  minLines: 1,
                  maxLines: 5,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    isCollapsed: true,
                    hintText: "Message",
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    border: InputBorder.none,
                  ),
                  onTapOutside: (_) {
                    FocusScope.of(context).unfocus();
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            _RoundedIcon(
              key: const ValueKey('send'),
              icon: Icons.send_rounded,
              onTap: widget.onSend,
              tooltip: "Send",
              filled: true,
            )
          ],
        ),
      ),
    );
  }
}

class _RoundedIcon extends StatelessWidget {
  const _RoundedIcon({
    super.key,
    required this.icon,
    this.onTap,
    this.tooltip,
    this.filled = false,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final String? tooltip;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = filled ? cs.primary : cs.surfaceContainerHighest;
    final fg = filled ? Colors.white : cs.onSurface;

    final btn = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(24),
          border: filled
              ? null
              : Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
          boxShadow: filled
              ? [
                  BoxShadow(
                    color: cs.primary.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  )
                ]
              : null,
        ),
        child: Icon(icon, color: fg),
      ),
    );

    return tooltip == null ? btn : Tooltip(message: tooltip!, child: btn);
  }
}

// Mic hold button with drag tracking
class _HoldToRecordButton extends StatefulWidget {
  const _HoldToRecordButton({
    super.key,
    required this.onStart,
    required this.onStop,
    required this.onDragUpdate,
  });

  final VoidCallback onStart;
  final VoidCallback onStop;
  final void Function(Offset delta) onDragUpdate;

  @override
  State<_HoldToRecordButton> createState() => _HoldToRecordButtonState();
}

class _HoldToRecordButtonState extends State<_HoldToRecordButton> {
  Offset _lastLocal = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onLongPressStart: (_) => widget.onStart(),
      onLongPressMoveUpdate: (d) {
        if (_lastLocal == Offset.zero) _lastLocal = d.localOffsetFromOrigin;
        final delta = d.localOffsetFromOrigin - _lastLocal;
        _lastLocal = d.localOffsetFromOrigin;
        widget.onDragUpdate(delta);
      },
      onLongPressEnd: (_) {
        _lastLocal = Offset.zero;
        widget.onStop();
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cs.primary,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: cs.primary.withValues(alpha: 0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(Icons.mic, color: Colors.white),
      ),
    );
  }
}

// Recording overlay
class _RecordingOverlay extends StatelessWidget {
  const _RecordingOverlay({
    required this.pulse,
    required this.dragOffset,
    required this.cancelled,
    required this.cancelThreshold,
  });

  final Animation<double> pulse;
  final Offset dragOffset;
  final bool cancelled;
  final double cancelThreshold;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Positioned.fill(
      child: IgnorePointer(
        child: Container(
          color: Colors.black.withValues(alpha: 0.35),
          child: Center(
            child: Transform.translate(
              offset: Offset(dragOffset.dx * 0.5, 0),
              child: AnimatedScale(
                scale: pulse.value,
                duration: const Duration(milliseconds: 150),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  decoration: BoxDecoration(
                    color: cancelled ? Colors.red : cs.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 20,
                      )
                    ],
                    border: Border.all(
                      color: cancelled
                          ? Colors.redAccent
                          : cs.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        cancelled ? Icons.delete_forever : Icons.mic,
                        color: cancelled ? Colors.white : cs.primary,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        cancelled
                            ? "Release to cancel"
                            : "Recording… slide left to cancel",
                        style: TextStyle(
                          color: cancelled ? Colors.white : cs.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: cancelled
                              ? Colors.white.withValues(alpha: 0.15)
                              : cs.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "${(dragOffset.dx.abs() / cancelThreshold * 100).clamp(0, 100).toStringAsFixed(0)}%",
                          style: TextStyle(
                            color: cancelled ? Colors.white : cs.primary,
                            fontSize: 12,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Typing indicator (3 animated dots)
class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8, top: 2),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            return _Dot(delay: i * 150, color: cs.onSurfaceVariant);
          }),
        ),
      ),
    );
  }
}

class _Dot extends StatefulWidget {
  const _Dot({required this.delay, required this.color});

  final int delay;
  final Color color;

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: 0.4,
      upperBound: 1.0,
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _c.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _c,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// Attach sheet grid item
class _AttachItem extends StatelessWidget {
  const _AttachItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: cs.primary),
            ),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: cs.onSurface)),
          ],
        ),
      ),
    );
  }
}
