class TransactionReport {
  final int id;
  final String pembelianId;
  final String status;
  final double totalPrice;
  final String createdAt;

  TransactionReport({
    required this.id,
    required this.pembelianId,
    required this.status,
    required this.totalPrice,
    required this.createdAt,
  });

  factory TransactionReport.fromJson(Map<String, dynamic> json) {
    return TransactionReport(
      id: json['id'],
      pembelianId: json['pembelian_id'],
      status: json['status'],
      totalPrice: json['total_price'].toDouble(),
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pembelian_id': pembelianId,
      'status': status,
      'total_price': totalPrice,
      'created_at': createdAt,
    };
  }
}
