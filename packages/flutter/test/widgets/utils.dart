// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// This file defines basic widgets for use in tests for Widgets in `flutter/widgets`.

import 'package:flutter/widgets.dart';

/// Get a color for use in a widget test.
///
/// The returned color will be fully opaque,
/// but the [Color.r], [Color.g], and [Color.b] channels
/// will vary sequentially based on index, cycling every sixth integer.
Color getTestColor(int index) {
  const colors = [
    Color(0xFFFF0000),
    Color(0xFF00FF00),
    Color(0xFF0000FF),
    Color(0xFFFFFF00),
    Color(0xFFFF00FF),
    Color(0xFF00FFFF),
  ];

  return colors[index % colors.length];
}

// TODO(justinmc): replace with `RawButton` or equivalent when available.
/// A very basic button for use in widget tests.
class TestButton extends StatelessWidget {
  const TestButton({
    required this.child,
    this.focusNode,
    this.autofocus = false,
    this.onPressed,
    super.key,
  });

  final bool autofocus;
  final FocusNode? focusNode;
  final VoidCallback? onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onPressed != null,
      onTap: onPressed,
      child: FocusableActionDetector(
        enabled: onPressed != null,
        focusNode: focusNode,
        autofocus: autofocus,
        child: GestureDetector(onTap: onPressed, child: child),
      ),
    );
  }
}

/// A very basic slider for use in widget tests.
///
/// This widget provides minimal slider functionality without depending on
/// Material Design components. It only handles semantic actions for testing
/// purposes and does not render any visual elements.
class TestSlider extends StatelessWidget {
  const TestSlider({
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    super.key,
  }) : assert(value >= min && value <= max, 'Value must be between min and max');

  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final int? divisions;

  double get _normalizedValue {
    if (max == min) {
      return 0.0;
    }
    return (value - min) / (max - min);
  }

  double get _semanticActionUnit {
    if (divisions != null) {
      return 1.0 / divisions!;
    }
    // Use a consistent 10% adjustment for continuous sliders
    return 0.1;
  }

  String _formatPercentage(double normalizedValue) {
    return '${(normalizedValue * 100).round()}%';
  }

  void _increaseAction() {
    if (onChanged != null) {
      final double newNormalizedValue = (_normalizedValue + _semanticActionUnit).clamp(0.0, 1.0);
      onChanged!(min + newNormalizedValue * (max - min));
    }
  }

  void _decreaseAction() {
    if (onChanged != null) {
      final double newNormalizedValue = (_normalizedValue - _semanticActionUnit).clamp(0.0, 1.0);
      onChanged!(min + newNormalizedValue * (max - min));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      slider: true,
      enabled: onChanged != null,
      value: _formatPercentage(_normalizedValue),
      increasedValue: _formatPercentage((_normalizedValue + _semanticActionUnit).clamp(0.0, 1.0)),
      decreasedValue: _formatPercentage((_normalizedValue - _semanticActionUnit).clamp(0.0, 1.0)),
      onIncrease: onChanged != null ? _increaseAction : null,
      onDecrease: onChanged != null ? _decreaseAction : null,
      child: const SizedBox(width: 200.0, height: 48.0),
    );
  }
}

/// A very basic checkbox for use in widget tests.
///
/// This widget provides minimal checkbox functionality without depending on
/// Material Design components. It only handles semantic actions for testing
/// purposes and does not render any visual elements.
class TestCheckbox extends StatelessWidget {
  const TestCheckbox({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final bool? value;
  final ValueChanged<bool?>? onChanged;

  void _handleTap() {
    if (onChanged != null) {
      onChanged!(value != true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      checked: value ?? false,
      enabled: onChanged != null,
      onTap: onChanged != null ? _handleTap : null,
      child: GestureDetector(
        onTap: onChanged != null ? _handleTap : null,
        child: const SizedBox(width: 48.0, height: 48.0),
      ),
    );
  }
}
