class SensorData {
  final int id;
  final String deviceId;
  final double? umidadeSolo;
  final double? temperatura;
  final DateTime timestamp;
  final String? status;

  SensorData({
    required this.id,
    required this.deviceId,
    this.umidadeSolo,
    this.temperatura,
    required this.timestamp,
    this.status,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
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

    return SensorData(
      id: json['id'],
      deviceId: json['device_id'],
      umidadeSolo: json['umidade_solo']?.toDouble(),
      temperatura: json['temperatura']?.toDouble(),
      timestamp: parseTimestamp(json['created_at'] ?? json['timestamp']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device_id': deviceId,
      'umidade_solo': umidadeSolo,
      'temperatura': temperatura,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
    };
  }
}

class DeviceStats {
  final String deviceId;
  final int totalReadings;
  final double avgHumidity;
  final double avgTemperature;
  final double minHumidity;
  final double maxHumidity;
  final double minTemperature;
  final double maxTemperature;
  final DateTime lastReading;
  final DateTime firstReading;

  DeviceStats({
    required this.deviceId,
    required this.totalReadings,
    required this.avgHumidity,
    required this.avgTemperature,
    required this.minHumidity,
    required this.maxHumidity,
    required this.minTemperature,
    required this.maxTemperature,
    required this.lastReading,
    required this.firstReading,
  });

  factory DeviceStats.fromJson(Map<String, dynamic> json) {
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

    return DeviceStats(
      deviceId: json['device_id'],
      totalReadings: json['total_readings'] ?? 0,
      avgHumidity: json['avg_umidade']?.toDouble() ?? 0.0,
      avgTemperature: json['avg_temperatura']?.toDouble() ?? 0.0,
      minHumidity: json['min_umidade']?.toDouble() ?? 0.0,
      maxHumidity: json['max_umidade']?.toDouble() ?? 0.0,
      minTemperature: json['min_temperatura']?.toDouble() ?? 0.0,
      maxTemperature: json['max_temperatura']?.toDouble() ?? 0.0,
      lastReading: parseTimestamp(json['last_reading']),
      firstReading: parseTimestamp(json['first_reading']),
    );
  }
}

class PumpStatus {
  final bool isActive;
  final DateTime? lastActivated;
  final DateTime? lastDeactivated;
  final int totalActivations;
  final Duration? currentSession;

  PumpStatus({
    this.isActive = false,
    this.lastActivated,
    this.lastDeactivated,
    this.totalActivations = 0,
    this.currentSession,
  });

  factory PumpStatus.fromJson(Map<String, dynamic> json) {
    DateTime? parseTimestamp(dynamic timestamp) {
      if (timestamp == null) return null;
      
      if (timestamp is int) {
        // Se é um timestamp em milissegundos
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      } else if (timestamp is String) {
        // Se é uma string de data
        return DateTime.parse(timestamp);
      }
      
      return null;
    }

    return PumpStatus(
      isActive: json['is_active'] ?? false,
      lastActivated: parseTimestamp(json['last_activated']),
      lastDeactivated: parseTimestamp(json['last_deactivated']),
      totalActivations: json['total_activations'] ?? 0,
      currentSession: json['duration_seconds'] != null 
          ? Duration(seconds: json['duration_seconds'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_active': isActive,
      'last_activated': lastActivated?.toIso8601String(),
      'last_deactivated': lastDeactivated?.toIso8601String(),
      'total_activations': totalActivations,
      'current_session_seconds': currentSession?.inSeconds,
    };
  }
} 