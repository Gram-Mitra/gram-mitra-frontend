class IotSensorData {
  final double soilMoisture; // Percentage 0 - 100%
  final double soilTemperature; // Celsius
  final int nitrogen; // mg/kg
  final int phosphorus; // mg/kg
  final int potassium; // mg/kg
  final bool isPumpOn;
  final int tankLevel; // Percentage 0 - 100%

  IotSensorData({
    this.soilMoisture = 68.0,
    this.soilTemperature = 24.5,
    this.nitrogen = 140,
    this.phosphorus = 45,
    this.potassium = 190,
    this.isPumpOn = false,
    this.tankLevel = 85,
  });

  IotSensorData copyWith({
    double? soilMoisture,
    double? soilTemperature,
    int? nitrogen,
    int? phosphorus,
    int? potassium,
    bool? isPumpOn,
    int? tankLevel,
  }) {
    return IotSensorData(
      soilMoisture: soilMoisture ?? this.soilMoisture,
      soilTemperature: soilTemperature ?? this.soilTemperature,
      nitrogen: nitrogen ?? this.nitrogen,
      phosphorus: phosphorus ?? this.phosphorus,
      potassium: potassium ?? this.potassium,
      isPumpOn: isPumpOn ?? this.isPumpOn,
      tankLevel: tankLevel ?? this.tankLevel,
    );
  }
}
