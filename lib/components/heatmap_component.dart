import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class HeatmapComponent extends StatelessWidget {
  final DateTime startDate;
  final Map<DateTime, int> datasets;

  const HeatmapComponent({
    super.key,
    required this.startDate,
    required this.datasets,
  });

  @override
  Widget build(BuildContext context) {
    return HeatMap(
      startDate: startDate,
      endDate: DateTime.now(),
      datasets: datasets,
      colorMode: ColorMode.color,
      defaultColor: Theme.of(context).colorScheme.secondary,
      textColor: Colors.white,
      showColorTip: false,
      showText: true,
      scrollable: true,
      size: 30,
      colorsets: {
        1: Colors.blue.shade200,
        2: Colors.blue.shade300,
        3: Colors.blue.shade400,
        4: Colors.blue.shade500,
        5: Colors.blue.shade600,
        6: Colors.blue.shade700,
        7: Colors.blue.shade800,
      },
    );
  }
}
