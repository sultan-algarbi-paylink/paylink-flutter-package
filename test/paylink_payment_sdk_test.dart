import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:paylink_payment_sdk/paylink_payment_sdk.dart';

void main() {
  testWidgets('Paylink Payment SDK openPaymentForm Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () {
                  PaymentSDK(context).openPaymentForm(
                    '123',
                    (orderNumber, transactionNo, orderPaid, orderTotal) {},
                  );
                  // Additional assertions can be added here
                },
                child: const Text('Test Button'),
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
  });
}
