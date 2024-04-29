import 'package:flutter/material.dart';
import 'package:paylink_payment_example/data/invoices.dart';

// Example widgets
import 'package:paylink_payment_example/widgets/appbar.dart';
import 'package:paylink_payment_example/widgets/bottom_navigation_bar.dart';
import 'package:paylink_payment_example/widgets/invoice_row.dart';
import 'package:paylink_payment_example/widgets/invoice_screen.dart';

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
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? paymentResponseMessage;

  /// --- Paylink: Paylink instance
  late PaylinkPayment paylink;

  List<Map<String, dynamic>> invoiceList = preInvoiceList;

  @override
  void initState() {
    super.initState();
    paylinkInitialize();

    addPendingInvoiceForTesting();
  }

  /// --- 1. Paylink: Initialize Paylink instance
  void paylinkInitialize() {
    paylink = PaylinkPayment(
      context: context,
      isTestMode: true,
      apiId: null, // required for production environment
      secretKey: null, // required for production environment
      webViewTitle: 'Payment Screen', // optional
      textColor: Colors.white, // optional
      themeColor: Colors.blue, // optional
    );
  }

  /// --- 2. Paylink: Add Invoice Function
  void addInvoice() {
    paylink
        .addInvoice(
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
          supportedCardBrands: [
            'mada',
            'visaMastercard',
            'amex',
            'tabby',
            'tamara',
            'stcpay',
            'urpay'
          ],
        )
        .then((orderDetails) => addInvoiceToList(orderDetails, true))
        .onError(
          (error, stackTrace) => navigateToInvoiceScreen(
            typeMsg: '[Add Invoice] API Error Response',
            errorMsg: error.toString(),
          ),
        );
  }

  /// --- 3. Paylink: Get Invoice Function
  void getInvoice(String transactionNo) {
    paylink
        .getInvoice(transactionNo: transactionNo)
        .then(
          (orderDetails) => navigateToInvoiceScreen(
            typeMsg: '[Get Invoice] API Result',
            invoiceDetails: orderDetails,
          ),
        )
        .onError(
          (error, stackTrace) => navigateToInvoiceScreen(
            typeMsg: '[Get Invoice] API Error Response',
            errorMsg: error.toString(),
          ),
        );
  }

  /// --- 4. Paylink: Checkout Invoice
  void checkout(String transactionNo) {
    paylink.openPaymentForm(
      transactionNo: transactionNo,
      onPaymentComplete: (orderDetails) => navigateToInvoiceScreen(
        typeMsg: '[Checkout Invoice] API Result',
        invoiceDetails: orderDetails,
      ),
      onError: (error) => navigateToInvoiceScreen(
        typeMsg: '[Checkout Invoice] API Error Response',
        errorMsg: error.toString(),
      ),
    );
  }

  /// --- 5. Paylink: Cancel Invoice
  void cancelInvoice(String transactionNo) {
    paylink
        .cancelInvoice(transactionNo: transactionNo)
        .then((_) => setCancelResponse('Canceled Successfully'))
        .onError((error, stackTrace) => setCancelResponse(error.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        addInvoiceAction: () => addInvoice(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (Map<String, dynamic> invoice in invoiceList)
              InvoiceRow(
                invoice: invoice,
                getInvoice: getInvoice,
                cancelInvoice: cancelInvoice,
                checkout: checkout,
              )
          ],
        ),
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        paymentResponseMessage: paymentResponseMessage ?? '',
        setCancelResponse: setCancelResponse,
      ),
    );
  }

  /// Example function: not related to paylink package
  void navigateToInvoiceScreen({
    Map<String, dynamic>? invoiceDetails,
    String? typeMsg,
    String? errorMsg,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvoiceScreen(
          invoiceDetails: invoiceDetails,
          typeMsg: typeMsg,
          errorMsg: errorMsg,
        ),
      ),
    );
  }

  /// Example function: not related to paylink package
  void setCancelResponse(String response) {
    setState(() => paymentResponseMessage = response);
  }

  /// Example function: not related to paylink package
  void addPendingInvoiceForTesting() {
    paylink.addInvoice(
      amount: 180.0,
      clientMobile: '0512345678',
      clientName: 'Mohammed',
      orderNumber: '123456789',
      callBackUrl: 'https://example.com',
      products: [],
    ).then(
      (invoiceDetails) => addInvoiceToList(invoiceDetails, false),
    );
  }

  /// Example function: not related to paylink package
  void addInvoiceToList(invoiceDetails, bool withNavigate) {
    setState(() {
      invoiceList.add(
        {
          'label': '${invoiceDetails['orderStatus']} Invoice',
          'transactionNo': invoiceDetails['transactionNo'],
        },
      );
    });

    if (withNavigate) {
      navigateToInvoiceScreen(
        typeMsg: '[Add Invoice] API Result',
        invoiceDetails: invoiceDetails,
      );
    }
  }
}
