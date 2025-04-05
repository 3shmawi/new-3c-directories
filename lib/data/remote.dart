import 'package:dio/dio.dart';
import 'package:new_3c/model/news.dart';

import '../config/constants.dart';

class APIHandler {
  static final _dio = Dio(BaseOptions(
    baseUrl: AppConstants.baseUrl,
  ));

  static Future<NewsModel> getEverythingNews({
    required String word,
    int? subtractDays,
  }) async {
    try {
      final response = await _dio.get(
        AppConstants.url(
          "everything",
          {
            "q": word,
            "from": getDate(days: subtractDays),
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

  static String getDate({int? days}) {
    final now = DateTime.now().subtract(Duration(days: days ?? 1));
    return "${now.year}-${now.month}-${now.day}";
  }
}
