import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projeto_alex_flutter/providers/device_provider.dart';
import 'package:projeto_alex_flutter/screens/monitoring_screen.dart';
import 'package:projeto_alex_flutter/utils/app_theme.dart';

class DeviceConnectionScreen extends StatefulWidget {
  const DeviceConnectionScreen({super.key});

  @override
  State<DeviceConnectionScreen> createState() => _DeviceConnectionScreenState();
}

class _DeviceConnectionScreenState extends State<DeviceConnectionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _deviceIdController = TextEditingController();
  bool _isConnecting = false;

  @override
  void dispose() {
    _deviceIdController.dispose();
    super.dispose();
  }

  Future<void> _connectToDevice() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isConnecting = true;
    });

    try {
      final deviceProvider = Provider.of<DeviceProvider>(context, listen: false);
      final success = await deviceProvider.connectToDevice(_deviceIdController.text.trim());

      if (success && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MonitoringScreen()),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isConnecting = false;
        });
      }
    }
  }

  Future<void> _testConnection() async {
    final deviceProvider = Provider.of<DeviceProvider>(context, listen: false);
    final isConnected = await deviceProvider.testConnection();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isConnected 
                ? 'Conexão com a API estabelecida com sucesso!'
                : 'Erro ao conectar com a API. Verifique se o servidor está rodando.',
          ),
          backgroundColor: isConnected ? Colors.green : Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Header
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Ícone
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.wifi,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Título
                    const Text(
                      'Conectar Dispositivo',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    const Text(
                      'Digite o ID do seu dispositivo ESP32 para começar o monitoramento',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Formulário
              Expanded(
                flex: 1,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Campo de ID do dispositivo
                      TextFormField(
                        controller: _deviceIdController,
                        decoration: const InputDecoration(
                          labelText: 'ID do Dispositivo',
                          hintText: 'Ex: ESP32_001',
                          prefixIcon: Icon(Icons.device_hub),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Por favor, digite o ID do dispositivo';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _connectToDevice(),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Botão de conexão
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isConnecting ? null : _connectToDevice,
                          child: _isConnecting
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text('Conectando...'),
                                  ],
                                )
                              : const Text(
                                  'Conectar',
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Botão de teste de conexão
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton.icon(
                          onPressed: _testConnection,
                          icon: const Icon(Icons.wifi_find),
                          label: const Text('Testar Conexão'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Footer
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Informações de ajuda
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.blue),
                              SizedBox(width: 8),
                              Text(
                                'Dicas de Conexão',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '• Certifique-se de que o ESP32 está ligado e conectado à rede WiFi\n'
                            '• Verifique se a API está rodando no servidor\n'
                            '• O ID do dispositivo deve corresponder ao configurado no ESP32',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 