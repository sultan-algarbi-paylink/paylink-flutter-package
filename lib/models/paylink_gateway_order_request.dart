import 'package:paylink_payment/models/paylink_product.dart';

class PaylinkGatewayOrderRequest {
  final double amount;
  final String orderNumber;
  final String callBackUrl;
  final String clientEmail;
  final String clientName;
  final String clientMobile;
  final String note;
  final String cancelUrl;
  final List<PaylinkProduct> products;
  final List<String> supportedCardBrands;
  final String currency;
  final String smsMessage;
  final bool displayPending;
  final dynamic receivers; // Consider using a specific type if known
  final dynamic partnerPortion; // Consider using a specific type if known
  final dynamic metadata; // Consider using a specific type if known

  PaylinkGatewayOrderRequest({
    required this.amount,
    required this.orderNumber,
    required this.callBackUrl,
    required this.clientEmail,
    required this.clientName,
    required this.clientMobile,
    required this.note,
    required this.cancelUrl,
    required this.products,
    required this.supportedCardBrands,
    required this.currency,
    required this.smsMessage,
    required this.displayPending,
    this.receivers,
    this.partnerPortion,
    this.metadata,
  });

  factory PaylinkGatewayOrderRequest.fromMap(Map<String, dynamic> data) {
    List<PaylinkProduct> products =
        (data['products'] as List<Map<String, dynamic>>?)
                ?.map((product) => PaylinkProduct.fromMap(product))
                .toList() ??
            [];

    return PaylinkGatewayOrderRequest(
      amount: data['amount'] ?? 0.0,
      orderNumber: data['orderNumber'] ?? '',
      callBackUrl: data['callBackUrl'] ?? '',
      clientEmail: data['clientEmail'] ?? '',
      clientName: data['clientName'] ?? '',
      clientMobile: data['clientMobile'] ?? '',
      note: data['note'] ?? '',
      cancelUrl: data['cancelUrl'] ?? '',
      products: products,
      supportedCardBrands: List<String>.from(data['supportedCardBrands'] ?? []),
      currency: data['currency'] ?? '',
      smsMessage: data['smsMessage'] ?? '',
      displayPending: data['displayPending'] ?? true,
      receivers: data['receivers'],
      partnerPortion: data['partnerPortion'],
      metadata: data['metadata'],
    );
  }
}
