import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:media_network/data/models/registration.dart';
import 'package:media_network/data/repositories/analytics_repository.dart';
import 'package:media_network/data/repositories/registration_repository.dart';

enum AdminLoadState { loading, loaded, error }

enum AdminMetricTab { registrations, visits, countries, creators }

class AdminViewModel extends ChangeNotifier {
  AdminViewModel({
    required RegistrationRepository registrationRepository,
    required AnalyticsRepository analyticsRepository,
  })  : _registrationRepository = registrationRepository,
        _analyticsRepository = analyticsRepository;

  final RegistrationRepository _registrationRepository;
  final AnalyticsRepository _analyticsRepository;
  StreamSubscription<List<Registration>>? _registrationSubscription;
  StreamSubscription<int>? _visitSubscription;

  AdminLoadState _loadState = AdminLoadState.loading;
  String? _errorMessage;
  String _searchQuery = '';
  AdminMetricTab _selectedTab = AdminMetricTab.registrations;
  String? _selectedSkill;
  String? _selectedCountry;
  List<Registration> _allRegistrations = const [];
  List<Registration> _filteredRegistrations = const [];
  int _visitCount = 0;
  bool _initialized = false;

  AdminLoadState get loadState => _loadState;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  AdminMetricTab get selectedTab => _selectedTab;
  String? get selectedSkill => _selectedSkill;
  String? get selectedCountry => _selectedCountry;
  bool get isShowingGroupDetail =>
      (_selectedTab == AdminMetricTab.creators && _selectedSkill != null) ||
      (_selectedTab == AdminMetricTab.countries && _selectedCountry != null);
  List<Registration> get registrations => _filteredRegistrations;
  int get registrationCount => _allRegistrations.length;
  int get creatorsCount => registrationCount;
  int get visitCount => _visitCount;
  int get countriesCount => _allRegistrations
      .map((registration) => registration.nationality?.trim())
      .whereType<String>()
      .where((nationality) => nationality.isNotEmpty)
      .toSet()
      .length;

  String get listTitle => switch (_selectedTab) {
        AdminMetricTab.registrations => 'Registrations',
        AdminMetricTab.visits => 'Visit insights',
        AdminMetricTab.countries => _selectedCountry ?? 'Select a country',
        AdminMetricTab.creators => _selectedSkill ?? 'Select a skill',
      };

  int get listCount => switch (_selectedTab) {
        AdminMetricTab.registrations => registrations.length,
        AdminMetricTab.visits => visitCount,
        AdminMetricTab.countries => isShowingGroupDetail
            ? selectedCountryCreators.length
            : countryOptions.length,
        AdminMetricTab.creators => isShowingGroupDetail
            ? selectedSkillCreators.length
            : skillOptions.length,
      };

  List<({String name, int count})> get skillOptions {
    final query = _searchQuery.trim().toLowerCase();
    return creatorsBySkill.entries
        .where((entry) {
          if (query.isEmpty) return true;
          return entry.key.toLowerCase().contains(query) ||
              entry.value.any((r) => _matchesCreatorSearch(r, query));
        })
        .map((entry) => (name: entry.key, count: entry.value.length))
        .toList(growable: false);
  }

  List<({String name, int count})> get countryOptions {
    final query = _searchQuery.trim().toLowerCase();
    return registrationsByCountry.entries
        .where((entry) {
          if (query.isEmpty) return true;
          return entry.key.toLowerCase().contains(query) ||
              entry.value.any((r) => _matchesCreatorSearch(r, query));
        })
        .map((entry) => (name: entry.key, count: entry.value.length))
        .toList(growable: false);
  }

  List<Registration> get selectedSkillCreators {
    if (_selectedSkill == null) return const [];
    final creators = creatorsBySkill[_selectedSkill] ?? const [];
    return _filterCreatorsList(creators);
  }

  List<Registration> get selectedCountryCreators {
    if (_selectedCountry == null) return const [];
    final creators = registrationsByCountry[_selectedCountry] ?? const [];
    return _filterCreatorsList(creators);
  }

  Map<String, List<Registration>> get creatorsBySkill {
    final grouped = <String, List<Registration>>{};
    for (final registration in _filteredRegistrations) {
      for (final skill in registration.skills) {
        final key = skill.trim();
        if (key.isEmpty) continue;
        grouped.putIfAbsent(key, () => []).add(registration);
      }
    }
    final entries = grouped.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return Map.fromEntries(entries);
  }

  Map<String, List<Registration>> get registrationsByCountry {
    final grouped = <String, List<Registration>>{};
    for (final registration in _filteredRegistrations) {
      final country = registration.nationality?.trim();
      if (country == null || country.isEmpty) continue;
      grouped.putIfAbsent(country, () => []).add(registration);
    }
    final entries = grouped.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return Map.fromEntries(entries);
  }

  void init() {
    if (_initialized) return;
    _initialized = true;

    _registrationSubscription = _registrationRepository.watchAll().listen(
      (registrations) {
        _allRegistrations = registrations;
        _loadState = AdminLoadState.loaded;
        _errorMessage = null;
        _applyFilter();
        notifyListeners();
      },
      onError: (Object error) {
        _loadState = AdminLoadState.error;
        _errorMessage = error.toString();
        notifyListeners();
      },
    );

    _visitSubscription = _analyticsRepository.watchVisitCount().listen(
      (count) {
        _visitCount = count;
        notifyListeners();
      },
      onError: (_) {},
    );
  }

  void selectTab(AdminMetricTab tab) {
    if (_selectedTab == tab) return;
    _selectedTab = tab;
    _selectedSkill = null;
    _selectedCountry = null;
    notifyListeners();
  }

  void selectSkill(String skill) {
    _selectedSkill = skill;
    notifyListeners();
  }

  void selectCountry(String country) {
    _selectedCountry = country;
    notifyListeners();
  }

  void clearGroupSelection() {
    _selectedSkill = null;
    _selectedCountry = null;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      _filteredRegistrations = _allRegistrations;
      return;
    }

    _filteredRegistrations = _allRegistrations
        .where((registration) => _matchesCreatorSearch(registration, query))
        .toList(growable: false);
  }

  bool _matchesCreatorSearch(Registration registration, String query) {
    return registration.name.toLowerCase().contains(query) ||
        registration.email.toLowerCase().contains(query) ||
        registration.skills.any(
          (skill) => skill.toLowerCase().contains(query),
        ) ||
        (registration.nationality?.toLowerCase().contains(query) ?? false);
  }

  List<Registration> _filterCreatorsList(List<Registration> creators) {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return creators;
    return creators
        .where((registration) => _matchesCreatorSearch(registration, query))
        .toList(growable: false);
  }

  @override
  void dispose() {
    _registrationSubscription?.cancel();
    _visitSubscription?.cancel();
    super.dispose();
  }
}
