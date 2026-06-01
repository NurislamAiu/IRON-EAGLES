import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../domain/expedition_model.dart';
import '../domain/chat_message_model.dart';
import '../provider/expedition_provider.dart';
import '../../auth/provider/auth_provider.dart';
import '../../auth/provider/ugc_provider.dart';
import '../../../core/localization/app_localizations.dart';

class ExpeditionChatScreen extends StatefulWidget {
  final Expedition expedition;

  const ExpeditionChatScreen({super.key, required this.expedition});

  @override
  State<ExpeditionChatScreen> createState() => _ExpeditionChatScreenState();
}

class _ExpeditionChatScreenState extends State<ExpeditionChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _typingTimer;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _messageController.removeListener(_onTextChanged);
    _typingTimer?.cancel();
    _setTyping(false);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (_messageController.text.trim().isNotEmpty) {
      if (!_isTyping) {
        _setTyping(true);
      }
      _typingTimer?.cancel();
      _typingTimer = Timer(const Duration(seconds: 3), () {
        _setTyping(false);
      });
    } else if (_isTyping) {
      _setTyping(false);
      _typingTimer?.cancel();
    }
  }

  void _setTyping(bool typing) {
    if (_isTyping == typing) return;
    _isTyping = typing;
    final myEmail = context.read<AuthProviders>().user?.email;
    if (myEmail != null) {
      context.read<ExpeditionProvider>().setTypingStatus(widget.expedition.id, myEmail, typing);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpeditionProvider>();
    final myEmail = context.read<AuthProviders>().user?.email ?? "";

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.expedition.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const Text("Чат команды", style: TextStyle(color: Colors.white54, fontSize: 12)),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff2c1e19), Color(0xff0f0c0a)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder<List<ChatMessage>>(
                    stream: provider.streamMessages(widget.expedition.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: Colors.orangeAccent));
                      }
                      
                      final ugc = context.watch<UgcProvider>();
                      final messages = (snapshot.data ?? [])
                          .where((m) => !ugc.isBlocked(m.senderEmail))
                          .toList();
                      
                      if (messages.isEmpty) {
                        return _buildEmptyChat();
                      }

                      _scrollToBottom();

                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(20),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          final isMe = msg.senderEmail == myEmail;
                          return _buildMessageBubble(msg, isMe);
                        },
                      );
                    },
                  ),
                ),
                
                // Real-time Typing Status
                StreamBuilder<List<String>>(
                  stream: provider.streamTypingUsers(widget.expedition.id),
                  builder: (context, snapshot) {
                    final typingUsers = (snapshot.data ?? [])
                        .where((email) => email != myEmail)
                        .toList();
                    
                    if (typingUsers.isNotEmpty) {
                      _scrollToBottom();
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.orangeAccent),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "${typingUsers.join(', ')} печатает...",
                              style: const TextStyle(color: Colors.orangeAccent, fontSize: 12, fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                _buildInputBar(myEmail),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChat() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 80, color: Colors.white10),
          SizedBox(height: 16),
          Text("Сообщений пока нет", textAlign: TextAlign.center, style: TextStyle(color: Colors.white24)),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: isMe ? null : () => _showChatActions(context, msg),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
          decoration: BoxDecoration(
            color: isMe ? Colors.orange.shade800.withOpacity(0.8) : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isMe ? 16 : 0),
              bottomRight: Radius.circular(isMe ? 0 : 16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMe)
                Text(msg.senderEmail, style: const TextStyle(color: Colors.orangeAccent, fontSize: 10, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(msg.text, style: const TextStyle(color: Colors.white, fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }

  void _showChatActions(BuildContext context, ChatMessage msg) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff2c1e19),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.report, color: Colors.white70),
            title: Text(S.of(context).report, style: const TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(ctx);
              context.read<UgcProvider>().reportContent(
                authorEmail: msg.senderEmail,
                reason: "Chat Report",
                contentType: "CHAT",
                contentId: msg.id,
                contentText: msg.text,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(S.of(context).contentReported)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.block, color: Colors.redAccent),
            title: Text(S.of(context).blockUser, style: const TextStyle(color: Colors.redAccent)),
            onTap: () {
              Navigator.pop(ctx);
              context.read<UgcProvider>().blockUser(msg.senderEmail);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(S.of(context).userBlocked)),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInputBar(String myEmail) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Написать команде...",
                hintStyle: const TextStyle(color: Colors.white24),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.orangeAccent),
            onPressed: () {
              if (_messageController.text.trim().isNotEmpty) {
                context.read<ExpeditionProvider>().sendMessage(
                  expeditionId: widget.expedition.id,
                  text: _messageController.text.trim(),
                  senderEmail: myEmail,
                );
                _messageController.clear();
                _setTyping(false);
              }
            },
          ),
        ],
      ),
    );
  }
}
