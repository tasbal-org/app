class ServerException implements Exception {
  final String message;
  ServerException({required this.message});
}

class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException({required this.message});
}

class ValidationException implements Exception {
  final List<String> messages;
  ValidationException({required this.messages});
}

class CacheException implements Exception {
  final String message;
  CacheException({required this.message});
}