import 'package:http/http.dart' as http;
import 'dart:convert';

/// Paylink files
import 'package:paylink_payment/assets/constants.dart';
import 'package:paylink_payment/models/paylink_product.dart';
import 'package:paylink_payment/models/paylink_invoice.dart';

/// A class to interact with the Paylink API.
class PaylinkAPI {
  /// Properties
  final String apiId;
  final String secretKey;
  final bool persistToken = false;
  final String apiBaseUrl;
  final String paymentFrameUrl;
  String? idToken;

  PaylinkAPI({
    required this.apiId,
    required this.secretKey,
    required this.apiBaseUrl,
    required this.paymentFrameUrl,
  });

  /// Private constructor
  PaylinkAPI._internal({
    required this.apiId,
    required this.secretKey,
    required this.apiBaseUrl,
    required this.paymentFrameUrl,
  }) {
    idToken = null;
  }

  /// Test constructor
  factory PaylinkAPI.test() {
    return PaylinkAPI._internal(
      apiId: PaylinkConstants.testingApiId,
      secretKey: PaylinkConstants.testingSecretKey,
      apiBaseUrl: PaylinkConstants.testApiBaseUrl,
      paymentFrameUrl: PaylinkConstants.testingPaymentFrameUrl,
    );
  }

  /// Production constructor
  factory PaylinkAPI.production(String apiId, String secretKey) {
    return PaylinkAPI._internal(
      apiId: apiId,
      secretKey: secretKey,
      apiBaseUrl: PaylinkConstants.productionApiBaseUrl,
      paymentFrameUrl: PaylinkConstants.productionPaymentFrameUrl,
    );
  }

  /// Authenticates with the Paylink API and retrieves an authentication token.
  Future<void> _authenticate() async {
    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/api/auth'),
        headers: {
          'accept': '*/*',
          'content-type': 'application/json',
        },
        body: json.encode({
          'apiId': apiId,
          'secretKey': secretKey,
          'persistToken': persistToken,
        }),
      );

      /// Check if the request was successful
      if (response.statusCode != 200) {
        _handleResponseError(response, 'Failed to authenticate');
      }

      if (response.body.isEmpty) {
        throw Exception('Authentication token missing in the response.');
      }

      /// Decode the JSON response and extract the token
      final responseData = json.decode(response.body);

      /// check if the response contains an id_token
      if (responseData is! Map<String, dynamic> ||
          !responseData.containsKey('id_token')) {
        throw Exception('Authentication token missing in the response.');
      }

      /// Store the token for future API calls
      idToken = responseData['id_token'] as String?;
    } catch (e) {
      /// In case of any exception, clear the token and rethrow the error
      idToken = null;
      rethrow;
    }
  }

  /// Adds an invoice to the Paylink system.
  Future<PaylinkInvoice> addInvoice({
    required double amount,
    required String clientMobile,
    required String clientName,
    String? clientEmail,
    required String orderNumber,
    required String callBackUrl,
    String? cancelUrl,
    String? currency = "SAR",
    required List<PaylinkProduct> products,
    String? note,
    String? smsMessage,
    List<String>? supportedCardBrands,
    bool displayPending = true,
  }) async {
    try {
      if (idToken == null) await _authenticate();

      /// Filter and sanitize supportedCardBrands
      if (supportedCardBrands != null && supportedCardBrands.isNotEmpty) {
        supportedCardBrands = supportedCardBrands
            .where((brand) => PaylinkConstants.validCardBrands.contains(brand))
            .toList();
      }

      /// Convert PaylinkProduct objects to maps
      List<Map<String, dynamic>> productsArray = [];
      if (products.isNotEmpty) {
        for (var product in products) {
          productsArray.add(product.toMap());
        }
      }

      /// Request body parameters
      Map<String, dynamic> requestBody = {
        'amount': amount,
        'callBackUrl': callBackUrl,
        'cancelUrl': cancelUrl,
        'clientEmail': clientEmail,
        'clientMobile': clientMobile,
        'currency': currency,
        'clientName': clientName,
        'note': note,
        'orderNumber': orderNumber,
        'products': productsArray,
        'smsMessage': smsMessage,
        'supportedCardBrands': supportedCardBrands,
        'displayPending': displayPending,
      };

      final response = await http.post(
        Uri.parse('$apiBaseUrl/api/addInvoice'),
        headers: {
          'accept': '*/*',
          'content-type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode != 200) {
        _handleResponseError(response, 'Failed to add the invoice');
      }

      if (response.body.isEmpty) {
        throw Exception('Order details missing from the response');
      }

      /// Decode the JSON response and extract the order details
      final orderDetails = json.decode(response.body);

      if (orderDetails is! Map<String, dynamic>) {
        throw Exception('Order details missing from the response');
      }

      return PaylinkInvoice.fromResponseData(orderDetails);
    } catch (e) {
      rethrow;
    }
  }

  /// Retrieves invoice details
  Future<PaylinkInvoice> getInvoice(String transactionNo) async {
    try {
      if (idToken == null) await _authenticate();

      final response = await http.get(
        Uri.parse('$apiBaseUrl/api/getInvoice/$transactionNo'),
        headers: {
          'accept': '*/*',
          'content-type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
      );

      if (response.statusCode != 200) {
        _handleResponseError(response, 'Failed to get the invoice');
      }

      if (response.body.isEmpty) {
        throw Exception('Order details missing from the response');
      }

      /// Decode the JSON response and extract the order details
      final orderDetails = json.decode(response.body);

      if (orderDetails is! Map<String, dynamic>) {
        throw Exception('Order details missing from the response');
      }

      return PaylinkInvoice.fromResponseData(orderDetails);
    } catch (e) {
      rethrow;
    }
  }

  /// Cancels an existing invoice.
  Future<bool> cancelInvoice(String transactionNo) async {
    try {
      if (idToken == null) await _authenticate();

      /// Request body parameters
      Map<String, dynamic> requestBody = {
        'transactionNo': transactionNo,
      };

      final response = await http.post(
        Uri.parse('$apiBaseUrl/api/cancelInvoice'),
        headers: {
          'accept': '*/*',
          'content-type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode != 200) {
        _handleResponseError(response, 'Failed to cancel the invoice');
      }

      if (response.body.isEmpty) {
        throw Exception('Failed to cancel the invoice');
      }

      /// Decode the JSON response and extract the token
      final responseData = json.decode(response.body);

      /// check if the response contains an id_token
      if (responseData is! Map<String, dynamic> ||
          !responseData.containsKey('success')) {
        throw Exception('Failed to cancel the invoice');
      }

      return responseData['success'] == 'true';
    } catch (e) {
      rethrow;
    }
  }

  /// Handles HTTP response errors
  void _handleResponseError(http.Response response, String defaultErrorMsg) {
    // Try to extract error details from the response body
    Map<String, dynamic> responseData;

    try {
      responseData = json.decode(response.body);
    } catch (e) {
      responseData = {};
    }

    String errorMsg = responseData['detail'] ??
        responseData['title'] ??
        responseData['error'] ??
        response.body;

    if (errorMsg.isEmpty) {
      errorMsg = defaultErrorMsg;
    }

    // Include the status code in the error message for debugging purposes
    errorMsg += ", Status code: ${response.statusCode}";

    throw Exception(errorMsg);
  }
}
