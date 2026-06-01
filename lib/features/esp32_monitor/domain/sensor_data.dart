class SensorData {
  final double? temperature;
  final double? humidity;
  final String status;

  SensorData({
    required this.temperature,
    required this.humidity,
    required this.status,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      temperature: json['temperature'] == null
          ? null
          : (json['temperature'] as num).toDouble(),
      humidity: json['humidity'] == null
          ? null
          : (json['humidity'] as num).toDouble(),
      status: json['status']?.toString() ?? 'unknown',
    );
  }
}
