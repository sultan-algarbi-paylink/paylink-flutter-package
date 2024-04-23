# Paylink Payment Package

## Overview

`paylink_payment` is a Flutter Package designed to simplify the integration of Paylink's payment gateway into Flutter applications. It provides a streamlined way to handle payments within your Flutter app.

## Features

- Easy integration with Paylink payment gateway.
- Simplified payment process with minimal code.
- Secure handling of payment transactions.

## Usage

To integrate Paylink's payment gateway into your Flutter application using the `paylink_payment` package, follow these steps:

1. **Install the Package**:

   Add `paylink_payment` to your `pubspec.yaml` file under dependencies:

   ```yaml
   dependencies:
     paylink_payment: ^1.0.2 # Use the latest version
   ```

2. **Import the Package**:

   Import the `paylink_payment` package in your Dart file:

   ```dart
   import 'package:paylink_payment/paylink_payment.dart';
   ```

3. **Open Payment Form**:

   Use the `PaylinkPayment` class to open the payment form when a button or action is triggered. Here's an example of how to do this:

   ```dart
   void openPayment(BuildContext context) {
     PaylinkPayment(
       context: context,
       isTestMode: true,
       apiId: null, // required for production environment
       secretKey: null, // required for production environment
       webViewTitle: 'Payment Screen', // optional
       textColor: Colors.white, // optional
       themeColor: Colors.blue, // optional
     ).openPaymentForm(
       transactionNo: '1713690519134',
       onPaymentComplete: (Map<String, dynamic> orderDetails) {
         /// Handle payment completion
       },
       onError: (Object error) {
         /// Handle payment error
       },
     );
   }
   ```

   Replace the placeholders (`apiId`, `secretKey`, etc.) with actual values required for the production environment.

4. **Handle Payment Completion and Errors**:

   Implement the `onPaymentComplete` and `onError` callbacks to handle the payment completion and any errors that occur during the payment process.

   ```dart
   onPaymentComplete: (Map<String, dynamic> orderDetails) {
     /// Handle payment completion
   },
   onError: (Object error) {
     /// Handle payment error
   },
   ```

   Customize these callbacks based on your app's requirements.

By following these steps, you can easily integrate Paylink's payment gateway into your Flutter application using the `paylink_payment` package.
