import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:paylink_payment_sdk/payment_web_view.dart';

class PaymentSDK {
  final BuildContext context;

  PaymentSDK(this.context);

  Future<Map<String, dynamic>> _getOrderDetails(String orderNumber) async {
    var url = 'https://order.paylink.sa/web/embeddedJs/$orderNumber';
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load order details');
    }
  }

  void openPaymentForm(String orderNumber, final Function(String orderNumber, String transactionNo, bool orderPaid, double orderTotal) onCallbackReached) async {
    try {
      var orderDetails = await _getOrderDetails(orderNumber);
      var clientName = orderDetails['clientName'];
      var clientMobile = orderDetails['clientMobile'];
      var callbackUrl = orderDetails['callbackUrl'];

      _showWebView(orderNumber, clientName, clientMobile, callbackUrl, onCallbackReached);
    } catch (e) {
      // Handle exceptions or errors
      // log('Error fetching order details: $e');
    }
  }

  void handleCallbackReached(String orderNumber, String externalOrderNumber, final Function(String orderNumber, String transactioNo, bool orderPaid, double orderTotal) onCallbackReached) async {
    var orderDetails = await _getOrderDetails(orderNumber);
    var orderPaid = orderDetails['orderPaid'];
    var orderTotal = orderDetails['orderTotal'];

    onCallbackReached(externalOrderNumber, orderNumber, orderPaid, orderTotal);
  }

  void _showWebView(String orderNumber, String clientName, String clientMobile, String callbackUrl, final Function(String orderNumber, String transactioNo, bool orderPaid, double orderTotal) onCallbackReached) {
    String paymentUrl = 'https://payment.paylink.sa/pay/frame/$orderNumber?n=${Uri.encodeComponent(clientName)}&m=${Uri.encodeComponent(clientMobile)}';
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentWebView(
          initialUrl: paymentUrl,
          callbackUrl: callbackUrl,
          onCallbackReached: (data) => handleCallbackReached(orderNumber, data['externalOrderNumber'], onCallbackReached),
        ),
      ),
    );
  }
}
