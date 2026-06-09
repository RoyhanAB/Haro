class ReceiptItem {
  const ReceiptItem({
    required this.id,
    required this.transactionId,
    required this.itemName,
    this.quantity,
    this.price,
    this.category,
  });

  final String id;
  final String transactionId;
  final String itemName;
  final int? quantity;
  final int? price;
  final String? category;
}
