import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projeto_alex_flutter/models/sensor_data.dart';
import 'package:projeto_alex_flutter/utils/app_theme.dart';

class PumpControlCard extends StatelessWidget {
  final PumpStatus pumpStatus;
  final VoidCallback onTogglePump;

  const PumpControlCard({
    super.key,
    required this.pumpStatus,
    required this.onTogglePump,
  });

  String _formatDuration(Duration? duration) {
    if (duration == null) return '--';
    
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isActive = pumpStatus.isActive;
    final color = isActive ? AppTheme.primaryColor : Colors.grey;

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
                  isActive ? Icons.water : Icons.water_outlined,
                  size: 32,
                  color: color,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Controle da Bomba',
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
                    isActive ? 'Ativa' : 'Inativa',
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

            // Status principal
            Center(
              child: Column(
                children: [
                  Icon(
                    isActive ? Icons.water_drop : Icons.water_drop_outlined,
                    size: 64,
                    color: color,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isActive ? 'Bomba Ativa' : 'Bomba Inativa',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isActive 
                        ? 'Irrigação em andamento...'
                        : 'Aguardando ativação',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Botão de controle
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: onTogglePump,
                icon: Icon(
                  isActive ? Icons.stop : Icons.play_arrow,
                  color: Colors.white,
                ),
                label: Text(
                  isActive ? 'Desativar Bomba' : 'Ativar Bomba',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isActive ? Colors.red : AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Informações da sessão atual
            if (isActive && pumpStatus.currentSession != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.timer, color: AppTheme.primaryColor),
                        SizedBox(width: 8),
                        Text(
                          'Sessão Atual',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tempo ativo: ${_formatDuration(pumpStatus.currentSession)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Estatísticas
            const Divider(),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.history,
                    label: 'Total de Ativações',
                    value: '${pumpStatus.totalActivations}',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.access_time,
                    label: 'Última Ativação',
                    value: pumpStatus.lastActivated != null 
                        ? DateFormat('dd/MM HH:mm').format(pumpStatus.lastActivated!)
                        : 'Nunca',
                  ),
                ),
              ],
            ),

            if (pumpStatus.lastDeactivated != null) ...[
              const SizedBox(height: 12),
              _buildStatItem(
                icon: Icons.stop_circle,
                label: 'Última Desativação',
                value: DateFormat('dd/MM HH:mm').format(pumpStatus.lastDeactivated!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
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
} 