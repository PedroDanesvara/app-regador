import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_alex_flutter/utils/app_theme.dart';

class HumidityCard extends StatelessWidget {
  final double? humidity;
  final DateTime? lastUpdate;

  const HumidityCard({
    super.key,
    this.humidity,
    this.lastUpdate,
  });

  Color _getHumidityColor(double? humidity) {
    if (humidity == null) return Colors.grey;
    if (humidity < 30) return AppTheme.humidityLow;
    if (humidity < 50) return AppTheme.humidityMedium;
    if (humidity < 70) return AppTheme.humidityGood;
    return AppTheme.humidityHigh;
  }

  String _getHumidityStatus(double? humidity) {
    if (humidity == null) return 'Sem dados';
    if (humidity < 30) return 'Muito seco';
    if (humidity < 50) return 'Seco';
    if (humidity < 70) return 'Ideal';
    return 'Úmido';
  }

  IconData _getHumidityIcon(double? humidity) {
    if (humidity == null) return Icons.water_drop_outlined;
    if (humidity < 30) return Icons.water_drop_outlined;
    if (humidity < 50) return Icons.water_drop;
    return Icons.water_drop;
  }

  @override
  Widget build(BuildContext context) {
    final humidityValue = humidity ?? 0.0;
    final color = _getHumidityColor(humidity);
    final status = _getHumidityStatus(humidity);
    final icon = _getHumidityIcon(humidity);

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
                  icon,
                  size: 32,
                  color: color,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Umidade do Solo',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Valor principal
            Center(
              child: Text(
                humidity != null ? '${humidity!.toStringAsFixed(1)}%' : '--',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Barra de progresso
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: humidity != null ? (humidityValue / 100).clamp(0.0, 1.0) : 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Escala de valores
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '0%',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '50%',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '100%',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),

            // Informações adicionais
            if (lastUpdate != null) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Atualizado: ${DateFormat('HH:mm:ss').format(lastUpdate!)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
} 