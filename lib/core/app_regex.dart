class AppRegex {
  static final RegExp _emailRegExp = RegExp(
    r'^[\w\.-]+@[\w\.-]+\.\w{2,}$',
  );

  static final RegExp _phoneRegExp = RegExp(
    r'^\+?[0-9]{7,15}$',
  );

  static bool validateEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static bool validatePhone(String phone) {
    return _phoneRegExp.hasMatch(phone);
  }
}
