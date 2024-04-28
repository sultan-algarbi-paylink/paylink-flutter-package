// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:paylink_payment/paylink_payment.dart';

void main() {
  testWidgets(
    'Paylink Payment Package openPaymentForm Test',
    (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () {
                    PaylinkPayment(
                      context: context,
                      isTestMode: true,
                      apiId: null,
                      secretKey: null,
                      webViewTitle: 'Payment Webview',
                    ).openPaymentForm(
                      transactionNo: '1713170798626',
                      onPaymentComplete: onPaymentComplete,
                      onError: onErrorPayment,
                    );
                    // Additional assertions can be added here
                  },
                  child: const Text('Test Payment'),
                );
              },
            ),
          ),
        ),
      );

      // Tap the button to trigger the openPaymentForm method
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Add your assertions here
    },
  );
}

onPaymentComplete(Map<String, dynamic> orderDetails) {
  print('==================== Order Amount: ${orderDetails['amount']}');
  print('==================== order Status: ${orderDetails['orderStatus']}');
}

onErrorPayment(Object error) {
  print("=================== $error");
}
