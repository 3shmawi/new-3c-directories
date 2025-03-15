abstract class AppConstants {
  static const baseUrl = "https://newsapi.org/v2/";
  static const apiKey = "2fbf9799a7fb47c88f266c543fb36a78";

  static url(String endpoint, Map<String, String> query) {
    return "$endpoint?${query.entries.map((e) => "${e.key}=${e.value}").join('&')}&apiKey=$apiKey";
  }
//https://newsapi.org/v2/everything?q=tesla&from=2025-02-15&sortBy=publishedAt&apiKey=2fbf9799a7fb47c88f266c543fb36a78
}
