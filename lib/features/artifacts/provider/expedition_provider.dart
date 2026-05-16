import 'package:flutter/material.dart';
import '../domain/expedition_model.dart';
import '../domain/chat_message_model.dart';
import '../domain/expedition_invite_model.dart';
import '../data/expedition_service.dart';
import '../data/invite_service.dart';

class ExpeditionProvider extends ChangeNotifier {
  final ExpeditionService _service = ExpeditionService();
  final InviteService _inviteService = InviteService();
  
  List<Expedition> _myExpeditions = [];
  bool _isLoading = true;

  List<Expedition> get myExpeditions => _myExpeditions;
  bool get isLoading => _isLoading;

  ExpeditionProvider() {
    fetchExpeditions();
  }

  Future<void> fetchExpeditions() async {
    try {
      _isLoading = true;
      notifyListeners();
      _myExpeditions = await _service.getExpeditions();
    } catch (e) {
      debugPrint("Error fetching expeditions: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createExpedition({
    required String name,
    required String description,
    required String leaderEmail,
  }) async {
    final newExpedition = Expedition(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      leaderEmail: leaderEmail.toLowerCase(),
      memberEmails: [leaderEmail.toLowerCase()],
      likes: [],
      startDate: DateTime.now(),
    );

    try {
      await _service.createExpedition(newExpedition);
      _myExpeditions.insert(0, newExpedition);
      notifyListeners();
    } catch (e) {
      debugPrint("Error creating expedition: $e");
      rethrow;
    }
  }

  Future<void> updateExpedition(Expedition expedition) async {
    try {
      await _service.updateExpedition(expedition);
      final index = _myExpeditions.indexWhere((e) => e.id == expedition.id);
      if (index != -1) {
        _myExpeditions[index] = expedition;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error updating expedition: $e");
      rethrow;
    }
  }

  Future<void> deleteExpedition(String id) async {
    try {
      await _service.deleteExpedition(id);
      _myExpeditions.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint("Error deleting expedition: $e");
      rethrow;
    }
  }

  // --- INVITE LOGIC ---

  Future<void> sendInvite(Expedition expedition, String inviteeEmail, String inviterEmail) async {
    final invite = ExpeditionInvite(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      expeditionId: expedition.id,
      expeditionName: expedition.name,
      inviterEmail: inviterEmail.toLowerCase(),
      inviteeEmail: inviteeEmail.toLowerCase(),
      createdAt: DateTime.now(),
    );
    
    try {
      await _inviteService.sendInvite(invite);
      debugPrint("✅ Invite sent to ${invite.inviteeEmail}");
    } catch (e) {
      debugPrint("❌ Error sending invite: $e");
    }
  }

  Stream<List<ExpeditionInvite>> streamMyInvites(String email) {
    return _inviteService.streamMyInvites(email.toLowerCase());
  }

  Future<void> acceptInvite(ExpeditionInvite invite) async {
    try {
      final inviteeLower = invite.inviteeEmail.toLowerCase();
      // 1. Update invite status
      await _inviteService.updateInviteStatus(invite.id, 'accepted');
      
      // 2. Add member to expedition
      final expeditions = await _service.getExpeditions();
      final expIndex = expeditions.indexWhere((e) => e.id == invite.expeditionId);
      
      if (expIndex != -1) {
        final exp = expeditions[expIndex];
        if (!exp.memberEmails.contains(inviteeLower)) {
          final updatedMembers = [...exp.memberEmails, inviteeLower];
          final updatedExp = exp.copyWith(memberEmails: updatedMembers);
          await _service.updateExpedition(updatedExp);
        }
      }
      
      // 3. Refresh list
      await fetchExpeditions();
    } catch (e) {
      debugPrint("Error accepting invite: $e");
    }
  }

  Future<void> declineInvite(String inviteId) async {
    try {
      await _inviteService.updateInviteStatus(inviteId, 'declined');
    } catch (e) {
      debugPrint("Error declining invite: $e");
    }
  }

  // --- LIKES ---

  Future<void> toggleLike(String expeditionId, String userEmail) async {
    final emailLower = userEmail.toLowerCase();
    final index = _myExpeditions.indexWhere((e) => e.id == expeditionId);
    if (index == -1) return;

    final currentLikes = List<String>.from(_myExpeditions[index].likes);
    if (currentLikes.contains(emailLower)) {
      currentLikes.remove(emailLower);
    } else {
      currentLikes.add(emailLower);
    }

    _myExpeditions[index] = _myExpeditions[index].copyWith(likes: currentLikes);
    notifyListeners();

    try {
      await _service.toggleLike(expeditionId, emailLower);
    } catch (e) {
      debugPrint("Error toggling like: $e");
    }
  }

  // --- CHAT LOGIC ---
  Stream<List<ChatMessage>> streamMessages(String expeditionId) {
    return _service.streamMessages(expeditionId);
  }

  Future<void> sendMessage({
    required String expeditionId,
    required String text,
    required String senderEmail,
  }) async {
    final newMessage = ChatMessage(
      id: '', 
      expeditionId: expeditionId,
      senderEmail: senderEmail.toLowerCase(),
      text: text,
      timestamp: DateTime.now(),
    );
    
    try {
      await _service.sendMessage(newMessage);
    } catch (e) {
      debugPrint("Error sending message: $e");
    }
  }

  // --- TYPING STATUS ---

  Future<void> setTypingStatus(String expeditionId, String email, bool isTyping) async {
    try {
      await _service.setTypingStatus(expeditionId, email.toLowerCase(), isTyping);
    } catch (e) {
      debugPrint("Error setting typing status: $e");
    }
  }

  Stream<List<String>> streamTypingUsers(String expeditionId) {
    return _service.streamTypingUsers(expeditionId);
  }
}
