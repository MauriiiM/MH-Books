class ApiException implements Exception {
  final String? _message;
  final String? _prefix;

  ApiException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix: ${_message ?? ''}";
  }
}

class FetchDataException extends ApiException {
  FetchDataException([String? message])
      : super(message, "Error During Communication");
}

class BadResponseException extends ApiException {
  BadResponseException([String? message]) : super(message, "Invalid Request");
}
