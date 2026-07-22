import 'package:flutter_test/flutter_test.dart';
import 'package:media_network/core/constants/app_colors.dart';
import 'package:media_network/data/models/registration.dart';
import 'package:media_network/data/repositories/analytics_repository.dart';
import 'package:media_network/data/repositories/registration_repository.dart';
import 'package:media_network/features/landing/viewmodel/landing_view_model.dart';

class FakeRegistrationRepository implements RegistrationRepository {
  final Set<String> existingEmails = {};

  @override
  Future<bool> existsByEmail(String email) async {
    return existingEmails.contains(email.trim().toLowerCase());
  }

  @override
  Future<void> submit(Registration registration) async {
    existingEmails.add(registration.email);
  }

  @override
  Stream<List<Registration>> watchAll() async* {
    yield const [];
  }
}

class FakeAnalyticsRepository implements AnalyticsRepository {
  int visitCount = 0;

  @override
  Future<void> trackVisit() async {
    visitCount++;
  }

  @override
  Stream<int> watchVisitCount() async* {
    yield visitCount;
  }
}

void main() {
  group('LandingViewModel', () {
    late FakeRegistrationRepository registrationRepository;
    late FakeAnalyticsRepository analyticsRepository;
    late LandingViewModel viewModel;

    setUp(() {
      registrationRepository = FakeRegistrationRepository();
      analyticsRepository = FakeAnalyticsRepository();
      viewModel = LandingViewModel(
        registrationRepository: registrationRepository,
        analyticsRepository: analyticsRepository,
      );
    });

    tearDown(() {
      viewModel.dispose();
    });

    test('init tracks visit and opens register form on /register', () async {
      await viewModel.init(path: '/register');

      expect(analyticsRepository.visitCount, 1);
      expect(viewModel.showRegisterForm, isTrue);
    });

    test('checkEmail returns exists when registration is found', () async {
      registrationRepository.existingEmails.add('found@example.com');

      final result = await viewModel.checkEmail('found@example.com');

      expect(result, EmailCheckResult.exists);
      expect(viewModel.enteredEmail, 'found@example.com');
    });

    test('onEmailExists emits navigateToExplore event', () {
      viewModel.onEmailExists();
      expect(viewModel.pendingEvent, LandingEvent.navigateToExplore);
    });
  });
}
