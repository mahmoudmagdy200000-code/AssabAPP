class CustodyPersonalBalanceOnlyResponse {
  final double personalBalance;

  CustodyPersonalBalanceOnlyResponse({required this.personalBalance});

  factory CustodyPersonalBalanceOnlyResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return CustodyPersonalBalanceOnlyResponse(
      personalBalance: (json['data']['personalCustodyBalance'] as num)
          .toDouble(),
    );
  }
}
