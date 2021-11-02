class HttpException implements Exception {
  final String message;
  HttpException(this.message);

  @override
  // ignore: unnecessary_overrides
  String toString() {
    return super.toString();
  }
}
