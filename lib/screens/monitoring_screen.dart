import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/device_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/humidity_card.dart';
import '../widgets/pump_control_card.dart';
import '../widgets/stats_card.dart';
import 'device_connection_screen.dart';

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
                  expandedHeight: 140,
                  floating: false,
                  pinned: true,
                  backgroundColor: AppTheme.primaryColor,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    collapseMode: CollapseMode.parallax,
                    titlePadding: const EdgeInsets.only(bottom: 8),
                    title: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            deviceProvider.currentDevice!.name ?? deviceProvider.currentDevice!.deviceId,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black54,
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (deviceProvider.currentDevice?.location != null)
                            Text(
                              deviceProvider.currentDevice!.location!,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                shadows: [
                                  Shadow(
                                    color: Colors.black45,
                                    offset: Offset(0, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          Text(
                            'Última atualização: ${_formatLastUpdate()}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              shadows: [
                                Shadow(
                                  color: Colors.black45,
                                  offset: Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
                    IconButton(
                      onPressed: () {
                        deviceProvider.logout();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const DeviceConnectionScreen()),
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.logout, color: Colors.white),
                      tooltip: 'Sair',
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