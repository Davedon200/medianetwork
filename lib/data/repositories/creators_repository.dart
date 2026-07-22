import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:media_network/core/utils/app_error_log.dart';
import 'package:media_network/data/mock/creators_mock_data.dart';
import 'package:media_network/data/models/creator_profile.dart';

abstract class CreatorsRepository {
  Future<List<CreatorProfile>> fetchCreators();
  Stream<List<CreatorProfile>> watchCreators();
}

class FirestoreCreatorsRepository implements CreatorsRepository {
  FirestoreCreatorsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  static const _tag = 'CreatorsRepo';

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _creators =>
      _firestore.collection('creators');

  @override
  Future<List<CreatorProfile>> fetchCreators() async {
    try {
      final snapshot = await _creators.get();
      if (snapshot.docs.isEmpty) return CreatorsMockData.creators;
      return snapshot.docs.map(_fromDoc).toList(growable: false);
    } catch (e, st) {
      AppErrorLog.log(e, st, tag: _tag, op: 'fetchCreators');
      return CreatorsMockData.creators;
    }
  }

  @override
  Stream<List<CreatorProfile>> watchCreators() {
    return AppErrorLog.guardStream(
      _creators.snapshots().map((snapshot) {
        if (snapshot.docs.isEmpty) return CreatorsMockData.creators;
        return snapshot.docs.map(_fromDoc).toList(growable: false);
      }),
      tag: _tag,
      op: 'watchCreators',
    );
  }

  CreatorProfile _fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return CreatorProfile(
      id: doc.id,
      email: data['email'] as String? ?? doc.id,
      name: data['name'] as String? ?? '',
      title: data['title'] as String? ?? '',
      nationality: data['nationality'] as String? ?? '',
      ceZone: data['ceZone'] as String? ?? '',
      skills: List<String>.from(data['skills'] ?? []),
      photoUrl: data['photoUrl'] as String?,
    );
  }
}
