import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:projeto_alex_flutter/models/device.dart';
import 'package:projeto_alex_flutter/models/sensor_data.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';
  // Para teste em dispositivo físico, use o IP da sua máquina
  // static const String baseUrl = 'http://192.168.1.100:3000/api';

  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // Interceptors para logs
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('API Request: ${options.method} ${options.path}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        print('API Response: ${response.statusCode} ${response.requestOptions.path}');
        handler.next(response);
      },
      onError: (error, handler) {
        print('API Error: ${error.response?.statusCode} ${error.requestOptions.path}');
        print('Error: ${error.response?.data ?? error.message}');
        handler.next(error);
      },
    ));
  }

  // RF008: Verificar se dispositivo existe
  Future<Device?> getDevice(String deviceId) async {
    try {
      final response = await _dio.get('/devices/$deviceId');
      return Device.fromJson(response.data['data']);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return null; // Dispositivo não encontrado
      }
      rethrow;
    }
  }

  // RF009: Buscar dados mais recentes do sensor
  Future<SensorData?> getLatestSensorData(String deviceId) async {
    try {
      final response = await _dio.get('/sensors', queryParameters: {
        'device_id': deviceId,
        'limit': 1,
        'order': 'desc',
      });
      
      final data = response.data['data'] as List;
      if (data.isNotEmpty) {
        return SensorData.fromJson(data.first);
      }
      return null;
    } catch (e) {
      print('Erro ao buscar dados do sensor: $e');
      rethrow;
    }
  }

  // RF009: Buscar estatísticas do dispositivo
  Future<DeviceStats?> getDeviceStats(String deviceId) async {
    try {
      final response = await _dio.get('/devices/$deviceId/stats');
      return DeviceStats.fromJson(response.data['data']);
    } catch (e) {
      print('Erro ao buscar estatísticas: $e');
      rethrow;
    }
  }

  // Buscar histórico de dados
  Future<List<SensorData>> getSensorHistory(String deviceId, {int limit = 50}) async {
    try {
      final response = await _dio.get('/sensors', queryParameters: {
        'device_id': deviceId,
        'limit': limit,
        'order': 'desc',
      });
      
      final data = response.data['data'] as List;
      return data.map((json) => SensorData.fromJson(json)).toList();
    } catch (e) {
      print('Erro ao buscar histórico: $e');
      rethrow;
    }
  }

  // Buscar estatísticas gerais
  Future<Map<String, dynamic>?> getSensorStats(String deviceId) async {
    try {
      final response = await _dio.get('/sensors/stats/summary', queryParameters: {
        'device_id': deviceId,
      });
      return response.data['data'];
    } catch (e) {
      print('Erro ao buscar estatísticas dos sensores: $e');
      rethrow;
    }
  }

  // Listar todos os dispositivos
  Future<List<Device>> getDevices() async {
    try {
      final response = await _dio.get('/devices');
      final data = response.data['data'] as List;
      return data.map((json) => Device.fromJson(json)).toList();
    } catch (e) {
      print('Erro ao buscar dispositivos: $e');
      rethrow;
    }
  }

  // Health check da API
  Future<Map<String, dynamic>> healthCheck() async {
    try {
      final response = await _dio.get('/health');
      return response.data;
    } catch (e) {
      print('Erro no health check: $e');
      rethrow;
    }
  }

  // Teste de conectividade
  Future<bool> testConnection() async {
    try {
      await healthCheck();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Controle da bomba (novo)
  Future<bool> setPump(String deviceId, bool activate, {String reason = 'Controle via app', String triggeredBy = 'manual'}) async {
    try {
      final response = await _dio.post(
        '/pump/$deviceId/control',
        data: {
          'action': activate ? 'activate' : 'deactivate',
          'reason': reason,
          'triggered_by': triggeredBy,
        },
      );
      return response.data['success'] ?? false;
    } catch (e) {
      print('Erro ao controlar bomba: $e');
      rethrow;
    }
  }

  // Obter status da bomba (novo endpoint)
  Future<PumpStatus?> getPumpStatus(String deviceId) async {
    try {
      final response = await _dio.get('/pump/$deviceId/status');
      return PumpStatus.fromJson(response.data['data']);
    } catch (e) {
      print('Erro ao buscar status da bomba: $e');
      rethrow;
    }
  }
} 