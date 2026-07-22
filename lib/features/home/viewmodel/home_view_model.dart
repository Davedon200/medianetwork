import 'package:flutter/material.dart';
import 'package:media_network/data/mock/home_mock_data.dart';
import 'package:media_network/data/models/home_snapshot.dart';

class HomeViewModel extends ChangeNotifier {
  HomeSnapshot get snapshot => HomeMockData.snapshot;
}
