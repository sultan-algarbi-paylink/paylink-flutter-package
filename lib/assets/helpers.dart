class PaylinkHelper {
  /// Generates the payment page URL for a transaction.
  /// [paymentFrameUrl] - The URL of the payment frame.
  /// [transactionNo] - The transaction number for which to generate the payment URL.
  /// [clientName] - The name of the client making the payment.
  /// [clientMobile] - The mobile number of the client making the payment.
  /// Returns the payment page URL.
  static String getPaymentPageUrl(
    String paymentFrameUrl,
    String transactionNo,
    String clientName,
    String clientMobile,
  ) {
    // Encode the strings to make it safe for literal use as a URI component.
    clientName = Uri.encodeComponent(clientName);
    clientMobile = Uri.encodeComponent(clientMobile);

    return '$paymentFrameUrl/$transactionNo?n=$clientName&m=$clientMobile';
  }

  /// Converts payment error data to a map format.
  /// [data] - The payment error data to be converted.
  /// Returns a map containing the converted payment errors.
  static Map<String, dynamic> paymentErrorsToMap(data) {
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
