import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResizeField extends StatefulWidget {
  const ResizeField({required this.onChanged, super.key});

  final void Function(int? width, int? height) onChanged;

  @override
  State<ResizeField> createState() => _ResizeFieldState();
}

class _ResizeFieldState extends State<ResizeField> {
  int? _width;
  int? _height;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Isi salah satu antara lebar atau tinggi, ukuran lainnya akan diatur secara otomatis sesuai dengan aspek rasio gambar.',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.outline,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lebar',
                    style: textTheme.labelSmall,
                  ),
                  const SizedBox(height: 2),
                  TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        final intVal = int.tryParse(newValue.text) ?? 0;
                        if (intVal > 16384) {
                          return TextEditingValue(
                            text: '16384',
                            selection: oldValue.text.length == 5
                                ? oldValue.selection
                                : newValue.selection,
                          );
                        } else if (newValue.text.startsWith('0') &&
                            newValue.text != '0') {
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
                      _width = int.tryParse(value);
                      widget.onChanged(_width, _height);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Auto',
                      isDense: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tinggi min',
                    style: textTheme.labelSmall,
                  ),
                  const SizedBox(height: 2),
                  TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        final intVal = int.tryParse(newValue.text) ?? 0;
                        if (intVal > 16384) {
                          return TextEditingValue(
                            text: '16384',
                            selection: oldValue.text.length == 5
                                ? oldValue.selection
                                : newValue.selection,
                          );
                        } else if (newValue.text.startsWith('0') &&
                            newValue.text != '0') {
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
                      _height = int.tryParse(value);
                      widget.onChanged(_width, _height);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Auto',
                      isDense: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Jika keduanya dikosongkan, gambar akan diresize menjadi 2560 × 1920.',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.outline,
          ),
        ),
      ],
    );
  }
}
