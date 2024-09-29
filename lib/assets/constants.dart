class PaylinkConstants {
  // Valid card brands accepted by Paylink.
  static const List<String> validCardBrands = [
    'mada',
    'visaMastercard',
    'amex',
    'tabby',
    'tamara',
    'stcpay',
    'urpay'
  ];

  // API URLs for production and test environments
  static const String testApiBaseUrl = 'https://restpilot.paylink.sa';
  static const String productionApiBaseUrl = 'https://restapi.paylink.sa';

  // Payment Frame URLs for production and test environments
  static const String testingPaymentFrameUrl =
      'https://paymentpilot.paylink.sa/pay/frame';
  static const String productionPaymentFrameUrl =
      'https://payment.paylink.sa/pay/frame';

  // Default credentials for the test environment
  static const String testingApiId = 'APP_ID_1123453311';
  static const String testingSecretKey = '0662abb5-13c7-38ab-cd12-236e58f43766';
}
