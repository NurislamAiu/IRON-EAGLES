class ExpeditionInvite {
  final String id;
  final String expeditionId;
  final String expeditionName;
  final String inviterEmail;
  final String inviteeEmail;
  final String status; // 'pending', 'accepted', 'declined'
  final DateTime createdAt;

  ExpeditionInvite({
    required this.id,
    required this.expeditionId,
    required this.expeditionName,
    required this.inviterEmail,
    required this.inviteeEmail,
    this.status = 'pending',
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expeditionId': expeditionId,
      'expeditionName': expeditionName,
      'inviterEmail': inviterEmail,
      'inviteeEmail': inviteeEmail,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ExpeditionInvite.fromMap(Map<String, dynamic> map) {
    return ExpeditionInvite(
      id: map['id'] ?? '',
      expeditionId: map['expeditionId'] ?? '',
      expeditionName: map['expeditionName'] ?? '',
      inviterEmail: map['inviterEmail'] ?? '',
      inviteeEmail: map['inviteeEmail'] ?? '',
      status: map['status'] ?? 'pending',
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
