import 'package:flutter/foundation.dart';
import '../domain/community_model.dart';
import '../data/community_service.dart';

class CommunityProvider extends ChangeNotifier {
  final CommunityService _service = CommunityService();
  List<Community> _communities = [];
  bool _isLoading = true;

  List<Community> get communities => _communities;
  bool get isLoading => _isLoading;

  CommunityProvider() {
    fetchCommunities();
  }

  Future<void> fetchCommunities() async {
    try {
      _isLoading = true;
      notifyListeners();
      _communities = await _service.getCommunities();
    } catch (e) {
      debugPrint("Error fetching communities: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
      members: [creatorEmail],
      likes: [],
      createdAt: DateTime.now(),
    );

    try {
      await _service.createCommunity(newCommunity);
      _communities.insert(0, newCommunity);
      notifyListeners();
    } catch (e) {
      debugPrint("Error creating community: $e");
      rethrow;
    }
  }

  Future<void> updateCommunity(Community community) async {
    try {
      await _service.updateCommunity(community);
      final index = _communities.indexWhere((c) => c.id == community.id);
      if (index != -1) {
        _communities[index] = community;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error updating community: $e");
      rethrow;
    }
  }

  Future<void> deleteCommunity(String communityId) async {
    try {
      await _service.deleteCommunity(communityId);
      _communities.removeWhere((c) => c.id == communityId);
      notifyListeners();
    } catch (e) {
      debugPrint("Error deleting community: $e");
      rethrow;
    }
  }

  Future<void> joinCommunity(String communityId, String userEmail) async {
    final index = _communities.indexWhere((c) => c.id == communityId);
    if (index != -1) {
      final members = List<String>.from(_communities[index].members);
      if (!members.contains(userEmail)) {
        members.add(userEmail);
        try {
          await _service.updateCommunityMembers(communityId, members);
          _communities[index] = _communities[index].copyWith(members: members);
          notifyListeners();
        } catch (e) {
          debugPrint("Error joining community: $e");
        }
      }
    }
  }

  Future<void> leaveCommunity(String communityId, String userEmail) async {
    final index = _communities.indexWhere((c) => c.id == communityId);
    if (index != -1) {
      final members = List<String>.from(_communities[index].members);
      if (members.contains(userEmail)) {
        members.remove(userEmail);
        try {
          await _service.updateCommunityMembers(communityId, members);
          _communities[index] = _communities[index].copyWith(members: members);
          notifyListeners();
        } catch (e) {
          debugPrint("Error leaving community: $e");
        }
      }
    }
  }

  Future<void> toggleLike(String communityId, String userEmail) async {
    final index = _communities.indexWhere((c) => c.id == communityId);
    if (index == -1) return;

    final currentLikes = List<String>.from(_communities[index].likes);
    if (currentLikes.contains(userEmail)) {
      currentLikes.remove(userEmail);
    } else {
      currentLikes.add(userEmail);
    }

    _communities[index] = _communities[index].copyWith(likes: currentLikes);
    notifyListeners();

    try {
      await _service.toggleLike(communityId, userEmail);
    } catch (e) {
      debugPrint("Error toggling like: $e");
      // Optional: rollback if needed
    }
  }

  Stream<List<Map<String, dynamic>>> streamComments(String communityId) {
    return _service.streamComments(communityId);
  }

  Future<void> addComment(String communityId, String author, String text) async {
    await _service.addComment(communityId, author, text);
  }
}
