class Validators {
  static String? validateName(String? value) {
    if (value == null || value.trim().length < 3) return 'Error';
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) return 'Error';
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Error';
    if (!RegExp(r'^(07\d{8}|\+947\d{8})$').hasMatch(value)) return 'Error';
    return null;
  }
}
