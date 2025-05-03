import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Validator {
  static bool validateInput({
    required String value,
    required String fieldName,
    int? minLength,
    int? maxLength,
    bool allowWhitespace = false,
    List<String>? forbiddenValues,
    String? customError,
    String? email,
  }) {
    // Check for empty value
    if (value.isEmpty) {
      Get.snackbar(
        'Error',
        '$fieldName cannot be empty',
        backgroundColor: Colors.red.shade400,
      );
      return false;
    }

    // Check for whitespace-only if not allowed
    if (!allowWhitespace && value.trim().isEmpty) {
      Get.snackbar(
        'Error',
        '$fieldName cannot be just whitespace',
        backgroundColor: Colors.red.shade400,
      );
      return false;
    }

    // Check minimum length if specified
    if (minLength != null && value.length < minLength) {
      Get.snackbar(
        'Error',
        '$fieldName must be at least $minLength characters long',
        backgroundColor: Colors.red.shade400,
      );
      return false;
    }

    // Check maximum length if specified
    if (maxLength != null && value.length > maxLength) {
      Get.snackbar(
        'Error',
        '$fieldName must be no more than $maxLength characters long',
        backgroundColor: Colors.red.shade400,
      );
      return false;
    }

    // Check against forbidden values if specified
    if (forbiddenValues != null && forbiddenValues.contains(value)) {
      Get.snackbar(
        'Error',
        customError ?? '$fieldName is not allowed',
        backgroundColor: Colors.red.shade400,
      );
      return false;
    }
    if (email != null) {
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        Get.snackbar(
          'Error',
          customError ?? 'Enter a valid email',
          backgroundColor: Colors.red.shade400,
        );
        return false;
      }
    }

    return true;
  }
}
