import 'package:trade_loop/core/utils/form_validation_message.dart';

class ProfilePageValidation {
  final String email;
  final String name;
  final String number;
  final String zipcode;

  ProfilePageValidation(this.email, this.name, this.number, this.zipcode);

  bool isValidEdit(String email, String name, String number, String zipcode) {
    if (FormValidators.isValidEmail(email) &&
        FormValidators.isValidName(name) &&
        FormValidators.isValidNumber(number) &&
        FormValidators.isValidZip(zipcode)) {
      return true;
    } else {
      return false;
    }
  }
}
