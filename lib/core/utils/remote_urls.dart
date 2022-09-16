class RemoteUrl {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String apiKey = 'aec430914e97e1e5105c8480777cda9a';
  static const String language = 'en-US';
  static const String popularMovies = '$baseUrl/movie/popular?api_key=$apiKey&language=$language&page=1';
}
