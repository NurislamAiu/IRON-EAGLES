import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/foundation.dart';

class AiService {
  // 🔥 API КЛЮЧ ПОДКЛЮЧЕН
  static const String _apiKey = 'AIzaSyDwFzjrX6bSwlhuUMVnebISrbq-BeexdLM';

  late final GenerativeModel _model;
  late final ChatSession _chat;

  AiService() {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash', // Используем стабильную версию
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 1024,
      ),
      systemInstruction: Content.system(
        'Ты — профессиональный археолог и эксперт по истории Казахстана и Центральной Азии. '
        'Твоя задача — отвечать на вопросы пользователей о древних артефактах, раскопках и культуре саков, сарматов и других народов. '
        'Отвечай вежливо, информативно и на языке пользователя (преимущественно на русском). '
        'Если вопрос не касается истории или археологии, старайся мягко вернуть разговор к теме музея.'
      ),
    );
    _chat = _model.startChat();
  }

  Future<String> getResponse(String message) async {
    // Проверка на пустой ключ (на всякий случай)
    if (_apiKey.isEmpty || _apiKey.startsWith('ВАШ_')) {
      return 'Ошибка: API ключ не настроен. Пожалуйста, добавьте ключ в AiService.';
    }

    try {
      final response = await _chat.sendMessage(Content.text(message));
      return response.text ?? 'Извините, я не смог сформировать ответ.';
    } catch (e) {
      debugPrint('AI Error: $e');
      return 'Произошла ошибка при подключении к ИИ. Убедитесь, что есть интернет. Ошибка: $e';
    }
  }
}
