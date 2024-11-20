class FormValidators {
  static String? validateForm(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName cannot be empty';
    }
    return null;
  }

  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return emailRegex.hasMatch(email);
  }

  static bool isValidName(String name) {
    final nameRegex = RegExp(r'^[a-zA-Z ]+$');
    return nameRegex.hasMatch(name);
  }

  static bool isValidNumber(String number) {
    final numberRegex = RegExp(r'^\d{10}$');
    return numberRegex.hasMatch(number);
  }

  static bool isValidZip(String zipCode) {
    final zipRegex = RegExp(r'^\d{6}$');
    return zipRegex.hasMatch(zipCode);
  }

  static bool isValidPassword(String password) {
    final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{6,}$');
    return passwordRegex.hasMatch(password);
  }

  static bool isValidPrice(String number) {
    final numberRegex = RegExp(r'^\d+(\.\d+)?$');
    return numberRegex.hasMatch(number);
  }
}
