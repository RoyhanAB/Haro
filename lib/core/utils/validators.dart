bool isValidEmail(String value) => RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);

bool isStrongEnoughPassword(String value) => value.length >= 6;
