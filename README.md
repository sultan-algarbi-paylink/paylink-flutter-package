# Paylink Payment Package

## Overview

`paylink_payment` is a Flutter Package designed to simplify the integration of Paylink's payment gateway into Flutter applications. It provides a streamlined way to handle payments within your Flutter app.

## Features

- Easy integration with Paylink payment gateway.
- Simplified payment process with minimal code.
- Secure handling of payment transactions.
- The ability to checkout an invoice.
- The ability to create a new invoice.
- The ability to cancel invoice.
- The ability to retrieve invoice details.

## Usage

To integrate Paylink's payment gateway into your Flutter application using the `paylink_payment` package, follow these steps:

1.  **Install the Package**:

    Add `paylink_payment` to your `pubspec.yaml` file under dependencies:

    ```yaml
    dependencies:
      paylink_payment: ^1.0.4 # Use the latest version
    ```

2.  **Import the Package**:

    Import the `paylink_payment` package in your Dart file:

    ```dart
    import 'package:paylink_payment/paylink_payment.dart';
    ```

3.  **Initialize Paylink instance**

    ```dart
    paylink = PaylinkPayment(
      context: context,
      isTestMode: true,
      apiId: null, // required for production environment
      secretKey: null, // required for production environment
      webViewTitle: 'Payment Screen', // optional
      textColor: Colors.white, // optional
      themeColor: Colors.blue, // optional
    )
    ```

    - Replace the placeholders (`apiId`, `secretKey`, etc.) with actual values required for the production environment.

## Package Functionalities

### 1. **Open Payment Form**:

Use the `PaylinkPayment` class to open the payment form when a button or action is triggered. Here's an example of how to do this:

```dart
// paylink instance initialized in previous step
paylink.openPaymentForm(
  transactionNo: '1713690519134',
  onPaymentComplete: (Map<String, dynamic> orderDetails) {
    /// Handle payment completion
  },
  onError: (Object error) {
    /// Handle payment error
  },
);
```

- Implement the `onPaymentComplete` and `onError` callbacks to handle the payment completion and any errors that occur during the payment process. Customize these callbacks based on your app's requirements.

### 2. **Add Invoice**:

```dart
paylink.addInvoice(
  amount: 220.0,
  clientMobile: '0512345678',
  clientName: 'Mohammed',
  orderNumber: '123456789',
  callBackUrl: 'https://example.com',
  products: [
    PaylinkProduct(title: 'Book', price: 100, qty: 2),
    PaylinkProduct(title: 'Pen', price: 2, qty: 10),
  ],
  cancelUrl: 'https://example.com',
  clientEmail: 'mohammed@test.com',
  currency: 'SAR',
  displayPending: true,
  note: 'Test invoice',
  smsMessage: 'URL: [SHORT_URL], Amount: [AMOUNT]',
  supportedCardBrands: ['mada', 'visaMastercard', 'amex', 'tabby', 'tamara', 'stcpay', 'urpay'],
)
.then((orderDetails) {
  /// Handle success response
})
.onError((error, stackTrace) {
  /// Handle error response
});
```

### 3. **Retrieve Invoice Details**:

```dart
paylink.getInvoice(
  transactionNo: '1713690519134'
)
.then((orderDetails) {
  /// Handle success response
})
.onError((error, stackTrace) {
  /// Handle error response
});
```

### 4. **Cancel Invoice**:

```dart
paylink.cancelInvoice(
  transactionNo: '1713690519134'
)
.then((_) {
  /// Handle success response
})
.onError((error, stackTrace) {
  /// Handle error response
});
```

By following these steps, you can easily integrate Paylink's payment gateway into your Flutter application using the `paylink_payment` package.
