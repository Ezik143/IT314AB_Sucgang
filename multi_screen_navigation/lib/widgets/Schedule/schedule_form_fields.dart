import 'package:flutter/material.dart';

class ScheduleFormFields {
  static final RegExp _timePattern = RegExp(
    r'^([01]?\d|2[0-3]):[0-5]\d(:[0-5]\d)?$',
  );

  static bool isValidTime(String value) => _timePattern.hasMatch(value.trim());

  static String normalizeTime(String value) {
    final parts = value.trim().split(':');
    if (parts.length < 2) return value.trim();
    final hour = parts[0].padLeft(2, '0');
    final minute = parts[1].padLeft(2, '0');
    final second = parts.length > 2 ? parts[2].padLeft(2, '0') : '00';
    return '$hour:$minute:$second';
  }

  static Widget integerField(
    TextEditingController controller,
    String label, {
    String? requiredText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) return 'Required';
          final parsed = int.tryParse(value.trim());
          if (parsed == null) {
            return requiredText ?? 'Must be a valid integer';
          }
          if (parsed <= 0) return 'Must be greater than zero';
          return null;
        },
      ),
    );
  }

  static Widget timeField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.datetime,
        decoration: InputDecoration(
          labelText: label,
          hintText: 'HH:mm',
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) return 'Required';
          if (!isValidTime(value)) return 'Use 24-hour HH:mm (e.g. 08:30)';
          return null;
        },
      ),
    );
  }

  static Widget textField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) =>
            value == null || value.trim().isEmpty ? 'Required' : null,
      ),
    );
  }
}
