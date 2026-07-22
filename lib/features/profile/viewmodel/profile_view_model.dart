import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:media_network/core/utils/app_error_log.dart';
import 'package:media_network/data/models/user_profile.dart';
import 'package:media_network/data/repositories/profile_repository.dart';
import 'package:media_network/features/auth/viewmodel/auth_view_model.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({
    required AuthViewModel authViewModel,
    ProfileRepository? profileRepository,
  })  : _authViewModel = authViewModel,
        _profileRepository = profileRepository ?? FirestoreProfileRepository();

  final AuthViewModel _authViewModel;
  final ProfileRepository _profileRepository;

  UserProfile? profile;
  bool isUploading = false;
  String? errorMessage;

  Future<void> load() async {
    final uid = _authViewModel.uid;
    if (uid == null) return;
    await for (final value in _profileRepository.watchProfile(uid).take(1)) {
      profile = value;
      notifyListeners();
    }
  }

  Future<void> pickAndUploadAvatar() async {
    final uid = _authViewModel.uid;
    if (uid == null) return;

    Uint8List? bytes;
    if (kIsWeb) {
      final result = await FilePicker.pickFiles(
        type: FileType.image,
        withData: true,
      );
      bytes = result?.files.single.bytes;
    } else {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        imageQuality: 85,
      );
      if (picked != null) {
        bytes = await picked.readAsBytes();
      }
    }

    if (bytes == null) return;

    isUploading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final url = await _profileRepository.uploadAvatar(uid, bytes);
      await _profileRepository.updatePhotoUrl(uid, url);
      profile = profile?.copyWith(photoUrl: url);
    } catch (e, st) {
      AppErrorLog.log(e, st, tag: 'ProfileViewModel', op: 'pickAndUploadAvatar');
      errorMessage = 'Failed to upload photo';
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }
}
