class Validator {
  static String? validateMobile(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = RegExp(patttern);
    String newValue = value.replaceAll(" ", "");
    if (newValue.isEmpty) {
      return "Mobile number is required.";
    } else if (newValue.trim().length < 9 || newValue.trim().length > 10) {
      return "Invalid mobile number.";
    } else if (!regExp.hasMatch(newValue)) {
      return "Mobile number must be digits.";
    }
    return null;
  }
}
