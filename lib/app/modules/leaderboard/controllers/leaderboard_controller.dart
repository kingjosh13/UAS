import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaderboardController extends GetxController {
  var leaderboard = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadLeaderboard();
  }

  // Memuat leaderboard dari SharedPreferences
  Future<void> _loadLeaderboard() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedLeaderboard = prefs.getStringList('leaderboard');
    if (savedLeaderboard != null) {
      leaderboard.assignAll(savedLeaderboard.map((e) => Map<String, dynamic>.from({"name": e.split(',')[0], "score": int.parse(e.split(',')[1])})).toList());
    }
  }

  // Menambahkan data ke leaderboard dan menyimpannya ke SharedPreferences
  Future<void> addToLeaderboard(String name, int score) async {
    final prefs = await SharedPreferences.getInstance();

    // Menambahkan data baru ke leaderboard
    leaderboard.add({'name': name, 'score': score});

    // Mengurutkan leaderboard berdasarkan skor tertinggi
    leaderboard.sort((a, b) => b['score'].compareTo(a['score']));

    // Menyimpan leaderboard yang sudah diurutkan
    final leaderboardToSave = leaderboard.map((e) => '${e['name']},${e['score']}').toList();
    await prefs.setStringList('leaderboard', leaderboardToSave);

    update();
  }
}
