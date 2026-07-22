import 'package:flutter/material.dart';
import 'package:media_network/data/mock/analytics_mock_data.dart';
import 'package:media_network/data/models/analytics_snapshot.dart';

class AnalyticsViewModel extends ChangeNotifier {
  AnalyticsSnapshot get snapshot => AnalyticsMockData.snapshot;
}
