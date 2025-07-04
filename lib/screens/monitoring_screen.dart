import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:projeto_alex_flutter/providers/device_provider.dart';
import 'package:projeto_alex_flutter/screens/device_connection_screen.dart';
import 'package:projeto_alex_flutter/utils/app_theme.dart';
import 'package:projeto_alex_flutter/widgets/humidity_card.dart';
import 'package:projeto_alex_flutter/widgets/temperature_card.dart';
import 'package:projeto_alex_flutter/widgets/pump_control_card.dart';
import 'package:projeto_alex_flutter/widgets/stats_card.dart';

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({super.key});

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Consumer<DeviceProvider>(
        builder: (context, deviceProvider, child) {
          if (deviceProvider.currentDevice == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await deviceProvider.updateDeviceData();
            },
            child: CustomScrollView(
              slivers: [
                // App Bar customizada
                SliverAppBar(
                  expandedHeight: 120,
                  floating: false,
                  pinned: true,
                  backgroundColor: AppTheme.primaryColor,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      deviceProvider.currentDevice!.name ?? 
                      deviceProvider.currentDevice!.deviceId,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppTheme.primaryColor,
                            AppTheme.primaryDarkColor,
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        deviceProvider.currentDevice!.location ?? 
                                        'Localização não definida',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Última atualização: ${_formatLastUpdate()}',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: _showDisconnectDialog,
                                  icon: const Icon(
                                    Icons.wifi_off,
                                    color: Colors.white,
                                  ),
                                  tooltip: 'Desconectar',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () => deviceProvider.updateDeviceData(),
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      tooltip: 'Atualizar',
                    ),
                  ],
                ),

                // Conteúdo principal
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Indicador de erro
                      if (deviceProvider.error != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error, color: Colors.red),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  deviceProvider.error!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Card de umidade
                      HumidityCard(
                        humidity: deviceProvider.deviceData?.umidadeSolo,
                        lastUpdate: deviceProvider.deviceData?.timestamp,
                      ),

                      const SizedBox(height: 16),

                      // Card de temperatura
                      TemperatureCard(
                        temperature: deviceProvider.deviceData?.temperatura,
                        lastUpdate: deviceProvider.deviceData?.timestamp,
                      ),

                      const SizedBox(height: 16),

                      // Card de controle da bomba
                      PumpControlCard(
                        pumpStatus: deviceProvider.pumpStatus,
                        onTogglePump: _showPumpToggleDialog,
                      ),

                      const SizedBox(height: 16),

                      // Card de estatísticas
                      if (deviceProvider.deviceStats != null)
                        StatsCard(stats: deviceProvider.deviceStats!),

                      const SizedBox(height: 32),
                    ]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatLastUpdate() {
    final deviceProvider = Provider.of<DeviceProvider>(context, listen: false);
    final lastUpdate = deviceProvider.deviceData?.timestamp;
    
    if (lastUpdate == null) {
      return 'Nunca';
    }

    final now = DateTime.now();
    final difference = now.difference(lastUpdate);

    if (difference.inSeconds < 60) {
      return 'Agora';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m atrás';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h atrás';
    } else {
      return DateFormat('dd/MM HH:mm').format(lastUpdate);
    }
  }

  void _showDisconnectDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Desconectar Dispositivo'),
        content: const Text(
          'Tem certeza que deseja desconectar o dispositivo? '
          'Todos os dados em cache serão limpos.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final deviceProvider = Provider.of<DeviceProvider>(context, listen: false);
              await deviceProvider.disconnectDevice();
              if (mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const DeviceConnectionScreen()),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Desconectar'),
          ),
        ],
      ),
    );
  }

  void _showPumpToggleDialog() {
    final deviceProvider = Provider.of<DeviceProvider>(context, listen: false);
    final isActive = deviceProvider.pumpStatus.isActive;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isActive ? 'Desativar Bomba' : 'Ativar Bomba'),
        content: Text(
          isActive
              ? 'Tem certeza que deseja desativar a bomba de irrigação?'
              : 'Tem certeza que deseja ativar a bomba de irrigação?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await deviceProvider.togglePump();
            },
            child: Text(isActive ? 'Desativar' : 'Ativar'),
          ),
        ],
      ),
    );
  }
} 