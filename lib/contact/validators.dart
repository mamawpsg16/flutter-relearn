/// Pure validation functions — each does ONE thing (Single Responsibility).
/// To add new validators, just add new functions — no need to modify existing ones (Open/Closed).

String? validateName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter your name';
  }
  return null; // null means valid
}

String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter your email';
  }
  // Simple email check — contains @ and a dot after it
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
  if (!emailRegex.hasMatch(value.trim())) {
    return 'Please enter a valid email';
  }
  return null;
}

String? validateMessage(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Please enter a message';
  }
  if (value.trim().length < 10) {
    return 'Message must be at least 10 characters';
  }
  return null;
}
