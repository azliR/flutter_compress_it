import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class BitrateSlider extends StatefulWidget {
  const BitrateSlider({
    required this.initialValue,
    required this.onChanged,
    super.key,
  });

  final double initialValue;
  final void Function(double value) onChanged;

  @override
  State<BitrateSlider> createState() => _BitrateSliderState();
}

class _BitrateSliderState extends State<BitrateSlider> {
  late double _bitrate;
  late final TextEditingController _qualityFieldController;

  @override
  void initState() {
    _bitrate = widget.initialValue;
    _qualityFieldController =
        TextEditingController(text: widget.initialValue.toStringAsFixed(0));
    super.initState();
  }

  @override
  void dispose() {
    _qualityFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: _qualityFieldController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              TextInputFormatter.withFunction((oldValue, newValue) {
                final intVal = int.tryParse(newValue.text) ?? 0;
                if (intVal > 512) {
                  return TextEditingValue(
                    text: '512',
                    selection: oldValue.text.length == 3
                        ? oldValue.selection
                        : newValue.selection,
                  );
                } else if (newValue.text.startsWith('0')) {
                  return TextEditingValue(
                    text: newValue.text.substring(1),
                    selection: newValue.selection.copyWith(
                      baseOffset: newValue.selection.baseOffset - 1,
                      extentOffset: newValue.selection.extentOffset - 1,
                    ),
                  );
                }
                return newValue;
              })
            ],
            style: textTheme.bodyMedium,
            onChanged: (value) {
              final bitrate = double.tryParse(value);
              setState(() {
                _bitrate = bitrate ?? 0;
              });
              widget.onChanged(_bitrate);
            },
            decoration: const InputDecoration(
              hintText: '',
              isDense: true,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: SfSliderTheme(
            data: SfSliderThemeData(
              activeLabelStyle: textTheme.labelMedium,
              inactiveLabelStyle: textTheme.labelMedium,
            ),
            child: SfSlider(
              value: _bitrate,
              min: 0,
              max: 512,
              interval: 128,
              enableTooltip: true,
              showLabels: true,
              showTicks: true,
              showDividers: true,
              stepSize: 1,
              tooltipShape: const SfPaddleTooltipShape(),
              onChanged: (value) {
                setState(() {
                  _bitrate = value as double;
                });
                _qualityFieldController.text = _bitrate.toStringAsFixed(0);
                widget.onChanged(_bitrate);
              },
            ),
          ),
        ),
      ],
    );
  }
}
