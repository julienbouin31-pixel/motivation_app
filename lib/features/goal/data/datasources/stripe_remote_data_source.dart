import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class StripeRemoteDataSource {
  final Dio _dio;

  StripeRemoteDataSource(this._dio);

  /// Validates the Stripe API key by fetching account info.
  /// Returns the account display name on success, throws on failure.
  Future<StripeAccountInfo> fetchAccountInfo(String apiKey) async {
    final response = await _dio.get(
      'https://api.stripe.com/v1/account',
      options: Options(
        headers: {'Authorization': 'Bearer $apiKey'},
      ),
    );
    final data = response.data as Map<String, dynamic>;
    return StripeAccountInfo(
      id: data['id'] as String? ?? '',
      displayName: data['settings']?['dashboard']?['display_name'] as String? ??
          data['business_profile']?['name'] as String? ??
          'Compte Stripe',
      email: data['email'] as String? ?? '',
    );
  }

  /// Fetches all active subscriptions and computes the current MRR.
  /// MRR = sum of (plan.amount / plan.interval_count) for monthly normalization.
  Future<StripeMrrData> fetchMrr(String apiKey) async {
    double totalMrr = 0;
    String? startingAfter;
    bool hasMore = true;

    while (hasMore) {
      final params = <String, dynamic>{
        'status': 'active',
        'limit': 100,
        if (startingAfter != null) 'starting_after': startingAfter,
        'expand[]': 'data.items.data.price',
      };

      final response = await _dio.get(
        'https://api.stripe.com/v1/subscriptions',
        queryParameters: params,
        options: Options(
          headers: {'Authorization': 'Bearer $apiKey'},
        ),
      );

      final body = response.data as Map<String, dynamic>;
      final subs = (body['data'] as List?) ?? [];

      for (final sub in subs) {
        final items = sub['items']?['data'] as List? ?? [];
        for (final item in items) {
          final price = item['price'] as Map<String, dynamic>?;
          if (price == null) continue;
          final unitAmount = (price['unit_amount'] as num?)?.toDouble() ?? 0;
          final quantity = (item['quantity'] as num?)?.toDouble() ?? 1;
          final interval = price['recurring']?['interval'] as String? ?? 'month';
          final intervalCount = (price['recurring']?['interval_count'] as num?)?.toDouble() ?? 1;

          // Normalize to monthly amount in the currency's base unit (cents → euros)
          double monthlyAmount;
          switch (interval) {
            case 'year':
              monthlyAmount = (unitAmount * quantity) / (12 * intervalCount);
            case 'week':
              monthlyAmount = (unitAmount * quantity * 4.33) / intervalCount;
            case 'day':
              monthlyAmount = (unitAmount * quantity * 30) / intervalCount;
            default: // month
              monthlyAmount = (unitAmount * quantity) / intervalCount;
          }
          totalMrr += monthlyAmount;
        }
      }

      hasMore = body['has_more'] == true;
      if (subs.isNotEmpty) {
        startingAfter = subs.last['id'] as String?;
      }
    }

    // Convert cents to base currency unit (e.g. cents → euros)
    final mrrInUnits = totalMrr / 100;

    // Fetch previous month MRR for change calculation
    final previousMrr = await _fetchPreviousMonthMrr(apiKey);

    final changePct = previousMrr > 0
        ? ((mrrInUnits - previousMrr) / previousMrr * 100)
        : 0.0;

    return StripeMrrData(
      currentMrr: mrrInUnits,
      changePct: changePct,
    );
  }

  /// Approximates previous month MRR by checking subscriptions created before
  /// the start of the current month. This is a simplified estimation.
  Future<double> _fetchPreviousMonthMrr(String apiKey) async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final startOfPrevMonth = DateTime(now.year, now.month - 1, 1);

    double totalMrr = 0;
    String? startingAfter;
    bool hasMore = true;

    while (hasMore) {
      final params = <String, dynamic>{
        'status': 'active',
        'limit': 100,
        'created[lt]': (startOfMonth.millisecondsSinceEpoch / 1000).floor(),
        'created[gte]': (startOfPrevMonth.millisecondsSinceEpoch / 1000).floor() - 86400 * 365 * 5,
        if (startingAfter != null) 'starting_after': startingAfter,
        'expand[]': 'data.items.data.price',
      };

      final response = await _dio.get(
        'https://api.stripe.com/v1/subscriptions',
        queryParameters: params,
        options: Options(headers: {'Authorization': 'Bearer $apiKey'}),
      );

      final body = response.data as Map<String, dynamic>;
      final subs = (body['data'] as List?) ?? [];

      for (final sub in subs) {
        final items = sub['items']?['data'] as List? ?? [];
        for (final item in items) {
          final price = item['price'] as Map<String, dynamic>?;
          if (price == null) continue;
          final unitAmount = (price['unit_amount'] as num?)?.toDouble() ?? 0;
          final quantity = (item['quantity'] as num?)?.toDouble() ?? 1;
          final interval = price['recurring']?['interval'] as String? ?? 'month';
          final intervalCount = (price['recurring']?['interval_count'] as num?)?.toDouble() ?? 1;

          double monthlyAmount;
          switch (interval) {
            case 'year':
              monthlyAmount = (unitAmount * quantity) / (12 * intervalCount);
            case 'week':
              monthlyAmount = (unitAmount * quantity * 4.33) / intervalCount;
            case 'day':
              monthlyAmount = (unitAmount * quantity * 30) / intervalCount;
            default:
              monthlyAmount = (unitAmount * quantity) / intervalCount;
          }
          totalMrr += monthlyAmount;
        }
      }

      hasMore = body['has_more'] == true;
      if (subs.isNotEmpty) {
        startingAfter = subs.last['id'] as String?;
      }
    }

    return totalMrr / 100;
  }
}

class StripeAccountInfo {
  final String id;
  final String displayName;
  final String email;
  const StripeAccountInfo({required this.id, required this.displayName, required this.email});
}

class StripeMrrData {
  final double currentMrr;
  final double changePct;
  const StripeMrrData({required this.currentMrr, required this.changePct});
}
