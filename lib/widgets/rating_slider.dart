import 'package:flutter/material.dart';

class RatingSlider extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  const RatingSlider({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Etiqueta del Slider (e.g., Romance, Trama, Final)
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        // Slider de calificación de 0.0 a 5.0
        Slider(
          value: value,
          min: 0,
          max: 5, // Calificación de 0 a 5
          divisions: 5,
          label: value.round().toString(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}