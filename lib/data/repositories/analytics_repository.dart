import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:media_network/core/utils/app_error_log.dart';

abstract class AnalyticsRepository {
  Future<void> trackVisit();
  Stream<int> watchVisitCount();
}

class FirestoreAnalyticsRepository implements AnalyticsRepository {
  FirestoreAnalyticsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  static const _tag = 'AnalyticsRepo';

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> get _visitsDoc =>
      _firestore.collection('analytics').doc('visits');

  @override
  Future<void> trackVisit() async {
    try {
      await _visitsDoc.set(
        {'count': FieldValue.increment(1)},
        SetOptions(merge: true),
      );
    } catch (e, st) {
      AppErrorLog.log(e, st, tag: _tag, op: 'trackVisit');
    }
  }

  @override
  Stream<int> watchVisitCount() {
    return AppErrorLog.guardStream(
      _visitsDoc.snapshots().map((snapshot) {
        if (!snapshot.exists) return 0;
        return (snapshot.data()?['count'] as num?)?.toInt() ?? 0;
      }),
      tag: _tag,
      op: 'watchVisitCount',
    );
  }
}
