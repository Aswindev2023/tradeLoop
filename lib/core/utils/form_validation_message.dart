class FormValidators {
  static String? validateForm(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please Enter $fieldName';
    }
    return null;
  }
}
