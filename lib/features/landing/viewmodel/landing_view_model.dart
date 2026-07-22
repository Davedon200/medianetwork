import 'package:flutter/material.dart';
import 'package:media_network/core/constants/app_colors.dart';
import 'package:media_network/core/utils/app_error_log.dart';
import 'package:media_network/data/models/registration.dart';
import 'package:media_network/data/repositories/analytics_repository.dart';
import 'package:media_network/data/repositories/registration_repository.dart';

enum LandingEvent {
  navigateToExplore,
  showSuccessDialog,
  showAlreadyRegisteredDialog,
  showEmailDialog,
}

class LandingViewModel extends ChangeNotifier {
  LandingViewModel({
    required RegistrationRepository registrationRepository,
    required AnalyticsRepository analyticsRepository,
  })  : _registrationRepository = registrationRepository,
        _analyticsRepository = analyticsRepository;

  final RegistrationRepository _registrationRepository;
  final AnalyticsRepository _analyticsRepository;

  bool showRegisterForm = false;
  bool isLoading = false;
  String? enteredEmail;
  LandingEvent? pendingEvent;

  String? selectedTitle;
  String? selectedNationality;
  String selectedCountryCode = '+234';
  final List<String> selectedSkills = [];

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final kcController = TextEditingController();
  final ceZoneController = TextEditingController();

  Future<void> init({required String path}) async {
    try {
      await _analyticsRepository.trackVisit();
    } catch (e, st) {
      AppErrorLog.log(e, st, tag: 'LandingViewModel', op: 'trackVisit');
    }

    switch (path) {
      case '/register':
        showRegisterForm = true;
      case '/resource':
        _emit(LandingEvent.showEmailDialog);
    }
    notifyListeners();
  }

  void toggleRegisterForm(bool value) {
    showRegisterForm = value;
    notifyListeners();
  }

  void clearPendingEvent() {
    pendingEvent = null;
  }

  void _emit(LandingEvent event) {
    pendingEvent = event;
  }

  Future<EmailCheckResult?> checkEmail(String email) async {
    // Do not notifyListeners here — the email dialog manages its own loading
    // state. Rebuilding the landing page during the dialog causes framework errors.
    final normalized = email.trim().toLowerCase();
    final exists = await _registrationRepository.existsByEmail(normalized);
    enteredEmail = normalized;
    return exists ? EmailCheckResult.exists : EmailCheckResult.notExists;
  }

  void onEmailExists() {
    _emit(LandingEvent.navigateToExplore);
    notifyListeners();
  }

  void onEmailNotExists() {
    showRegisterForm = true;
    emailController.text = enteredEmail ?? '';
    notifyListeners();
  }

  void toggleSkill(String skill, bool selected) {
    if (selected) {
      if (!selectedSkills.contains(skill)) selectedSkills.add(skill);
    } else {
      selectedSkills.remove(skill);
    }
    notifyListeners();
  }

  void setTitle(String? value) {
    selectedTitle = value;
    notifyListeners();
  }

  void setNationality(String? value) {
    selectedNationality = value;
    notifyListeners();
  }

  void setCountryCode(String value) {
    selectedCountryCode = value;
    notifyListeners();
  }

  void clearForm() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    kcController.clear();
    ceZoneController.clear();
    selectedSkills.clear();
    selectedTitle = null;
    selectedNationality = null;
    selectedCountryCode = '+234';
    notifyListeners();
  }

  Future<void> submitRegistration(GlobalKey<FormState> formKey) async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    isLoading = true;
    notifyListeners();

    try {
      final email = emailController.text.trim().toLowerCase();
      final exists = await _registrationRepository.existsByEmail(email);
      if (exists) {
        _emit(LandingEvent.showAlreadyRegisteredDialog);
        notifyListeners();
        return;
      }

      await _registrationRepository.submit(
        Registration(
          id: email,
          title: selectedTitle,
          name: nameController.text,
          email: email,
          phone: '$selectedCountryCode${phoneController.text}',
          nationality: selectedNationality,
          kc: kcController.text,
          ceZone: ceZoneController.text,
          skills: List<String>.from(selectedSkills),
        ),
      );

      _emit(LandingEvent.showSuccessDialog);
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    kcController.dispose();
    ceZoneController.dispose();
    super.dispose();
  }
}
