
class ValidationErrors {
  ValidationErrors._();

  static const String required = 'This field must not be empty';
}

class FieldValidators {
  FieldValidators._();

  static String? required(dynamic value) {
    if (value == null ||
        value == false ||
        ((value is Iterable || value is String || value is Map) &&
            value.length == 0)) {
      return ValidationErrors.required;
    }
    return null;
  }

}
