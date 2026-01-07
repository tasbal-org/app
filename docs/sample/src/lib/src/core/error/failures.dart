abstract class Failure {
  final String message;
  Failure({required this.message});
}

class ValidationFailure extends Failure {
  ValidationFailure({required super.message});
}

class ServerFailure extends Failure {
  ServerFailure({required super.message});
}

class CacheFailure extends Failure {
  CacheFailure({required super.message});
}