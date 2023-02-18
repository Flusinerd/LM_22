class Setting {
  String name;
  String unit;
  int value;

  double minValue = 0;
  double maxValue = 5;

  Setting({
    required this.name,
    required this.unit,
    this.minValue = 0,
    this.maxValue = 5,
    this.value = 0,
  }) {
    if (value < minValue) {
      value = minValue.round();
    }
    if (value > maxValue) {
      value = maxValue.round();
    }
  }
}
