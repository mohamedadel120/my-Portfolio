import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> logVisit() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bool hasVisited = prefs.getBool('hasVisited') ?? false;

      final docRef = _firestore.collection('analytics').doc('summary');
      final String today = DateTime.now().toIso8601String().split('T').first;

      Map<String, dynamic> data = {
        'totalVisits': FieldValue.increment(1),
        'visitsOverTime': {
          today: FieldValue.increment(1),
        }
      };

      if (!hasVisited) {
        await prefs.setBool('hasVisited', true);
        data['uniqueVisitors'] = FieldValue.increment(1);
      }

      await docRef.set(data, SetOptions(merge: true));
    } catch (e) {
      print('Error logging visit: $e');
    }
  }

  Future<void> logProjectClick(String projectTitle) async {
    try {
      final docRef = _firestore.collection('analytics').doc('summary');
      await docRef.set({
        'totalClicks': FieldValue.increment(1),
        'topProjects': {
          projectTitle: FieldValue.increment(1),
        }
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error logging project click: $e');
    }
  }
}
