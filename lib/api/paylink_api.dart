import 'package:http/http.dart' as http;
import 'dart:convert';

/// Paylink files
import 'package:paylink_payment/assets/helpers.dart';
import 'package:paylink_payment/models/paylink_product.dart';

/// A class to interact with the Paylink API.
abstract class PaylinkAPI extends PaylinkHelper {
  /// Production API credentials.
  final String? apiId, secretKey;

  /// API endpoints for production and test environments.
  late String apiLink;

  /// Payment token obtained after authentication.
  late String? paymentToken;

  /// Indicates whether the API is in test mode.
  final bool isTestMode;

  /// Initializes the PaylinkAPI with optional test mode, API ID, and secret key.
  ///
  /// [isTestMode] - Indicates whether the API is in test mode.
  /// [apiId] - Production API ID.
  /// [secretKey] - Production API secret key.
  PaylinkAPI({
    this.isTestMode = false,
    this.apiId,
    this.secretKey,
  }) {
    /// Set API endpoints based on test mode.
    apiLink = getApiLink(isTestMode);
    super.paymentFrameUrl = getPaymentFrameUrl(isTestMode);

    /// Initialize payment token.
    paymentToken = null;
  }

  /// Authenticates with the Paylink API to obtain a payment token.
  /// This method sends a POST request to the API's authentication endpoint.
  Future<void> _authenticate() async {
    try {
      final response = await http.post(
        Uri.parse('$apiLink/api/auth'),
        headers: {
          'accept': '*/*',
          'content-type': 'application/json',
        },
        body: json.encode({
          'apiId': getApiId(apiId, isTestMode),
          'secretKey': getSecretKey(secretKey, isTestMode),
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

      /// Set the payment token
      paymentToken = token;
    } catch (e) {
      rethrow;
    }
  }

  /// Add invoice to Paylink.
  ///
  /// [amount] - The total amount of the invoice. NOTE: Buyer will pay this amount regardless of the total amounts of the products' prices.
  /// [clientMobile] - The mobile number of the client.
  /// [clientName] - The name of the client.
  /// [clientEmail] - The email address of the client.
  /// [orderNumber] - A unique identifier for the invoice.
  /// [callBackUrl] - Call back URL that will be called by the Paylink to the merchant system. This callback URL will receive two parameters: orderNumber, and transactionNo.
  /// [cancelUrl] - Call back URL to cancel orders that will be called by the Paylink to the merchant system. This callback URL will receive two parameters: orderNumber, and transactionNo.
  /// [currency] - The currency code of the invoice. The default value is SAR. (e.g., USD, EUR, GBP).
  /// [products] - An array of PaylinkProduct objects to be included in the invoice.
  /// [note] - A note for the invoice.
  /// [smsMessage] - This option will enable the invoice to be sent to the client's mobile specified in clientMobile.
  /// [supportedCardBrands] - List of supported card brands. This list is optional. values are: [mada, visaMastercard, amex, tabby, tamara, stcpay, urpay]
  /// [displayPending] - This option will make this invoice displayed in my.paylink.sa
  ///
  /// Returns a map containing invoice details.
  Future<Map<String, dynamic>> addInvoice({
    required double amount,
    required String clientMobile,
    required String clientName,
    String? clientEmail,
    required String orderNumber,
    required String callBackUrl,
    String? cancelUrl,
    String? currency,
    required List<PaylinkProduct> products,
    String? note,
    String? smsMessage,
    List<String>? supportedCardBrands,
    bool displayPending = true,
  }) async {
    try {
      if (paymentToken == null) await _authenticate();

      /// Filter and sanitize supportedCardBrands
      List<String> filteredCardBrands = filterCardBrands(supportedCardBrands);

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
        'supportedCardBrands': filteredCardBrands,
        'displayPending': displayPending,
      };

      final response = await http.post(
        Uri.parse('$apiLink/api/addInvoice'),
        headers: {
          'accept': '*/*',
          'content-type': 'application/json',
          'Authorization': 'Bearer $paymentToken',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to add the invoice: ${response.body}');
      }

      /// Decode the order details
      Map<String, dynamic> orderDetails = json.decode(response.body);

      return orderDetails;
    } catch (e) {
      rethrow;
    }
  }

  /// Retrieves invoice details from the Paylink API.
  ///
  /// [transactionNo] - The transaction number for which to retrieve invoice details.
  ///
  /// Returns a map containing invoice details.
  Future<Map<String, dynamic>> getInvoice({String? transactionNo}) async {
    try {
      if (transactionNo == null) {
        throw ArgumentError('Transaction number cannot be null.');
      }

      if (paymentToken == null) await _authenticate();

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

      /// Decode the order details
      Map<String, dynamic> orderDetails = json.decode(response.body);

      return orderDetails;
    } catch (e) {
      rethrow;
    }
  }

  /// Cancel invoice from Paylink.
  ///
  /// [transactionNo] - The transaction number of the invoice to cancel.
  ///
  /// Returns boolean
  Future<void> cancelInvoice({String? transactionNo}) async {
    try {
      if (transactionNo == null) {
        throw ArgumentError('Transaction number cannot be null.');
      }

      if (paymentToken == null) await _authenticate();

      /// Request body parameters
      Map<String, dynamic> requestBody = {
        'transactionNo': transactionNo,
      };

      final response = await http.post(
        Uri.parse('$apiLink/api/cancelInvoice'),
        headers: {
          'accept': '*/*',
          'content-type': 'application/json',
          'Authorization': 'Bearer $paymentToken',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to cancel the invoice: ${response.body}');
      }

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (responseBody.isEmpty || responseBody['success'] != 'true') {
        throw Exception('Failed to cancel the invoice: ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
