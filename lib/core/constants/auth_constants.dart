import 'package:flutter/foundation.dart';

abstract final class AuthConstants {
  static const pendingEmailKey = 'pending_sign_in_email';
  static const localSessionEmailKey = 'local_session_email';

  /// Web: current origin + /home. Native: update for your hosted URL.
  static String get emailLinkContinueUrl {
    if (kIsWeb) {
      return '${Uri.base.origin}/home';
    }
    return 'https://media-network-9315c.web.app/home';
  }
}
