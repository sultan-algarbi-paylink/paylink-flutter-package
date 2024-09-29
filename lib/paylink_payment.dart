library paylink_payment;

import 'package:flutter/material.dart';
import 'package:paylink_payment/api/paylink_api.dart';
import 'package:paylink_payment/assets/helpers.dart';
import 'package:paylink_payment/widgets/payment_webview.dart';
import 'package:paylink_payment/assets/constants.dart';
import 'package:paylink_payment/models/paylink_invoice.dart';

// export PaylinkProduct class
export 'package:paylink_payment/models/paylink_product.dart';
export 'package:paylink_payment/models/paylink_invoice.dart';

/// A class for handling payments using PaylinkAPI.
class PaylinkPayment extends PaylinkAPI {
  /// The [BuildContext] for the payment.
  final BuildContext context;

  /// Webview theme settings
  final String webViewTitle;
  final Color textColor;
  final Color themeColor;

  /// Private constructor
  PaylinkPayment._internal({
    required this.context,
    required this.webViewTitle,
    required this.textColor,
    required this.themeColor,
    required super.apiId,
    required super.secretKey,
    required super.apiBaseUrl,
    required super.paymentFrameUrl,
  });

  /// Factory constructor for test environment
  factory PaylinkPayment.test({
    required BuildContext context,
    String webViewTitle = 'Payment',
    Color textColor = Colors.white,
    Color themeColor = const Color(0xFF6a64ef),
  }) {
    return PaylinkPayment._internal(
      context: context,
      webViewTitle: webViewTitle,
      textColor: textColor,
      themeColor: themeColor,
      apiId: PaylinkConstants.testingApiId,
      secretKey: PaylinkConstants.testingSecretKey,
      apiBaseUrl: PaylinkConstants.testApiBaseUrl,
      paymentFrameUrl: PaylinkConstants.testingPaymentFrameUrl,
    );
  }

  /// Factory constructor for production environment
  factory PaylinkPayment.production({
    required BuildContext context,
    required String apiId,
    required String secretKey,
    String webViewTitle = 'Payment',
    Color textColor = Colors.white,
    Color themeColor = const Color(0xFF6a64ef),
  }) {
    return PaylinkPayment._internal(
      context: context,
      webViewTitle: webViewTitle,
      textColor: textColor,
      themeColor: themeColor,
      apiId: apiId,
      secretKey: secretKey,
      apiBaseUrl: PaylinkConstants.productionApiBaseUrl,
      paymentFrameUrl: PaylinkConstants.productionPaymentFrameUrl,
    );
  }

  /// Opens the payment form in a web view.
  ///
  /// [transactionNo] - The transaction number for the payment.
  /// [onPaymentComplete] - A callback function to handle the payment result.
  /// [onError] - A callback function to handle errors during payment.
  void openPaymentForm({
    required String transactionNo,
    required final Function(
      PaylinkInvoice orderDetails,
    ) onPaymentComplete,
    required final Function(Object error) onError,
  }) async {
    try {
      // Fetch order details from the API
      var orderDetails = await getInvoice(transactionNo);

      // Extract gateway order request from order details
      final gatewayOrderRequest = orderDetails.gatewayOrderRequest;

      // Show the payment form in a web view
      _showWebView(
        orderDetails.transactionNo,
        gatewayOrderRequest.clientName,
        gatewayOrderRequest.clientMobile,
        gatewayOrderRequest.callBackUrl,
        onPaymentComplete,
      );
    } catch (e) {
      onError(e);
    }
  }

  /// Shows the payment form in a web view.
  ///
  /// [transactionNo] - The transaction number for the payment.
  /// [clientName] - The name of the client making the payment.
  /// [clientMobile] - The mobile number of the client.
  /// [callBackUrl] - The callback URL used to detect payment completion.
  /// [onPaymentComplete] - A callback function to handle the payment result.
  void _showWebView(
    String? transactionNo,
    String? clientName,
    String? clientMobile,
    String? callBackUrl,
    final Function(PaylinkInvoice orderDetails) onPaymentComplete,
  ) {
    try {
      if (transactionNo == null) {
        throw ArgumentError('Transaction number cannot be null.');
      }

      if (callBackUrl == null) {
        throw ArgumentError('Callback Url cannot be null.');
      }

      // Construct the payment page URL
      String paymentPageUrl = PaylinkHelper.getPaymentPageUrl(
        paymentFrameUrl,
        transactionNo,
        clientName ?? '',
        clientMobile ?? '',
      );

      // Navigate to the payment web view
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentWebView(
            initialUrl: paymentPageUrl,
            callBackUrl: callBackUrl,
            webViewTitle: webViewTitle,
            textColor: textColor,
            themeColor: themeColor,
            onPaymentCallbackReached: (callBackParams) {
              // Handle payment callback when reached
              handleCallbackReached(callBackParams, onPaymentComplete);
            },
          ),
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Handles the payment callback when reached.
  ///
  /// [callBackParams] - The parameters received in the payment callback.
  /// [onPaymentComplete] - A callback function to handle the payment result.
  void handleCallbackReached(
    Map<String, String> callBackParams,
    final Function(PaylinkInvoice orderDetails) onPaymentComplete,
  ) async {
    try {
      // Extract transaction number from callback parameters
      String? transactionNo =
          callBackParams['transactionNo'] ?? callBackParams['TransactionNo'];

      // Check if transaction number is available
      if (transactionNo == null) {
        throw Exception(
          'Transaction number not provided in callback parameters',
        );
      }

      // Fetch order details using the transaction number
      final orderDetails = await getInvoice(transactionNo);

      // Extract order amount and order status from order details
      String orderStatus = orderDetails.orderStatus;
      Map<String, dynamic> paymentErrors = PaylinkHelper.paymentErrorsToMap(
        orderDetails.paymentErrors,
      );

      // Throw an error if the payment is not paid
      if (orderStatus.toLowerCase() != 'paid') {
        String errorMsg = paymentErrors['errorTitle'] ??
            'Failed to proccess the payment, try again!';
        throw Exception(errorMsg);
      }

      // Execute the after payment function with order details
      onPaymentComplete(orderDetails);
    } catch (e) {
      // Rethrow the exception for higher-level handling
      rethrow;
    }
  }
}
