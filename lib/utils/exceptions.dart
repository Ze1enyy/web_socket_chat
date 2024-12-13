/// Exception for login errors
class LoginException implements Exception {
  final String message;
  LoginException(this.message);


  @override
  String toString() => message;
}