class UserPoints {
  final int totalPoints;
  final double inrValue;
  final List<PointsTransaction> transactions;

  UserPoints({
    required this.totalPoints,
    required this.inrValue,
    required this.transactions,
  });

  factory UserPoints.fromJson(Map<String, dynamic> json) {
    return UserPoints(
      totalPoints: json['totalPoints'] as int,
      inrValue: (json['inrValue'] as num).toDouble(),
      transactions: (json['transactions'] as List<dynamic>)
          .map((e) => PointsTransaction.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalPoints': totalPoints,
      'inrValue': inrValue,
      'transactions': transactions.map((e) => e.toJson()).toList(),
    };
  }
}

class PointsTransaction {
  final String id;
  final int points;
  final String type; // 'earned', 'withdrawn', 'bonus'
  final String description;
  final DateTime timestamp;

  PointsTransaction({
    required this.id,
    required this.points,
    required this.type,
    required this.description,
    required this.timestamp,
  });

  factory PointsTransaction.fromJson(Map<String, dynamic> json) {
    return PointsTransaction(
      id: json['id'] as String,
      points: json['points'] as int,
      type: json['type'] as String,
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'points': points,
      'type': type,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
