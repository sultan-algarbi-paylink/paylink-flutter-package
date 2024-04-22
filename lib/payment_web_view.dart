import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class PaymentWebView extends StatefulWidget {
  final String initialUrl;
  final String callbackUrl;
  final Function(Map<String, dynamic>) onCallbackReached;

  const PaymentWebView({super.key, required this.initialUrl, required this.callbackUrl, required this.onCallbackReached});

  @override
  PaymentWebViewState createState() => PaymentWebViewState();
}

class PaymentWebViewState extends State<PaymentWebView> {
  final flutterWebviewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (url == widget.callbackUrl) {
        var uri = Uri.parse(url);
        var data = <String, dynamic>{};
        if (uri.queryParameters.containsKey('orderNumber') && uri.queryParameters.containsKey('transactionNo')) {
          data = {
            'externalOrderNumber': uri.queryParameters['orderNumber'],
            'orderNumber': uri.queryParameters['transactionNo'],
          };
        }

        widget.onCallbackReached(data);
        flutterWebviewPlugin.close();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.initialUrl,
      appBar: AppBar(title: const Text('Payment')),
    );
  }

  @override
  void dispose() {
    flutterWebviewPlugin.dispose();
    super.dispose();
  }
}
