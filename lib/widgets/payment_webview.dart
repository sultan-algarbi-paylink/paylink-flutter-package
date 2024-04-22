import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatefulWidget {
  /// Payment URLs
  final String initialUrl;
  final String callBackUrl;

  /// Webview theme settings
  final String webViewTitle;
  final Color textColor;
  final Color themeColor;

  /// Callback function to handle payment completion.
  ///
  /// [parameters] is a map containing callback parameters such as OrderNumber, TransactionNo, etc.
  final Function(Map<String, String> parameters) onPaymentCallbackReached;

  /// Constructor for PaymentWebView widget.
  ///
  /// [initialUrl] - The initial URL to load in the webview.
  /// [callBackUrl] - The callback URL used to detect payment completion.
  /// [onPaymentCallbackReached] - Callback function to handle payment completion.
  /// [webViewTitle] - The title of the webview.
  /// [textColor] - The text color used in the app.
  /// [themeColor] - The theme color used in the app.
  const PaymentWebView({
    super.key,
    required this.initialUrl,
    required this.callBackUrl,
    required this.onPaymentCallbackReached,
    required this.webViewTitle,
    required this.textColor,
    required this.themeColor,
  });

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  // Declare WebViewController instance
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    // Initialize WebViewController
    controller = WebViewController()
      ..setNavigationDelegate(
        NavigationDelegate(onUrlChange: onUrlChangeHandler),
      )
      ..loadRequest(Uri.parse(widget.initialUrl))
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  /// Handler for URL changes in the webview.
  ///
  /// [change] is the UrlChange containing information about the URL change.
  void onUrlChangeHandler(UrlChange change) {
    // Try parsing the new URL and the callback URL
    var parsedNewUrl = Uri.tryParse(change.url!);
    var parsedCallbackUrl = Uri.tryParse(widget.callBackUrl);

    // Check if parsing is successful
    if (parsedNewUrl != null && parsedCallbackUrl != null) {
      var baseUrl = Uri(
        scheme: parsedNewUrl.scheme,
        host: parsedNewUrl.host,
        path: parsedNewUrl.path,
      ).toString();
      var baseCallbackUrl = Uri(
        scheme: parsedCallbackUrl.scheme,
        host: parsedCallbackUrl.host,
        path: parsedCallbackUrl.path,
      ).toString();

      // Check if the URL contains the base callback URL
      if (baseUrl.contains(baseCallbackUrl)) {
        // Extract callback parameters from the URL
        var callBackParams = parsedNewUrl.queryParameters;
        // Call the callback function with the extracted parameters
        widget.onPaymentCallbackReached(callBackParams);
        // Close the webview after the callback is reached
        if (Navigator.canPop(context)) Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: widget.textColor),
        title: Text(
          widget.webViewTitle,
          style: TextStyle(color: widget.textColor),
        ),
        backgroundColor: widget.themeColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: WebViewWidget(
          controller: controller,
        ),
      ),
      bottomNavigationBar: Container(
        height: 40,
        color: widget.themeColor,
        child: Center(
          child: Text(
            'Powered By Paylink.sa',
            style: TextStyle(
              color: widget.textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
