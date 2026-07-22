import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:media_network/core/utils/app_error_log.dart';
import 'package:media_network/data/models/media_item.dart';

abstract class MediaRepository {
  Stream<List<MediaItem>> watchMedia();
}

class FirestoreMediaRepository implements MediaRepository {
  FirestoreMediaRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  static const _tag = 'MediaRepo';

  final FirebaseFirestore _firestore;

  @override
  Stream<List<MediaItem>> watchMedia() {
    return AppErrorLog.guardStream(
      _firestore.collection('media').snapshots().map(
            (snapshot) => snapshot.docs
                .map(
                  (doc) => MediaItem.fromFirestore(
                    Map<String, dynamic>.from(doc.data()),
                  ),
                )
                .toList(growable: false),
          ),
      tag: _tag,
      op: 'watchMedia',
    );
  }
}
