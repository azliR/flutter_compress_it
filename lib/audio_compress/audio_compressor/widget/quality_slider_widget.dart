import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class QualitySlider extends StatefulWidget {
  const QualitySlider({
    required this.initialValue,
    required this.onChanged,
    super.key,
  });

  final double initialValue;
  final void Function(double value) onChanged;

  @override
  State<QualitySlider> createState() => _QualitySliderState();
}

class _QualitySliderState extends State<QualitySlider> {
  late double _quality;

  @override
  void initState() {
    _quality = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SfSliderTheme(
      data: SfSliderThemeData(
        activeLabelStyle: textTheme.labelMedium,
        inactiveLabelStyle: textTheme.labelMedium,
      ),
      child: SfSlider(
        value: _quality,
        min: 1,
        max: 10,
        enableTooltip: true,
        interval: 1,
        showLabels: true,
        showTicks: true,
        showDividers: true,
        stepSize: 1,
        tooltipShape: const SfPaddleTooltipShape(),
        onChanged: (value) {
          setState(() {
            _quality = value as double;
          });
          widget.onChanged(_quality);
        },
      ),
    );
  }
}
