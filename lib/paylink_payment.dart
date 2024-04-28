library paylink_payment;

import 'package:flutter/material.dart';
import 'package:paylink_payment/api/paylink_api.dart';
import 'package:paylink_payment/widgets/payment_webview.dart';

/// A class for handling payments using PaylinkAPI.
class PaylinkPayment extends PaylinkAPI {
  /// The [BuildContext] for the payment.
  final BuildContext context;

  /// Webview theme settings
  final String webViewTitle;
  final Color textColor;
  final Color themeColor;

  /// Creates a new [PaylinkPayment] instance.
  ///
  /// [isTestMode] - Indicates whether the API is in test mode.
  /// [apiId] - Production API ID.
  /// [secretKey] - Production API secret key.
  /// [webViewTitle] - The title to display in the payment web view.
  /// [textColor] - The text color for the payment web view.
  /// [themeColor] - The theme color for the payment web view.
  PaylinkPayment({
    super.isTestMode,
    required super.apiId,
    required super.secretKey,
    required this.context,
    this.webViewTitle = 'Payment',
    this.textColor = Colors.white,
    this.themeColor = const Color(0xFF6a64ef),
  });

  /// Opens the payment form in a web view.
  ///
  /// [transactionNo] - The transaction number for the payment.
  /// [onPaymentComplete] - A callback function to handle the payment result.
  /// [onError] - A callback function to handle errors during payment.
  void openPaymentForm({
    required String transactionNo,
    required final Function(
      Map<String, dynamic> orderDetails,
    ) onPaymentComplete,
    required final Function(Object error) onError,
  }) async {
    try {
      // Fetch order details from the API
      var orderDetails = await getInvoice(transactionNo);

      // Extract gateway order request from order details
      Map<String, dynamic>? gatewayOrderRequest =
          orderDetails['gatewayOrderRequest'];

      // Check if gateway order request is available
      if (gatewayOrderRequest == null) {
        throw Exception('No gateway order request found in order details');
      }

      // Show the payment form in a web view
      _showWebView(
        orderDetails['transactionNo'],
        gatewayOrderRequest['clientName'],
        gatewayOrderRequest['clientMobile'],
        gatewayOrderRequest['callBackUrl'],
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
    final Function(Map<String, dynamic> orderDetails) onPaymentComplete,
  ) {
    try {
      if (transactionNo == null) {
        throw ArgumentError('Transaction number cannot be null.');
      }

      if (callBackUrl == null) {
        throw ArgumentError('Callback Url cannot be null.');
      }

      // Construct the payment page URL
      String paymentPageUrl = getPaymentPageUrl(
        transactionNo,
        clientName,
        clientMobile,
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
    final Function(Map<String, dynamic> orderDetails) onPaymentComplete,
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
      var orderDetails = await getInvoice(transactionNo);

      // Extract order amount and order status from order details
      String? orderStatus = orderDetails['orderStatus'];
      Map<String, dynamic>? paymentErrors = paymentErrorsToMap(
        orderDetails['paymentErrors'],
      );

      // Throw an error if the payment is not paid
      if (orderStatus?.toLowerCase() != 'paid') {
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

class PaylinkProduct {
  String title;
  double price;
  int qty;
  String? description;
  bool isDigital;
  String? imageSrc;
  double? specificVat;
  double? productCost;

  PaylinkProduct({
    required this.title,
    required this.price,
    required this.qty,
    this.description,
    this.isDigital = false,
    this.imageSrc,
    this.specificVat,
    this.productCost,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'qty': qty,
      'description': description,
      'isDigital': isDigital,
      'imageSrc': imageSrc,
      'specificVat': specificVat,
      'productCost': productCost,
    };
  }
}
