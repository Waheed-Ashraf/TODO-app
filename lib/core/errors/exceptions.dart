// lib/core/errors/app_exceptions.dart
class AppException implements Exception {
  final String message;
  AppException(this.message);
  @override
  String toString() => message;
}
