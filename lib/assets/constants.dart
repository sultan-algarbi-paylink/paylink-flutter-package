class PaylinkConstants {
  /// All payment methods are accepted by Paylink
  static const List<String> validCardBrands = [
    'mada',
    'visaMastercard',
    'amex',
    'tabby',
    'tamara',
    'stcpay',
    'urpay'
  ];

  /// Testing API credentials.
  static const String testingApiId = 'APP_ID_1123453311';
  static const String testingSecretKey = '0662abb5-13c7-38ab-cd12-236e58f43766';

  /// API Link
  static const String testApiLink = 'https://restpilot.paylink.sa';
  static const String productionApiLink = 'https://restapi.paylink.sa';

  /// Payment Frame Url
  static const String testingPaymentFrameUrl =
      'https://paymentpilot.paylink.sa/pay/frame';
  static const String productionPaymentFrameUrl =
      'https://payment.paylink.sa/pay/frame';
}
