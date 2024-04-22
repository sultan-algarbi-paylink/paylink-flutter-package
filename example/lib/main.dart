import 'package:flutter/material.dart';

// Example widgets
import 'package:example/widgets/appbar.dart';
import 'package:example/widgets/body_content.dart';
import 'package:example/widgets/checkout_child.dart';

// Paylink Payment Package
import 'package:paylink_payment/paylink_payment.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payment Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Payment Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      body: MyCartContent(errorMessage: errorMessage),

      /// -- Paylink Example
      bottomNavigationBar: GestureDetector(
        onTap: () {
          setState(() => errorMessage = null);
          PaylinkPayment(
            context: context,
            isTestMode: true,
            webViewTitle: 'Payment Screen',
          ).openPaymentForm(
            transactionNo: '1713690519134',
            onPaymentComplete: onPaymentComplete,
            onError: onErrorPayment,
          );
        },
        child: const MyCheckoutContent(),
      ),
    );
  }

  /// -- Required function to handle the payment completion
  onPaymentComplete(Map<String, dynamic> orderDetails) {
    setState(() {
      double? amount = orderDetails['amount'];
      String? orderStatus = orderDetails['orderStatus'];
      errorMessage = 'Order Amount: $amount, order Status: $orderStatus';
    });
  }

  /// -- Required function to handle the payment error
  onErrorPayment(Object error) {
    setState(() => errorMessage = error.toString());
  }
}
