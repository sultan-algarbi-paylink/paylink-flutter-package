import 'package:paylink_payment/models/paylink_gateway_order_request.dart';

class PaylinkInvoice {
  final PaylinkGatewayOrderRequest gatewayOrderRequest;
  final double amount;
  final String transactionNo;
  final String orderStatus;
  final dynamic paymentErrors; // Consider using a specific type if known
  final String url;
  final String qrUrl;
  final String mobileUrl;
  final String checkUrl;
  final bool success;
  final bool digitalOrder;
  final dynamic foreignCurrencyRate; // Consider using a specific type if known
  final dynamic paymentReceipt; // Consider using a specific type if known
  final dynamic metadata; // Consider using a specific type if known

  PaylinkInvoice({
    required this.gatewayOrderRequest,
    required this.amount,
    required this.transactionNo,
    required this.orderStatus,
    this.paymentErrors,
    required this.url,
    required this.qrUrl,
    required this.mobileUrl,
    required this.checkUrl,
    required this.success,
    required this.digitalOrder,
    this.foreignCurrencyRate,
    this.paymentReceipt,
    this.metadata,
  });

  factory PaylinkInvoice.fromResponseData(Map<String, dynamic> data) {
    return PaylinkInvoice(
      gatewayOrderRequest:
          PaylinkGatewayOrderRequest.fromMap(data['gatewayOrderRequest'] ?? {}),
      amount: data['amount'] ?? 0.0,
      transactionNo: data['transactionNo'] ?? '',
      orderStatus: data['orderStatus'] ?? '',
      paymentErrors: data['paymentErrors'],
      url: data['url'] ?? '',
      qrUrl: data['qrUrl'] ?? '',
      mobileUrl: data['mobileUrl'] ?? '',
      checkUrl: data['checkUrl'] ?? '',
      success: data['success'] ?? false,
      digitalOrder: data['digitalOrder'] ?? false,
      foreignCurrencyRate: data['foreignCurrencyRate'],
      paymentReceipt: data['paymentReceipt'],
      metadata: data['metadata'],
    );
  }
}
