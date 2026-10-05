class ApiCancelledException implements Exception {
  const ApiCancelledException();

  @override
  String toString() => 'ApiCancelledException: request was cancelled silently.';
}
