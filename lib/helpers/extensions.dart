extension StringExtension on String {
  String? get capitalize {
    if (isEmpty) return null;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
