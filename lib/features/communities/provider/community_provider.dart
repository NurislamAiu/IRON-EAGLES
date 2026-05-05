import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/community_model.dart';

class CommunityProvider extends ChangeNotifier {
  List<Community> _communities = [];
  bool _isLoading = true;

  List<Community> get communities => _communities;
  bool get isLoading => _isLoading;

  CommunityProvider() {
    _loadCommunities();
  }

  List<Community> searchCommunities(String query) {
    if (query.isEmpty) return _communities;
    return _communities
        .where((c) =>
            c.name.toLowerCase().contains(query.toLowerCase()) ||
            c.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<Community> getMyCommunities(String userEmail) {
    if (userEmail.isEmpty) return [];
    return _communities.where((c) => c.members.contains(userEmail)).toList();
  }

  Future<void> createCommunity({
    required String name,
    required String description,
    required String creatorEmail,
    String imageUrl = '',
  }) async {
    final newCommunity = Community(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: description,
      creatorEmail: creatorEmail,
      imageUrl: imageUrl,
      members: [creatorEmail], // creator is automatically a member
      createdAt: DateTime.now(),
    );

    _communities.insert(0, newCommunity);
    notifyListeners();
    await _saveCommunities();
  }

  Future<void> joinCommunity(String communityId, String userEmail) async {
    final index = _communities.indexWhere((c) => c.id == communityId);
    if (index != -1) {
      final members = List<String>.from(_communities[index].members);
      if (!members.contains(userEmail)) {
        members.add(userEmail);
        _communities[index] = _communities[index].copyWith(members: members);
        notifyListeners();
        await _saveCommunities();
      }
    }
  }

  Future<void> leaveCommunity(String communityId, String userEmail) async {
    final index = _communities.indexWhere((c) => c.id == communityId);
    if (index != -1) {
      final members = List<String>.from(_communities[index].members);
      if (members.contains(userEmail)) {
        members.remove(userEmail);
        _communities[index] = _communities[index].copyWith(members: members);
        notifyListeners();
        await _saveCommunities();
      }
    }
  }

  Future<void> _saveCommunities() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(_communities.map((c) => c.toMap()).toList());
      await prefs.setString('user_communities', encoded);
    } catch (e) {
      debugPrint("Error saving communities: $e");
    }
  }

  Future<void> _loadCommunities() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString('user_communities');
      if (data != null) {
        final List decoded = jsonDecode(data);
        _communities = decoded.map((item) => Community.fromMap(item)).toList();
      } else {
        // Add a mock community for demo
        _communities = [
          Community(
            id: 'demo-community-1',
            name: 'Древний Египет',
            description: 'Сообщество для обсуждения находок и секретов Древнего Египта.',
            creatorEmail: 'admin@gmail.com',
            imageUrl: 'https://images.unsplash.com/photo-1539650116574-8efeb43e2750?q=80&w=2070',
            members: ['admin@gmail.com'],
            createdAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
        ];
      }
    } catch (e) {
      debugPrint("Error loading communities: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
