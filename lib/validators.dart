class Validators {
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Az email nem lehet üres';
    }
    // Use a regular expression to validate the email
    String pattern = r'\w+@\w+\.\w+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Adjon meg egy érvényes email címet';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'A jelszó nem lehet üres';
    }
    // Add any other password validation logic here
    return null;
  }

  static String? requiredFieldValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ez a mező nem lehet üres';
    }
    return null;
  }
}
