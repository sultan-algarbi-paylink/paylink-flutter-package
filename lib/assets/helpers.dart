import 'package:paylink_payment/assets/constants.dart';

abstract class PaylinkHelper {
  /// API endpoints for production and test environments.
  late String paymentFrameUrl;

  String getApiLink(bool isTesting) {
    return isTesting
        ? PaylinkConstants.testApiLink
        : PaylinkConstants.productionApiLink;
  }

  String getPaymentFrameUrl(bool isTesting) {
    return isTesting
        ? PaylinkConstants.testingPaymentFrameUrl
        : PaylinkConstants.productionPaymentFrameUrl;
  }

  String? getApiId(String? productionApiId, bool isTesting) {
    return isTesting ? PaylinkConstants.testingApiId : productionApiId;
  }

  String? getSecretKey(String? productionSecretKey, bool isTesting) {
    return isTesting ? PaylinkConstants.testingSecretKey : productionSecretKey;
  }

  List<String> filterCardBrands(List<String>? supportedCardBrands) {
    return supportedCardBrands == null
        ? PaylinkConstants.validCardBrands
        : supportedCardBrands
            .where((brand) => PaylinkConstants.validCardBrands.contains(brand))
            .toList();
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
