extension StringExtension on String {
  String capitalizeFirstLetter() {
    if (isEmpty) {
      return this; // Return empty string if it's empty
    }
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}