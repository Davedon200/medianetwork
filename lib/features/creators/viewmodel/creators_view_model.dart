import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_network/data/models/creator_profile.dart';
import 'package:media_network/data/repositories/creators_repository.dart';

class CreatorsViewModel extends ChangeNotifier {
  CreatorsViewModel({CreatorsRepository? repository})
      : _repository = repository ?? FirestoreCreatorsRepository();

  static const filters = [
    'All',
    'Video',
    'Audio',
    'Design',
    'Writing',
    'Broadcast',
  ];

  final CreatorsRepository _repository;
  List<CreatorProfile> _all = [];
  bool _isLoading = true;
  StreamSubscription<List<CreatorProfile>>? _subscription;

  String _selectedFilter = 'All';

  bool get isLoading => _isLoading;
  String get selectedFilter => _selectedFilter;
  int get totalCount => _all.length;

  List<CreatorProfile> get creators {
    if (_selectedFilter == 'All') return _all;
    return _all
        .where((c) => c.skills.any(
              (s) => s.toLowerCase() == _selectedFilter.toLowerCase(),
            ))
        .toList();
  }

  Future<void> init() async {
    _all = await _repository.fetchCreators();
    _isLoading = false;
    notifyListeners();

    _subscription = _repository.watchCreators().listen((list) {
      _all = list;
      notifyListeners();
    });
  }

  void setFilter(String filter) {
    if (_selectedFilter == filter) return;
    _selectedFilter = filter;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
