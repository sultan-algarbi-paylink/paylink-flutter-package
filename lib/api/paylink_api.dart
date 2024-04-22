import 'package:http/http.dart' as http;
import 'dart:convert';

/// A class to interact with the Paylink API.
abstract class PaylinkAPI {
  /// Indicates whether the API is in test mode.
  final bool isTestMode;

  /// Production API credentials.
  final String? apiId, secretKey;

  /// API endpoints for production and test environments.
  late String apiLink, paymentFrameUrl;

  /// Payment token obtained after authentication.
  late String? paymentToken;

  /// Testing API credentials.
  final String testingApiId = 'APP_ID_1123453311';
  final String testingSecretKey = '0662abb5-13c7-38ab-cd12-236e58f43766';

  /// Initializes the PaylinkAPI with optional test mode, API ID, and secret key.
  /// [isTestMode] - Indicates whether the API is in test mode.
  /// [apiId] - Production API ID.
  /// [secretKey] - Production API secret key.
  PaylinkAPI({
    this.isTestMode = false,
    this.apiId,
    this.secretKey,
  }) {
    // Set API endpoints based on test mode.
    apiLink = isTestMode
        ? 'https://restpilot.paylink.sa'
        : 'https://restapi.paylink.sa';
    paymentFrameUrl = isTestMode
        ? 'https://paymentpilot.paylink.sa/pay/frame'
        : 'https://payment.paylink.sa/pay/frame';

    // Initialize payment token.
    paymentToken = null;
  }

  /// Authenticates with the Paylink API to obtain a payment token.
  /// This method sends a POST request to the API's authentication endpoint.
  Future<void> authenticate() async {
    try {
      final response = await http.post(
        Uri.parse('$apiLink/api/auth'),
        headers: {
          'accept': '*/*',
          'content-type': 'application/json',
        },
        body: json.encode({
          'apiId': isTestMode ? testingApiId : apiId,
          'secretKey': isTestMode ? testingSecretKey : secretKey,
          'persistToken': false,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to fetch payment token. Status code: ${response.statusCode}',
        );
      }

      final jsonResponse = json.decode(response.body);
      final token = jsonResponse['id_token'] as String?;
      if (token == null) throw Exception('Token not found in the response.');

      // Set the payment token
      paymentToken = token;
    } catch (e) {
      rethrow;
    }
  }

  /// Retrieves invoice details from the Paylink API.
  /// [transactionNo] - The transaction number for which to retrieve invoice details.
  /// Returns a map containing invoice details.
  Future<Map<String, dynamic>> getInvoice(String? transactionNo) async {
    try {
      if (transactionNo == null) {
        throw ArgumentError('Transaction number cannot be null.');
      }

      if (paymentToken == null) await authenticate();

      final response = await http.get(
        Uri.parse('$apiLink/api/getInvoice/$transactionNo'),
        headers: {
          'accept': '*/*',
          'content-type': 'application/json',
          'Authorization': 'Bearer $paymentToken',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load order details: ${response.body}');
      }

      return json.decode(response.body);
    } catch (e) {
      rethrow;
    }
  }

  /// Generates the payment page URL for a transaction.
  /// [transactionNo] - The transaction number for which to generate the payment URL.
  /// [clientName] - The name of the client making the payment.
  /// [clientMobile] - The mobile number of the client making the payment.
  /// Returns the payment page URL.
  String getPaymentPageUrl(
    String? transactionNo,
    String? clientName,
    String? clientMobile,
  ) {
    // Encode the strings to make it safe for literal use as a URI component.
    clientName = Uri.encodeComponent(clientName ?? '');
    clientMobile = Uri.encodeComponent(clientMobile ?? '');

    return '$paymentFrameUrl/$transactionNo?n=$clientName&m=$clientMobile';
  }

  /// Converts payment error data to a map format.
  /// [data] - The payment error data to be converted.
  /// Returns a map containing the converted payment errors.
  Map<String, dynamic> paymentErrorsToMap(data) {
    if (data == null) return {};

    // Check if data is actually a list
    if (data is List<dynamic>) {
      Map<String, dynamic> convertedMap = {};
      for (var item in data) {
        if (item is Map<String, dynamic>) convertedMap.addAll(item);
      }
      return convertedMap;
    } else {
      // Handle the case where data is not as expected
      throw const FormatException('Data is not in the expected format');
    }
  }
}
