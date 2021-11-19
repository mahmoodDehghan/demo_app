class TokenResponse {
  final String? token;
  final String? refreshToken;
  final bool hasError;
  final List<String>? errorMessage;

  TokenResponse({
    required this.token,
    required this.refreshToken,
    required this.hasError,
    required this.errorMessage,
  });

  factory TokenResponse.fromJson(dynamic response) {
    final dict = response as Map<String, dynamic>;
    if (dict['error']) {
      final errList = dict['message'] as List<dynamic>;
      return TokenResponse(
          token: null,
          refreshToken: null,
          hasError: true,
          errorMessage: [...errList]);
    } else {
      return TokenResponse(
          token: dict['token'],
          refreshToken: dict['refreshToken'],
          hasError: false,
          errorMessage: dict['message']);
    }
  }
}
