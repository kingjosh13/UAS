import 'package:get/get.dart';
import 'package:quiz_app/app/models/news_model.dart';
import 'package:quiz_app/app/services/api_service.dart';

class NewsController extends GetxController {
  var isLoading = true.obs;
  var kumparanNews = <KumparanNews>[].obs;
  var errorMessage = ''.obs;

  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchNews();
  }

  // Fungsi untuk mengambil data berita dari API
  Future<void> fetchNews() async {
    try {
      isLoading.value = true;
      final news = await _apiService.fetchNews();
      kumparanNews.assignAll(news);
    } catch (e) {
      errorMessage.value = 'Failed to load kumparan news: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
