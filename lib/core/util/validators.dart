/// Validators for forms (phone, email, OTP).
class Validators {
  /// Saudi Arabia phone number check (starts with 5, length 9 or 10).
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone number is required";
    }
    final regex = RegExp(r'^(5\d{8})$'); // 5xxxxxxxx
    if (!regex.hasMatch(value)) {
      return "Enter a valid Saudi phone number";
    }
    return null;
  }

  /// OTP code validation (e.g., must be 4–6 digits).
  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return "OTP code is required";
    }
    if (value.length < 4 || value.length > 6) {
      return "OTP must be 4–6 digits";
    }
    return null;
  }
}
