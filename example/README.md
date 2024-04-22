# Paylink Payment SDK Example

## Overview

This example demonstrates how to integrate and use the `paylink_payment_sdk` in a Flutter application. It showcases a simple implementation of the payment process using the SDK.

## Getting Started

To run this example:

1. Clone the `paylink_payment_sdk` repository.
2. Navigate to the `example` directory.
3. Run `flutter pub get` to fetch the necessary dependencies.
4. Run `flutter run` to start the example app on a connected device or emulator.

## Features Demonstrated

- **Initialization**: How to initialize the `paylink_payment_sdk` in your Flutter app.
- **Payment Processing**: How to process payments using the `paylink_payment_sdk`.
- **Handling Responses**: How to handle the different responses from the payment gateway.

## Example Code

Here's a quick snippet from the example:

```dart
import 'package:flutter/material.dart';
import 'package:paylink_payment_sdk/paylink_payment_sdk.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Paylink Payment Example')),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              PaymentSDK(context,
                      environment: 'testing', paymentToken: 'your-token')
                  .openPaymentForm(
                'your_transaction_number',
                (transactionNo, orderNumber, orderPaid, orderTotal) {},
              );
            },
            child: Text('Start Payment'),
          ),
        ),
      ),
    );
  }
}
```
