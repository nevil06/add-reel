class Company {
  final String id;
  final String name;
  final String email;
  final double commissionRate;
  final bool isActive;
  final CompanyBranding? branding;
  final DateTime createdAt;
  final DateTime updatedAt;

  Company({
    required this.id,
    required this.name,
    required this.email,
    required this.commissionRate,
    required this.isActive,
    this.branding,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      commissionRate: (json['commissionRate'] as num).toDouble(),
      isActive: json['isActive'] as bool? ?? true,
      branding: json['branding'] != null
          ? CompanyBranding.fromJson(json['branding'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'commissionRate': commissionRate,
      'isActive': isActive,
      'branding': branding?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class CompanyBranding {
  final String? logo;
  final String? primaryColor;
  final String? secondaryColor;

  CompanyBranding({
    this.logo,
    this.primaryColor,
    this.secondaryColor,
  });

  factory CompanyBranding.fromJson(Map<String, dynamic> json) {
    return CompanyBranding(
      logo: json['logo'] as String?,
      primaryColor: json['primaryColor'] as String?,
      secondaryColor: json['secondaryColor'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'logo': logo,
      'primaryColor': primaryColor,
      'secondaryColor': secondaryColor,
    };
  }
}
