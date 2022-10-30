import 'dart:ffi';

import 'package:flutter/foundation.dart';

class SensorData {
  final double value;
  final DateTime timestamp;
  final SensorMetadata metadata;

  const SensorData(this.value, this.timestamp, this.metadata);

  Map<String, dynamic> toJson() => {
        'value': value,
        // Format timestamp as JSON ISO 8601 string
        'timestamp': timestamp.toUtc().toIso8601String(),
        'metadata': metadata.toJson(),
      };
}

class SensorMetadata {
  final String sensor_type;

  const SensorMetadata(this.sensor_type);

  Map<String, dynamic> toJson() => {
        'sensor_type': sensor_type,
      };
}
