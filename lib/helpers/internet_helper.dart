class InternetHelper {
  static bool isNoInternetError(String error) {
    return error.contains('Failed host lookup');
  }
}
