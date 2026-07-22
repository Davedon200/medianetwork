import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_network/data/models/registration.dart';

void main() {
  group('Registration', () {
    test('toFirestore includes normalized email and fields', () {
      const registration = Registration(
        id: 'user@example.com',
        title: 'Brother',
        name: 'John Doe',
        email: 'User@Example.com',
        phone: '+2348012345678',
        nationality: 'Nigeria',
        kc: '@john',
        ceZone: 'Zone A',
        skills: ['Video Editing'],
      );

      final data = registration.toFirestore();

      expect(data['email'], 'user@example.com');
      expect(data['name'], 'John Doe');
      expect(data['phone'], '+2348012345678');
      expect(data['skills'], ['Video Editing']);
      expect(data['createdAt'], isA<FieldValue>());
    });
  });
}
