import 'package:dio/dio.dart';
import 'package:new_3c/model/news.dart';

import '../config/constants.dart';

class APIHandler {
  static final _dio = Dio(BaseOptions(
    baseUrl: AppConstants.baseUrl,
  ));

  static Future<NewsModel> getEverythingNews({
    required String word,
    int? year,
    int? month,
    int? day,
  }) async {
    try {
      final response = await _dio.get(
        AppConstants.url(
          "everything",
          {
            "q": word,
            "from":
                "${year ?? DateTime.now().year}-${month ?? DateTime.now().month}-${day ?? DateTime.now().day}",
            "sortBy": "publishedAt",
          },
        ),
      );
      if (response.statusCode == 200) {
        return NewsModel.fromJson(response.data);
      } else {
        throw Exception('Failed to get news');
      }
    } on DioException catch (error) {
      throw Exception('Failed to get news: ${error.message}');
    }
  }
}
