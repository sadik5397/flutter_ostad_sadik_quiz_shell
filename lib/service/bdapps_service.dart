import 'dart:convert';

import 'package:http/http.dart' as http;

/// Client for the bdappsdigitalapps.com BDApps backend.
///
/// All endpoints accept `application/x-www-form-urlencoded` and the
/// mobile number is sent as the `user_mobile` form field. OTP flows
/// additionally expect `Otp` and `referenceNo`.
class BdappsService {
  static const String _base = 'https://www.bdappsdigitalapps.com/sadik5397';
  static const Map<String, String> _headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
  };

  // --- OTP flows -----------------------------------------------------------

  static Future<http.Response> sendOtp(String mobile) {
    return http.post(
      Uri.parse('$_base/send_otp.php'),
      headers: _headers,
      body: {'user_mobile': mobile},
    );
  }

  static Future<http.Response> verifyOtp(String otp, String referenceNo) {
    return http.post(
      Uri.parse('$_base/verify_otp.php'),
      headers: _headers,
      body: {'Otp': otp, 'referenceNo': referenceNo},
    );
  }

  // --- Subscription -------------------------------------------------------

  /// Checks whether [mobile] is currently REGISTERED on the BDApps service.
  /// Returns the raw [http.Response] so callers can inspect status / payload.
  static Future<http.Response> checkSubscription(String mobile) {
    return http.post(
      Uri.parse('$_base/check_subscription.php'),
      headers: _headers,
      body: {'user_mobile': mobile},
    );
  }

  static Future<http.Response> unsubscribe(String mobile) {
    return http.post(
      Uri.parse('$_base/unsubscribe.php'),
      headers: _headers,
      body: {'user_mobile': mobile},
    );
  }

  // --- Typed helpers ------------------------------------------------------

  /// Convenience wrapper around [checkSubscription] that returns a
  /// boolean.
  ///
  /// The BDApps backend reports the result via a JSON body whose shape
  /// varies depending on the outcome. We recognise the following
  /// flavours:
  ///
  /// * **Status code** (`statusCode` field, e.g. `"S1000"`, `"E1951"`).
  ///   A `1xxx` code is success / registered; anything else is treated
  ///   as not-registered. The code `E1951` explicitly means
  ///   "Forbidden or User Already Unregistered".
  /// * **Detail text** (`statusDetail` field) — parsed for keywords
  ///   like `unregistered`, `not registered`, `forbidden`.
  /// * **Boolean-ish** fields (`status`, `registered`, `isSubscribed`,
  ///   `subscribed`, `state`) — common in earlier BDApps deployments.
  ///
  /// Network / parse failures are reported as `false` (fail-closed).
  static Future<bool> isSubscribed(String mobile) async {
    try {
      final response = await checkSubscription(mobile);
      if (response.statusCode != 200) return false;
      final body = response.body.trim();
      if (body.isEmpty) return false;

      // Try JSON first.
      try {
        final decoded = jsonDecode(body);
        if (decoded is Map) {
          // 0. Explicit success flag. BDApps returns `"success": true`
          //    alongside `statusCode: "S1000"` on a successful response.
          final success = decoded['success'];
          if (success is bool && success) return true;
          if (success is num && success != 0) return true;
          if (success is String && success.toLowerCase() == 'true') return true;

          // 1. statusCode: BDApps uses "S1000" for success and codes
          //    like "E1951" for errors. A leading "1" => registered.
          final statusCodeValue = decoded['statusCode'];
          if (statusCodeValue is String) {
            final code = statusCodeValue.trim().toUpperCase();
            if (code.startsWith('S') || code.startsWith('1')) {
              return true;
            }
            if (code.startsWith('E') || code.startsWith('0')) {
              return false;
            }
          }

          // 2. statusDetail: scan for explicit unregistration keywords.
          final statusDetail = decoded['statusDetail'];
          if (statusDetail is String) {
            final lower = statusDetail.toLowerCase();
            if (lower.contains('unregistered') ||
                lower.contains('not registered') ||
                lower.contains('not subscribed') ||
                lower.contains('forbidden') ||
                lower.contains('forid')) {
              return false;
            }
            if (lower.contains('registered') || lower.contains('subscribed')) {
              return true;
            }
          }

          // 3. Common boolean-ish fields.
          for (final key in const [
            'status',
            'registered',
            'isSubscribed',
            'subscribed',
            'state',
          ]) {
            final value = decoded[key];
            if (value is bool) return value;
            if (value is num) return value != 0;
            if (value is String) {
              final lower = value.toLowerCase();
              if (lower == 'true' ||
                  lower == 'yes' ||
                  lower == 'active' ||
                  lower == 'registered') {
                return true;
              }
              if (lower == 'false' ||
                  lower == 'no' ||
                  lower == 'inactive' ||
                  lower == 'unregistered') {
                return false;
              }
            }
          }
        }
      } catch (_) {
        // Not JSON — fall through to substring scan below.
      }

      // Fallback: substring search for registration markers.
      final lower = body.toLowerCase();
      if (lower.contains('"registered":true') ||
          lower.contains('"is_subscribed":true') ||
          lower.contains('"status":"active"') ||
          lower.contains('"status":"registered"') ||
          lower.contains('"statuscode":"s1000"')) {
        return true;
      }
      if (lower.contains('"registered":false') ||
          lower.contains('"is_subscribed":false') ||
          lower.contains('"status":"inactive"') ||
          lower.contains('"status":"unregistered"') ||
          lower.contains('"statuscode":"e1951"') ||
          lower.contains('unregistered')) {
        return false;
      }
      // Unknown payload shape — be conservative and treat as not subscribed
      // so the user is prompted to subscribe rather than silently let through.
      return false;
    } catch (_) {
      return false;
    }
  }
}
