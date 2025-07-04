class Device {
  final String deviceId;
  final String? name;
  final String? location;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  Device({
    required this.deviceId,
    this.name,
    this.location,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    DateTime parseTimestamp(dynamic timestamp) {
      if (timestamp == null) return DateTime.now();
      
      if (timestamp is int) {
        // Se é um timestamp em milissegundos
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      } else if (timestamp is String) {
        // Se é uma string de data
        return DateTime.parse(timestamp);
      }
      
      return DateTime.now();
    }

    return Device(
      deviceId: json['device_id'],
      name: json['name'],
      location: json['location'],
      description: json['description'],
      createdAt: parseTimestamp(json['created_at']),
      updatedAt: parseTimestamp(json['updated_at']),
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,
      'name': name,
      'location': location,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_active': isActive,
    };
  }

  Device copyWith({
    String? deviceId,
    String? name,
    String? location,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return Device(
      deviceId: deviceId ?? this.deviceId,
      name: name ?? this.name,
      location: location ?? this.location,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
} 