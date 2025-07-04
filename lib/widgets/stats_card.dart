import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_alex_flutter/models/sensor_data.dart';
import 'package:projeto_alex_flutter/utils/app_theme.dart';

class StatsCard extends StatelessWidget {
  final DeviceStats stats;

  const StatsCard({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.analytics,
                  size: 32,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Estatísticas Gerais',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    '${stats.totalReadings} leituras',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Estatísticas de umidade
            _buildSection(
              title: 'Umidade do Solo',
              icon: Icons.water_drop,
              color: AppTheme.humidityGood,
              stats: [
                _buildStatItem('Média', '${stats.avgHumidity.toStringAsFixed(1)}%'),
                _buildStatItem('Mínima', '${stats.minHumidity.toStringAsFixed(1)}%'),
                _buildStatItem('Máxima', '${stats.maxHumidity.toStringAsFixed(1)}%'),
              ],
            ),

            const SizedBox(height: 20),

            // Estatísticas de temperatura
            _buildSection(
              title: 'Temperatura',
              icon: Icons.thermostat,
              color: AppTheme.tempGood,
              stats: [
                _buildStatItem('Média', '${stats.avgTemperature.toStringAsFixed(1)}°C'),
                _buildStatItem('Mínima', '${stats.minTemperature.toStringAsFixed(1)}°C'),
                _buildStatItem('Máxima', '${stats.maxTemperature.toStringAsFixed(1)}°C'),
              ],
            ),

            const SizedBox(height: 20),

            // Informações de período
            const Divider(),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.calendar_today,
                    label: 'Primeira Leitura',
                    value: DateFormat('dd/MM/yyyy HH:mm').format(stats.firstReading),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.access_time,
                    label: 'Última Leitura',
                    value: DateFormat('dd/MM/yyyy HH:mm').format(stats.lastReading),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Período de monitoramento
            _buildInfoItem(
              icon: Icons.timer,
              label: 'Período de Monitoramento',
              value: _formatDuration(stats.lastReading.difference(stats.firstReading)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> stats,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: stats,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;

    if (days > 0) {
      return '${days}d ${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
} 