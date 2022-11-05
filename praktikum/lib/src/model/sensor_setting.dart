class SensorSetting {
  String title;
  bool value;
  double rate;

  SensorSetting({
    required this.title,
    this.value = false,
    this.rate = 1,
  });
}
