class AddTripValidator {
  //Validate Trip Name
  static String? validateTripName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Trip name Required';
    }
    return null;
  }

  //Validate Destination
  static String? validateDestination(String? value) {
    if (value == null || value.isEmpty) {
      return 'Destination Required';
    }
    return null;
  }

  //Validate StartDate
  static String? validateStartDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Start Date Required';
    }
    return null;
  }
}
