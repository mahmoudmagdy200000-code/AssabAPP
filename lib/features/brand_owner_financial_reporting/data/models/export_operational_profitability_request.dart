class ExportOperationalProfitabilityRequest {
  final String formatType;
  final String? email;

  const ExportOperationalProfitabilityRequest({
    required this.formatType,
    this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'format_type': formatType,
      if (email != null) 'email': email,
    };
  }
}
