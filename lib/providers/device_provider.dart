import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:projeto_alex_flutter/models/device.dart';
import 'package:projeto_alex_flutter/models/sensor_data.dart';
import 'package:projeto_alex_flutter/services/api_service.dart';

class DeviceProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  // Estado do dispositivo
  Device? _currentDevice;
  SensorData? _deviceData;
  DeviceStats? _deviceStats;
  PumpStatus _pumpStatus = PumpStatus();
  
  // Estado da aplicação
  bool _isLoading = false;
  bool _isConnected = false;
  String? _error;
  Timer? _updateTimer;
  
  // Getters
  Device? get currentDevice => _currentDevice;
  SensorData? get deviceData => _deviceData;
  DeviceStats? get deviceStats => _deviceStats;
  PumpStatus get pumpStatus => _pumpStatus;
  bool get isLoading => _isLoading;
  bool get isConnected => _isConnected;
  String? get error => _error;

  // Inicializar provider
  Future<void> initialize() async {
    await _loadSavedDevice();
  }

  // Carregar dispositivo salvo
  Future<void> _loadSavedDevice() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final deviceId = prefs.getString('saved_device_id');
      
      if (deviceId != null) {
        await connectToDevice(deviceId);
      }
    } catch (e) {
      print('Erro ao carregar dispositivo salvo: $e');
    }
  }

  // Conectar a um dispositivo
  Future<bool> connectToDevice(String deviceId) async {
    _setLoading(true);
    _clearError();

    try {
      // Verificar se dispositivo existe
      final device = await _apiService.getDevice(deviceId);
      if (device == null) {
        _setError('Dispositivo não encontrado');
        return false;
      }

      _currentDevice = device;
      _isConnected = true;

      // Salvar dispositivo
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_device_id', deviceId);

      // Carregar dados iniciais
      await _loadInitialData();

      // Iniciar atualizações automáticas
      _startAutoUpdate();

      notifyListeners();
      return true;
    } catch (e) {
      _setError('Erro ao conectar: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Carregar dados iniciais
  Future<void> _loadInitialData() async {
    if (_currentDevice == null) return;

    try {
      // Carregar dados em paralelo
      final futures = await Future.wait([
        _apiService.getLatestSensorData(_currentDevice!.deviceId),
        _apiService.getDeviceStats(_currentDevice!.deviceId),
        _apiService.getPumpStatus(_currentDevice!.deviceId),
      ]);

      _deviceData = futures[0] as SensorData?;
      _deviceStats = futures[1] as DeviceStats?;
      _pumpStatus = futures[2] as PumpStatus? ?? PumpStatus();

      notifyListeners();
    } catch (e) {
      print('Erro ao carregar dados iniciais: $e');
    }
  }

  // Atualizar dados do dispositivo
  Future<void> updateDeviceData() async {
    if (_currentDevice == null) return;

    try {
      // Atualizar dados em paralelo
      final futures = await Future.wait([
        _apiService.getLatestSensorData(_currentDevice!.deviceId),
        _apiService.getPumpStatus(_currentDevice!.deviceId),
      ]);

      _deviceData = futures[0] as SensorData?;
      _pumpStatus = futures[1] as PumpStatus? ?? _pumpStatus;

      notifyListeners();
    } catch (e) {
      print('Erro ao atualizar dados: $e');
      _setError('Erro ao atualizar dados');
    }
  }

  // Iniciar atualizações automáticas
  void _startAutoUpdate() {
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_isConnected) {
        updateDeviceData();
      }
    });
  }

  // Parar atualizações automáticas
  void _stopAutoUpdate() {
    _updateTimer?.cancel();
    _updateTimer = null;
  }

  // Controlar bomba (novo)
  Future<void> togglePump() async {
    if (_currentDevice == null) return;

    try {
      final activate = !_pumpStatus.isActive;
      final success = await _apiService.setPump(_currentDevice!.deviceId, activate);
      if (success) {
        // Atualizar status da bomba
        final newStatus = await _apiService.getPumpStatus(_currentDevice!.deviceId);
        if (newStatus != null) {
          _pumpStatus = newStatus;
          notifyListeners();
        }
      }
    } catch (e) {
      _setError('Erro ao controlar bomba: ${e.toString()}');
    }
  }

  // Desconectar dispositivo
  Future<void> disconnectDevice() async {
    _stopAutoUpdate();
    
    // Limpar dados salvos
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_device_id');

    // Limpar estado
    _currentDevice = null;
    _deviceData = null;
    _deviceStats = null;
    _pumpStatus = PumpStatus();
    _isConnected = false;
    _clearError();

    notifyListeners();
  }

  // Testar conectividade
  Future<bool> testConnection() async {
    try {
      return await _apiService.testConnection();
    } catch (e) {
      return false;
    }
  }

  // Métodos auxiliares
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }
} 