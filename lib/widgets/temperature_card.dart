import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_alex_flutter/utils/app_theme.dart';

class TemperatureCard extends StatelessWidget {
  final double? temperature;
  final DateTime? lastUpdate;

  const TemperatureCard({
    super.key,
    this.temperature,
    this.lastUpdate,
  });

  Color _getTemperatureColor(double? temperature) {
    if (temperature == null) return Colors.grey;
    if (temperature < 15) return AppTheme.tempCold;
    if (temperature < 25) return AppTheme.tempGood;
    if (temperature < 35) return AppTheme.tempWarm;
    return AppTheme.tempHot;
  }

  String _getTemperatureStatus(double? temperature) {
    if (temperature == null) return 'Sem dados';
    if (temperature < 15) return 'Frio';
    if (temperature < 25) return 'Ideal';
    if (temperature < 35) return 'Quente';
    return 'Muito quente';
  }

  IconData _getTemperatureIcon(double? temperature) {
    if (temperature == null) return Icons.thermostat_outlined;
    if (temperature < 15) return Icons.ac_unit;
    if (temperature < 25) return Icons.thermostat;
    if (temperature < 35) return Icons.wb_sunny;
    return Icons.local_fire_department;
  }

  @override
  Widget build(BuildContext context) {
    final tempValue = temperature ?? 0.0;
    final color = _getTemperatureColor(temperature);
    final status = _getTemperatureStatus(temperature);
    final icon = _getTemperatureIcon(temperature);

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
                    'Temperatura',
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    temperature != null ? '${temperature!.toStringAsFixed(1)}' : '--',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '°C',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Termômetro visual
            Container(
              height: 120,
              width: double.infinity,
              child: Stack(
                children: [
                  // Termômetro de fundo
                  Positioned(
                    left: 20,
                    top: 10,
                    bottom: 10,
                    child: Container(
                      width: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  
                  // Preenchimento do termômetro
                  if (temperature != null)
                    Positioned(
                      left: 20,
                      bottom: 10,
                      child: Container(
                        width: 20,
                        height: _calculateThermometerHeight(tempValue),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  
                  // Escala de temperatura
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '40°C',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '30°C',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '20°C',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '10°C',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '0°C',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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

  double _calculateThermometerHeight(double temperature) {
    // Mapear temperatura de 0-40°C para altura do termômetro
    final maxHeight = 100.0; // Altura máxima do termômetro
    final normalizedTemp = (temperature / 40.0).clamp(0.0, 1.0);
    return normalizedTemp * maxHeight;
  }
} 