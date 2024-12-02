import 'package:equatable/equatable.dart';

class Day extends Equatable {
  final int day, month, year;

  Day({
    required this.day,
    required this.month,
    required this.year,
  }) {
    if (day < 1 || day > 31) {
      throw ArgumentError.value(day, 'day', 'Day must be between 1 and 31');
    }

    if (month < 1 || month > 12) {
      throw ArgumentError.value(month, 'month', 'Month must be between 1 and 12');
    }

    final minYear = DateTime.now().year - 100;

    if (year < minYear) {
      throw ArgumentError.value(year, 'year', 'Year must be greater than $minYear');
    }
  }

  static Day? tryParse(String value) {
    if (value.isEmpty) {
      return null;
    }

    final split = value.split('.');

    if (split.length != 3) {
      return null;
    }

    final day = int.tryParse(split[0]);
    final month = int.tryParse(split[1]);
    final year = int.tryParse(split[2]);

    if (day == null || month == null || year == null) {
      return null;
    }

    return Day(day: day, month: month, year: year);
  }

  static Day parse(String day) {
    return tryParse(day) ?? (throw ArgumentError.value(day, 'day', 'Invalid format'));
  }

  @override
  String toString() => '$day.$month.$year';

  @override
  List<Object?> get props => [day, month, year];
}
