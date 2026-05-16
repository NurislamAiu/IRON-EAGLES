import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/expedition_invite_model.dart';

class InviteService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> sendInvite(ExpeditionInvite invite) async {
    await _db.collection('invites').doc(invite.id).set(invite.toMap());
  }

  Stream<List<ExpeditionInvite>> streamMyInvites(String email) {
    return _db
        .collection('invites')
        .where('inviteeEmail', isEqualTo: email)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => ExpeditionInvite.fromMap(d.data())).toList());
  }

  Future<void> updateInviteStatus(String inviteId, String status) async {
    await _db.collection('invites').doc(inviteId).update({'status': status});
  }
}
