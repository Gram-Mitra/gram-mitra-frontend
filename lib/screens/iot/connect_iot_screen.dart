import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/app_state_provider.dart';

class ConnectIotScreen extends StatelessWidget {
  const ConnectIotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);
    final data = appState.iotData;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Connect IoT • Smart Farm',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.borderSubtle),
              ),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.statusSuccess,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Node #1 • Field Sensor Active',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Live Telemetry',
                    style: TextStyle(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Soil Moisture Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Soil Moisture',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.primaryGreen.withOpacity(0.2) : AppColors.lightMint,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Optimal Range',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? const Color(0xFF81C784) : AppColors.primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        '${data.soilMoisture.toInt()}%',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: isDark ? const Color(0xFF81C784) : AppColors.primaryGreen,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: data.soilMoisture / 100,
                                minHeight: 12,
                                backgroundColor: isDark ? AppColors.darkBorder : AppColors.borderSubtle,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isDark ? const Color(0xFF81C784) : AppColors.primaryGreen,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Target for Rice/Kolam: 60 - 80%',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Smart Irrigation Pump Controller Switch
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: data.isPumpOn
                    ? (isDark ? const Color(0xFF1B3D23) : const Color(0xFFE8F5E9))
                    : (isDark ? AppColors.darkCard : Colors.white),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: data.isPumpOn
                      ? AppColors.primaryGreen
                      : (isDark ? AppColors.darkBorder : AppColors.borderSubtle),
                  width: data.isPumpOn ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: data.isPumpOn
                          ? AppColors.primaryGreen
                          : (isDark ? AppColors.darkSurface : const Color(0xFFF5F5F5)),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.water_drop_rounded,
                      color: data.isPumpOn
                          ? Colors.white
                          : (isDark ? AppColors.darkTextSecondary : AppColors.textMuted),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Borewell Irrigation Pump',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data.isPumpOn ? 'Pumping water to Field A' : 'Pump is currently OFF',
                          style: TextStyle(
                            fontSize: 12,
                            color: data.isPumpOn
                                ? (isDark ? const Color(0xFF81C784) : AppColors.primaryGreen)
                                : (isDark ? AppColors.darkTextSecondary : AppColors.textMuted),
                            fontWeight: data.isPumpOn ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: data.isPumpOn,
                    activeColor: AppColors.primaryGreen,
                    onChanged: (val) {
                      appState.togglePump();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Soil Telemetry (Temp, N, P, K)
            Text(
              'Field Nutrients & Soil Stats',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricTile(
                    label: 'Soil Temp',
                    value: '${data.soilTemperature}°C',
                    icon: Icons.thermostat_outlined,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricTile(
                    label: 'Water Tank',
                    value: '${data.tankLevel}% Full',
                    icon: Icons.water_damage_outlined,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildNutrientTile('N (Nitrogen)', '${data.nitrogen} mg/kg', isDark)),
                const SizedBox(width: 8),
                Expanded(child: _buildNutrientTile('P (Phosphorus)', '${data.phosphorus} mg/kg', isDark)),
                const SizedBox(width: 8),
                Expanded(child: _buildNutrientTile('K (Potassium)', '${data.potassium} mg/kg', isDark)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required IconData icon,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: isDark ? const Color(0xFF81C784) : AppColors.primaryGreen, size: 22),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              maxLines: 1,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textCharcoal,
              ),
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              maxLines: 1,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientTile(String label, String value, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.borderSubtle),
      ),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              maxLines: 1,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isDark ? const Color(0xFF81C784) : AppColors.primaryGreen,
              ),
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                fontSize: 10,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
