import 'package:flutter_test/flutter_test.dart';
import 'package:media_network/data/chat/chat_helpers.dart';

void main() {
  group('buildConversationId', () {
    test('sorts emails alphabetically regardless of input order', () {
      expect(
        buildConversationId('bob@rnm.test', 'alice@rnm.test'),
        'alice@rnm.test__bob@rnm.test',
      );
      expect(
        buildConversationId('alice@rnm.test', 'bob@rnm.test'),
        'alice@rnm.test__bob@rnm.test',
      );
    });

    test('normalizes casing and whitespace', () {
      expect(
        buildConversationId('  Bob@RNM.TEST ', 'alice@rnm.test'),
        'alice@rnm.test__bob@rnm.test',
      );
    });
  });

  group('unreadFieldKey', () {
    test('sanitizes email for Firestore field names', () {
      expect(
        unreadFieldKey('user@example.com'),
        'unread_user_at_example_dot_com',
      );
    });
  });
}
