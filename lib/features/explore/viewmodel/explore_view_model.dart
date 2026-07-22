import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:media_network/core/constants/breakpoints.dart';
import 'package:media_network/data/models/media_item.dart';
import 'package:media_network/data/repositories/media_repository.dart';

enum ExploreLoadState { loading, loaded, error }

class ExploreViewModel extends ChangeNotifier {
  ExploreViewModel({required MediaRepository mediaRepository})
      : _mediaRepository = mediaRepository;

  final MediaRepository _mediaRepository;
  StreamSubscription<List<MediaItem>>? _subscription;

  ExploreLoadState _loadState = ExploreLoadState.loading;
  String? _errorMessage;
  List<MediaItem> _items = const [];
  bool _initialized = false;

  ExploreLoadState get loadState => _loadState;
  String? get errorMessage => _errorMessage;
  List<MediaItem> get items => _items;

  void init() {
    if (_initialized) return;
    _initialized = true;

    _subscription = _mediaRepository.watchMedia().listen(
      (items) {
        _items = items;
        _loadState = ExploreLoadState.loaded;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (Object error) {
        _loadState = ExploreLoadState.error;
        _errorMessage = error.toString();
        notifyListeners();
      },
    );
  }

  int crossAxisCountForWidth(double width) {
    if (width < Breakpoints.mobile) return 1;
    if (width < Breakpoints.tablet) return 3;
    return 4;
  }

  double childAspectRatioForWidth(double width) {
    if (width < Breakpoints.mobile) return 1.2;
    return 0.9;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
