import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../foundation/colors.dart';
import '../../../foundation/spacing.dart';
import '../../../foundation/radius.dart';
import '../../../foundation/typography.dart';
import '../../../foundation/shadows.dart';
import '../../../foundation/motion.dart';
import '../../../widgets/avatar/royal_avatar.dart';
import '../../../widgets/buttons/royal_icon_button.dart';

import '../../../models/academic_message.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  bool _showScrollButton = false;
  AcademicMessage? _replyingTo;
  final bool _isTyping = false;

  // Mock data — remplacer par Firestore
  final List<AcademicMessage> _messages = [
    AcademicMessage(
      id: '1',
      senderId: 'teacher_1',
      senderName: 'M. Ben Salah',
      role: AcademicSenderRole.teacher,
      type: AcademicMessageType.announcement,
      status: AcademicMessageStatus.read,
      message: 'Contrôle de mathématiques vendredi 8h00. Révisez les chapitres 3 et 4.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      mine: false,
      avatar: 'https://i.pravatar.cc/150?img=11',
    ),
    AcademicMessage(
      id: '2',
      senderId: 'teacher_1',
      senderName: 'M. Ben Salah',
      role: AcademicSenderRole.teacher,
      type: AcademicMessageType.homework,
      status: AcademicMessageStatus.read,
      message: 'Devoir : Exercices 12 à 18, page 45. À rendre pour jeudi.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 44)),
      mine: false,
      avatar: 'https://i.pravatar.cc/150?img=11',
    ),
    AcademicMessage(
      id: '3',
      senderId: 'me',
      senderName: 'Ahmed',
      role: AcademicSenderRole.student,
      type: AcademicMessageType.text,
      status: AcademicMessageStatus.read,
      message: 'D\'accord, merci professeur ! Je vais commencer ce soir.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 40)),
      mine: true,
    ),
    AcademicMessage(
      id: '4',
      senderId: 'teacher_1',
      senderName: 'M. Ben Salah',
      role: AcademicSenderRole.teacher,
      type: AcademicMessageType.pdf,
      status: AcademicMessageStatus.read,
      message: 'Cours_Trigonometrie.pdf',
      createdAt: DateTime.now().subtract(const Duration(minutes: 35)),
      mine: false,
      avatar: 'https://i.pravatar.cc/150?img=11',
      attachment: '18 pages • 3.4 MB',
    ),
    AcademicMessage(
      id: '5',
      senderId: 'teacher_1',
      senderName: 'M. Ben Salah',
      role: AcademicSenderRole.teacher,
      type: AcademicMessageType.quiz,
      status: AcademicMessageStatus.read,
      message: 'Quiz d\'entraînement : 15 questions • 10 minutes',
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      mine: false,
      avatar: 'https://i.pravatar.cc/150?img=11',
    ),
    AcademicMessage(
      id: '6',
      senderId: 'me',
      senderName: 'Ahmed',
      role: AcademicSenderRole.student,
      type: AcademicMessageType.text,
      status: AcademicMessageStatus.delivered,
      message: 'J\'ai terminé le quiz, j\'ai eu 13/15 ! 🎉',
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      mine: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    final show = _scrollController.offset > 500;
    if (show != _showScrollButton) {
      setState(() => _showScrollButton = show);
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      0,
      duration: RoyalMotion.medium,
      curve: RoyalMotion.standard,
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.insert(
        0,
        AcademicMessage(
          id: 'new_${DateTime.now().millisecondsSinceEpoch}',
          senderId: 'me',
          senderName: 'Ahmed',
          role: AcademicSenderRole.student,
          type: AcademicMessageType.text,
          status: AcademicMessageStatus.sending,
          message: text,
          createdAt: DateTime.now(),
          mine: true,
        ),
      );
      _messageController.clear();
      _replyingTo = null;
    });

    // Simuler envoi
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.first = _messages.first.copyWith(
          status: AcademicMessageStatus.sent,
        );
      });
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _messages.first = _messages.first.copyWith(
            status: AcademicMessageStatus.read,
          );
        });
      });
    });
  }

  void _showContextMenu(AcademicMessage message, Offset position) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _MessageContextMenu(
        message: message,
        onReply: () {
          setState(() => _replyingTo = message);
          Navigator.pop(context);
          _focusNode.requestFocus();
        },
        onCopy: () {
          // Clipboard.setData(ClipboardData(text: message.message));
          Navigator.pop(context);
        },
        onDelete: () {
          setState(() => _messages.removeWhere((m) => m.id == message.id));
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RoyalColors.background,
      body: Stack(
        children: [
          // Background gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xffF9FBFF),
                    Color(0xffF3F7FD),
                    Color(0xffEEF4FC),
                  ],
                ),
              ),
            ),
          ),
          // Decorative blobs
          Positioned(
            top: -120,
            right: -60,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: RoyalColors.royalBlue500.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            left: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: RoyalColors.gold500.withOpacity(0.05),
              ),
            ),
          ),
          // Main content
          SafeArea(
            child: Column(
              children: [
                // Header
                _ChatHeader(
                  name: 'M. Ben Salah',
                  subject: 'Mathématiques',
                  avatar: 'https://i.pravatar.cc/150?img=11',
                  online: true,
                  rating: 4.8,
                  onBack: () => Get.back(),
                  onCall: () {},
                  onVideo: () {},
                ),

                // Academic Context Bar
                _AcademicContextBar(
                  subject: 'Mathématiques',
                  teacher: 'M. Ben Salah',
                  average: '15.84',
                  nextHomework: 'Jeudi',
                ),

                // Messages
                Expanded(
                  child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      padding: const EdgeInsets.symmetric(
                        horizontal: RoyalSpacing.sm,
                        vertical: RoyalSpacing.lg,
                      ),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return _buildMessage(message);
                      },
                    ),
                  ),
                ),

                // Typing indicator
                if (_isTyping)
                  _TypingIndicator(),

                // Reply preview
                if (_replyingTo != null)
                  _ReplyPreview(
                    message: _replyingTo!,
                    onCancel: () => setState(() => _replyingTo = null),
                  ),

                // Input
                _ChatInput(
                  controller: _messageController,
                  focusNode: _focusNode,
                  onSend: _sendMessage,
                  onAttachment: () => _showAttachmentSheet(),
                  onVoice: () {},
                ),
              ],
            ),
          ),

          // Scroll to bottom button
          if (_showScrollButton)
            Positioned(
              right: 20,
              bottom: 100,
              child: FloatingActionButton.small(
                onPressed: _scrollToBottom,
                backgroundColor: Colors.white,
                elevation: 2,
                child: const Icon(Icons.keyboard_arrow_down),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessage(AcademicMessage message) {
    switch (message.type) {
      case AcademicMessageType.text:
        return _TextMessage(
          message: message,
          onReply: () => setState(() => _replyingTo = message),
          onLongPress: (pos) => _showContextMenu(message, pos),
        );
      case AcademicMessageType.pdf:
        return _PdfMessage(
          message: message,
          onReply: () => setState(() => _replyingTo = message),
          onLongPress: (pos) => _showContextMenu(message, pos),
        );
      case AcademicMessageType.quiz:
        return _QuizMessage(
          message: message,
          onReply: () => setState(() => _replyingTo = message),
          onLongPress: (pos) => _showContextMenu(message, pos),
        );
      case AcademicMessageType.homework:
        return _HomeworkMessage(
          message: message,
          onReply: () => setState(() => _replyingTo = message),
          onLongPress: (pos) => _showContextMenu(message, pos),
        );
      case AcademicMessageType.announcement:
        return _AnnouncementMessage(
          message: message,
          onReply: () => setState(() => _replyingTo = message),
          onLongPress: (pos) => _showContextMenu(message, pos),
        );
      default:
        return _TextMessage(
          message: message,
          onReply: () => setState(() => _replyingTo = message),
          onLongPress: (pos) => _showContextMenu(message, pos),
        );
    }
  }

  void _showAttachmentSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _AttachmentSheet(
        onSelect: (type) {
          Navigator.pop(context);
          // Handle attachment type
        },
      ),
    );
  }
}

// ==========================================================
// CHAT HEADER
// ==========================================================

class _ChatHeader extends StatelessWidget {
  final String name;
  final String subject;
  final String avatar;
  final bool online;
  final double rating;
  final VoidCallback onBack;
  final VoidCallback onCall;
  final VoidCallback onVideo;

  const _ChatHeader({
    required this.name,
    required this.subject,
    required this.avatar,
    required this.online,
    required this.rating,
    required this.onBack,
    required this.onCall,
    required this.onVideo,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: RoyalSpacing.lg,
            vertical: RoyalSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.85),
            border: Border(
              bottom: BorderSide(color: RoyalColors.border),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                RoyalIconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onPressed: onBack,
                  size: 40,
                ),
                const SizedBox(width: 8),
                RoyalAvatar(
                  image: avatar,
                  size: 48,
                  online: online,
                  role: RoyalUserRole.teacher,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: RoyalTypography.titleLarge,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            subject,
                            style: RoyalTypography.bodySmall.copyWith(
                              color: RoyalColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: online
                                  ? RoyalColors.success
                                  : RoyalColors.textMuted,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            online ? 'En ligne' : 'Hors ligne',
                            style: RoyalTypography.caption.copyWith(
                              color: RoyalColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    RoyalIconButton(
                      icon: Icons.call_rounded,
                      onPressed: onCall,
                      size: 40,
                    ),
                    const SizedBox(width: 4),
                    RoyalIconButton(
                      icon: Icons.videocam_rounded,
                      onPressed: onVideo,
                      size: 40,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================================
// ACADEMIC CONTEXT BAR
// ==========================================================

class _AcademicContextBar extends StatelessWidget {
  final String subject;
  final String teacher;
  final String average;
  final String nextHomework;

  const _AcademicContextBar({
    required this.subject,
    required this.teacher,
    required this.average,
    required this.nextHomework,
  });

  Widget _chip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: RoyalRadius.full,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            text,
            style: RoyalTypography.labelMedium.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: RoyalSpacing.lg),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _chip(Icons.school_rounded, subject, RoyalColors.royalBlue600),
          const SizedBox(width: 10),
          _chip(Icons.person_rounded, teacher, RoyalColors.gold600),
          const SizedBox(width: 10),
          _chip(Icons.auto_graph_rounded, average, RoyalColors.success),
          const SizedBox(width: 10),
          _chip(Icons.assignment_rounded, nextHomework, Colors.orange),
        ],
      ),
    );
  }
}

// ==========================================================
// MESSAGE WIDGETS
// ==========================================================

class _BaseMessage extends StatelessWidget {
  final AcademicMessage message;
  final Widget child;
  final VoidCallback onReply;
  final Function(Offset) onLongPress;

  const _BaseMessage({
    required this.message,
    required this.child,
    required this.onReply,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final mine = message.mine;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            mine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!mine) ...[
            RoyalAvatar(
              image: message.avatar ?? '',
              size: 36,
              role: message.role == AcademicSenderRole.teacher
                  ? RoyalUserRole.teacher
                  : RoyalUserRole.student,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity != null &&
                    details.primaryVelocity! > 100) {
                  onReply();
                }
              },
              onLongPressStart: (details) =>
                  onLongPress(details.globalPosition),
              child: AnimatedContainer(
                duration: RoyalMotion.normal,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: mine
                      ? RoyalColors.royalBlue600
                      : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: Radius.circular(mine ? 20 : 4),
                    bottomRight: Radius.circular(mine ? 4 : 20),
                  ),
                  boxShadow: mine ? null : RoyalShadows.soft,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!mine)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          message.senderName,
                          style: RoyalTypography.labelMedium.copyWith(
                            color: mine
                                ? Colors.white70
                                : RoyalColors.textSecondary,
                          ),
                        ),
                      ),
                    child,
                    const SizedBox(height: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(message.createdAt),
                          style: TextStyle(
                            fontSize: 11,
                            color: mine ? Colors.white60 : RoyalColors.textMuted,
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (mine) _MessageStatusIcon(status: message.status),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class _TextMessage extends StatelessWidget {
  final AcademicMessage message;
  final VoidCallback onReply;
  final Function(Offset) onLongPress;

  const _TextMessage({
    required this.message,
    required this.onReply,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseMessage(
      message: message,
      onReply: onReply,
      onLongPress: onLongPress,
      child: Text(
        message.message,
        style: TextStyle(
          fontSize: 15,
          height: 1.5,
          color: message.mine ? Colors.white : RoyalColors.textPrimary,
        ),
      ),
    );
  }
}

class _PdfMessage extends StatelessWidget {
  final AcademicMessage message;
  final VoidCallback onReply;
  final Function(Offset) onLongPress;

  const _PdfMessage({
    required this.message,
    required this.onReply,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseMessage(
      message: message,
      onReply: onReply,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.08),
          borderRadius: RoyalRadius.md,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: RoyalRadius.md,
              ),
              child: const Icon(Icons.picture_as_pdf, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: RoyalTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.attachment ?? 'PDF',
                    style: RoyalTypography.bodySmall.copyWith(
                      color: RoyalColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: RoyalRadius.md,
                ),
              ),
              child: const Text('Ouvrir'),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizMessage extends StatelessWidget {
  final AcademicMessage message;
  final VoidCallback onReply;
  final Function(Offset) onLongPress;

  const _QuizMessage({
    required this.message,
    required this.onReply,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseMessage(
      message: message,
      onReply: onReply,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: RoyalColors.gold500.withOpacity(0.08),
          borderRadius: RoyalRadius.md,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: RoyalColors.gold500,
                borderRadius: RoyalRadius.md,
              ),
              child: const Icon(Icons.quiz, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quiz',
                    style: RoyalTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.message,
                    style: RoyalTypography.bodySmall.copyWith(
                      color: RoyalColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: RoyalColors.gold500,
                shape: RoundedRectangleBorder(
                  borderRadius: RoyalRadius.md,
                ),
              ),
              child: const Text('Commencer'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeworkMessage extends StatelessWidget {
  final AcademicMessage message;
  final VoidCallback onReply;
  final Function(Offset) onLongPress;

  const _HomeworkMessage({
    required this.message,
    required this.onReply,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseMessage(
      message: message,
      onReply: onReply,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.orange.withOpacity(0.08),
          borderRadius: RoyalRadius.md,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: RoyalRadius.md,
              ),
              child: const Icon(Icons.assignment, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Devoir',
                    style: RoyalTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.message,
                    style: RoyalTypography.bodySmall.copyWith(
                      color: RoyalColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: RoyalRadius.md,
                ),
              ),
              child: const Text('Détails'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnnouncementMessage extends StatelessWidget {
  final AcademicMessage message;
  final VoidCallback onReply;
  final Function(Offset) onLongPress;

  const _AnnouncementMessage({
    required this.message,
    required this.onReply,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return _BaseMessage(
      message: message,
      onReply: onReply,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: RoyalColors.royalBlue500.withOpacity(0.08),
          borderRadius: RoyalRadius.md,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: RoyalColors.royalBlue500,
                borderRadius: RoyalRadius.md,
              ),
              child: const Icon(Icons.campaign, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Annonce',
                    style: RoyalTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.message,
                    style: RoyalTypography.bodySmall.copyWith(
                      color: RoyalColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: RoyalColors.royalBlue500,
                shape: RoundedRectangleBorder(
                  borderRadius: RoyalRadius.md,
                ),
              ),
              child: const Text('Lire'),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================================
// MESSAGE STATUS ICON
// ==========================================================

class _MessageStatusIcon extends StatelessWidget {
  final AcademicMessageStatus status;

  const _MessageStatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case AcademicMessageStatus.sending:
        return const SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white60,
          ),
        );
      case AcademicMessageStatus.sent:
        return const Icon(
          Icons.check_rounded,
          size: 14,
          color: Colors.white60,
        );
      case AcademicMessageStatus.delivered:
        return const Icon(
          Icons.done_all_rounded,
          size: 14,
          color: Colors.white60,
        );
      case AcademicMessageStatus.read:
        return const Icon(
          Icons.done_all_rounded,
          size: 14,
          color: Colors.blue,
        );
      default:
        return const Icon(
          Icons.check_rounded,
          size: 14,
          color: Colors.white60,
        );
    }
  }
}

// ==========================================================
// TYPING INDICATOR
// ==========================================================

class _TypingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: RoyalSpacing.sm,
        vertical: RoyalSpacing.xs,
      ),
      child: Row(
        children: [
          const SizedBox(width: 44), // Avatar placeholder
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: RoyalShadows.soft,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _TypingDot(delay: 0),
                _TypingDot(delay: 150),
                _TypingDot(delay: 300),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingDot extends StatelessWidget {
  final int delay;

  const _TypingDot({required this.delay});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.3, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: RoyalColors.textMuted.withOpacity(value),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}

// ==========================================================
// REPLY PREVIEW
// ==========================================================

class _ReplyPreview extends StatelessWidget {
  final AcademicMessage message;
  final VoidCallback onCancel;

  const _ReplyPreview({
    required this.message,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: RoyalSpacing.md,
        vertical: RoyalSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: RoyalColors.border),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: RoyalColors.royalBlue500,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Répondre à ${message.senderName}',
                  style: RoyalTypography.labelMedium.copyWith(
                    color: RoyalColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message.message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: RoyalTypography.bodySmall.copyWith(
                    color: RoyalColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, size: 20),
            onPressed: onCancel,
            splashRadius: 20,
          ),
        ],
      ),
    );
  }
}

// ==========================================================
// CHAT INPUT
// ==========================================================

class _ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSend;
  final VoidCallback onAttachment;
  final VoidCallback onVoice;

  const _ChatInput({
    required this.controller,
    required this.focusNode,
    required this.onSend,
    required this.onAttachment,
    required this.onVoice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        RoyalSpacing.sm,
        RoyalSpacing.xs,
        RoyalSpacing.sm,
        RoyalSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: RoyalColors.border),
        ),
        boxShadow: RoyalShadows.soft,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Attachment button
            IconButton(
              icon: const Icon(Icons.attach_file_rounded),
              onPressed: onAttachment,
              splashRadius: 20,
            ),

            // Voice button (or text field)
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: 'Écrire un message...',
                  hintStyle: RoyalTypography.bodyMedium.copyWith(
                    color: RoyalColors.textMuted,
                  ),
                  filled: true,
                  fillColor: RoyalColors.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  isDense: true,
                ),
                maxLines: null,
                minLines: 1,
                onSubmitted: (_) => onSend(),
              ),
            ),

            // Send button (or voice button if empty)
            if (controller.text.trim().isNotEmpty)
              IconButton.filled(
                icon: const Icon(Icons.send_rounded),
                onPressed: onSend,
                style: IconButton.styleFrom(
                  backgroundColor: RoyalColors.royalBlue500,
                  foregroundColor: Colors.white,
                ),
              )
            else
              IconButton(
                icon: const Icon(Icons.mic_rounded),
                onPressed: onVoice,
                splashRadius: 20,
              ),
          ],
        ),
      ),
    );
  }
}

// ==========================================================
// ATTACHMENT SHEET
// ==========================================================

class _AttachmentSheet extends StatelessWidget {
  final Function(String) onSelect;

  const _AttachmentSheet({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(RoyalSpacing.md),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: RoyalColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Joindre un fichier',
            style: RoyalTypography.titleMedium,
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _AttachmentItem(
                icon: Icons.image_rounded,
                label: 'Image',
                color: Colors.blue,
                onTap: () => onSelect('image'),
              ),
              _AttachmentItem(
                icon: Icons.picture_as_pdf_rounded,
                label: 'PDF',
                color: Colors.red,
                onTap: () => onSelect('pdf'),
              ),
              _AttachmentItem(
                icon: Icons.folder_rounded,
                label: 'Document',
                color: Colors.orange,
                onTap: () => onSelect('document'),
              ),
              _AttachmentItem(
                icon: Icons.mic_rounded,
                label: 'Audio',
                color: Colors.green,
                onTap: () => onSelect('audio'),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _AttachmentItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AttachmentItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 80,
        height: 80,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 6),
            Text(
              label,
              style: RoyalTypography.labelSmall.copyWith(
                color: RoyalColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================================
// MESSAGE CONTEXT MENU
// ==========================================================

class _MessageContextMenu extends StatelessWidget {
  final AcademicMessage message;
  final VoidCallback onReply;
  final VoidCallback onCopy;
  final VoidCallback onDelete;

  const _MessageContextMenu({
    required this.message,
    required this.onReply,
    required this.onCopy,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(RoyalSpacing.md),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: RoyalColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          _ContextMenuItem(
            icon: Icons.reply_rounded,
            label: 'Répondre',
            onTap: onReply,
          ),
          _ContextMenuItem(
            icon: Icons.copy_rounded,
            label: 'Copier',
            onTap: onCopy,
          ),
          if (message.mine)
            _ContextMenuItem(
              icon: Icons.delete_rounded,
              label: 'Supprimer',
              color: Colors.red,
              onTap: onDelete,
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _ContextMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ContextMenuItem({
    required this.icon,
    required this.label,
    this.color = RoyalColors.textPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: RoyalTypography.bodyMedium.copyWith(color: color),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: RoyalRadius.md,
      ),
    );
  }
}