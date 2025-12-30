class Ad {
  final String id;
  final String companyId;
  final String companyName;
  final String videoUrl;
  final String title;
  final String description;
  final String? thumbnailUrl;
  final String? ctaText;
  final String? targetUrl;
  final bool isActive;
  final int order;
  final DateTime createdAt;
  
  // NEW: Analytics fields
  final int likes;
  final bool isLiked; // Has current user liked this ad
  final String network; // 'admob', 'unity', 'meta'

  Ad({
    required this.id,
    required this.companyId,
    required this.companyName,
    required this.videoUrl,
    required this.title,
    required this.description,
    this.thumbnailUrl,
    this.ctaText,
    this.targetUrl,
    required this.isActive,
    required this.order,
    required this.createdAt,
    this.likes = 0,
    this.isLiked = false,
    this.network = 'admob',
  });

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      id: json['id'] as String,
      companyId: json['companyId'] as String? ?? '1',
      companyName: json['companyName'] as String? ?? 'Unknown',
      videoUrl: json['videoUrl'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      ctaText: json['ctaText'] as String?,
      targetUrl: json['targetUrl'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      order: json['order'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyId': companyId,
      'companyName': companyName,
      'videoUrl': videoUrl,
      'title': title,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'ctaText': ctaText,
      'targetUrl': targetUrl,
      'isActive': isActive,
      'order': order,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
