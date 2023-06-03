class Failure {
  Failure(this.message, {this.error, this.stackTrace});

  final String message;
  final Object? error;
  final StackTrace? stackTrace;

  @override
  String toString() {
    return 'Failure(message: $message, error: $error, stackTrace: $stackTrace)';
  }
}
