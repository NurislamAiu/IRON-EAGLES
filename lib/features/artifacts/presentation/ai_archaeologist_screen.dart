import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import '../../../core/services/ai_service.dart';
import '../../../core/services/ai_chat_service.dart';
import '../../auth/provider/auth_provider.dart';

class AiArchaeologistScreen extends StatefulWidget {
  const AiArchaeologistScreen({super.key});

  @override
  State<AiArchaeologistScreen> createState() => _AiArchaeologistScreenState();
}

class _AiArchaeologistScreenState extends State<AiArchaeologistScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AiService _aiService = AiService();
  final AiChatService _chatService = AiChatService();
  final FlutterTts _flutterTts = FlutterTts();
  
  List<Map<String, String>> _messages = [];
  bool _isTyping = false;
  bool _isSpeaking = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initTts();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final user = context.read<AuthProviders>().user;
    if (user != null && user.email != null) {
      final history = await _chatService.loadChatHistory(user.email!);
      if (mounted) {
        setState(() {
          _messages = history.isEmpty 
            ? [{'role': 'ai', 'text': 'Здравствуйте! Я ваш ИИ-археолог. Задайте мне любой вопрос об истории, артефактах или раскопках. Чем я могу помочь вам сегодня?'}]
            : history;
          _isLoading = false;
        });
        _scrollToBottom();
      }
    } else {
      setState(() {
        _messages = [{'role': 'ai', 'text': 'Здравствуйте! Я ваш ИИ-археолог. Как гость, ваша история не будет сохранена. Пожалуйста, войдите, чтобы сохранять чаты.'}];
        _isLoading = false;
      });
    }
  }

  void _initTts() {
    _flutterTts.setLanguage("ru-RU");
    _flutterTts.setPitch(1.0);
    _flutterTts.setSpeechRate(0.5);
    _flutterTts.setStartHandler(() => setState(() => _isSpeaking = true));
    _flutterTts.setCompletionHandler(() => setState(() => _isSpeaking = false));
    _flutterTts.setCancelHandler(() => setState(() => _isSpeaking = false));
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
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

  Future<void> _speak(String text) async {
    await _flutterTts.stop();
    if (text.isNotEmpty) await _flutterTts.speak(text);
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final user = context.read<AuthProviders>().user;
    final email = user?.email;

    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _isTyping = true;
    });

    if (email != null) _chatService.saveMessage(email, 'user', text);
    _messageController.clear();
    _scrollToBottom();

    final response = await _aiService.getResponse(text);
    if (!mounted) return;

    setState(() {
      _isTyping = false;
      _messages.add({'role': 'ai', 'text': response});
    });

    if (email != null) _chatService.saveMessage(email, 'ai', response);
    _scrollToBottom();
    _speak(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Background Image with Blur
          Positioned.fill(
            child: Image.asset('assets/images/museum_bg.jpg', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(0.8), Colors.black.withOpacity(0.95)],
                ),
              ),
            ),
          ),

          // 2. Chat UI
          Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: _isLoading 
                  ? const Center(child: CircularProgressIndicator(color: Colors.orangeAccent))
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      itemCount: _messages.length,
                      itemBuilder: (context, i) => _buildMessageBubble(_messages[i]),
                    ),
              ),
              if (_isTyping) _buildTypingIndicator(),
              _buildInputArea(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AppBar(
          backgroundColor: Colors.white.withOpacity(0.05),
          elevation: 0,
          centerTitle: true,
          title: const Column(
            children: [
              Text("ИИ Археолог", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              Text("Online Assistant", style: TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.w500)),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            if (_isSpeaking)
              IconButton(
                icon: const Icon(Icons.stop_circle_outlined, color: Colors.redAccent, size: 26),
                onPressed: () => _flutterTts.stop(),
              ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white54),
              onPressed: () => _showClearDialog(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, String> msg) {
    final bool isAi = msg['role'] == 'ai';
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: isAi ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isAi) _buildAvatar(Icons.auto_awesome, Colors.orangeAccent),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: isAi ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isAi ? Colors.white.withOpacity(0.08) : null,
                    gradient: isAi ? null : const LinearGradient(colors: [Colors.orange, Colors.deepOrangeAccent]),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isAi ? 0 : 20),
                      bottomRight: Radius.circular(isAi ? 20 : 0),
                    ),
                    border: isAi ? Border.all(color: Colors.white.withOpacity(0.1)) : null,
                    boxShadow: isAi ? [] : [BoxShadow(color: Colors.orangeAccent.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))],
                  ),
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: isAi ? ImageFilter.blur(sigmaX: 5, sigmaY: 5) : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                      child: Text(
                        msg['text']!,
                        style: TextStyle(color: isAi ? Colors.white.withOpacity(0.9) : Colors.black, fontSize: 15, height: 1.4, fontWeight: isAi ? FontWeight.normal : FontWeight.w500),
                      ),
                    ),
                  ),
                ),
                if (isAi)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => _speak(msg['text']!),
                          child: Icon(Icons.volume_up_rounded, size: 16, color: Colors.white.withOpacity(0.4)),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Спасибо! Ответ ИИ будет проверен.")),
                            );
                          },
                          child: Icon(Icons.flag_outlined, size: 16, color: Colors.white.withOpacity(0.4)),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          if (!isAi) _buildAvatar(Icons.person, Colors.white24),
        ],
      ),
    );
  }

  Widget _buildAvatar(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle, border: Border.all(color: color.withOpacity(0.2))),
      child: Icon(icon, size: 18, color: color),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 15),
      child: Row(
        children: [
          _buildAvatar(Icons.auto_awesome, Colors.orangeAccent),
          const SizedBox(width: 10),
          const Text("Археолог печатает...", style: TextStyle(color: Colors.white38, fontSize: 12, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: "Спросите об истории...",
                      hintStyle: TextStyle(color: Colors.white24),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _sendMessage,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(color: Colors.orangeAccent, shape: BoxShape.circle),
                  child: const Icon(Icons.send_rounded, color: Colors.black, size: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff1a1412),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Очистить чат?", style: TextStyle(color: Colors.white)),
        content: const Text("Вся история общения с ИИ будет удалена.", style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Отмена")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearChat();
            }, 
            child: const Text("Удалить", style: TextStyle(color: Colors.redAccent))
          ),
        ],
      ),
    );
  }

  Future<void> _clearChat() async {
    final user = context.read<AuthProviders>().user;
    if (user?.email != null) {
      await _chatService.clearHistory(user!.email!);
      setState(() {
        _messages = [{'role': 'ai', 'text': 'История очищена. О чем хотите поговорить?'}];
      });
    }
  }
}
