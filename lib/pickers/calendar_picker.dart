import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';
import 'package:table_calendar/table_calendar.dart';

import '../theme/text_themes.dart';

class CalendarPickerUtil {
  static Future<CalendarPickerResult?> showCalendarPicker({
    CalendarPickerMode mode = CalendarPickerMode.single,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? initialRangeStart,
    DateTime? initialRangeEnd,
    List<DateTime>? initialSelectedDates,
    List<DateTime>? disabledDates,
    Color? primaryColor,
    Color? selectedColor,
    Color? todayColor,
    String? title,
    String? confirmButtonText,
    String? cancelButtonText,
    bool barrierDismissible = true,
  }) async {
    initialDate ??= DateTime.now();
    firstDate ??= DateTime.now().subtract(const Duration(days: 365 * 5));
    lastDate ??= DateTime.now().add(const Duration(days: 365 * 5));
    primaryColor ??= AppColors.primary;
    selectedColor ??= primaryColor;
    todayColor ??= Colors.amber;

    final result = await Get.dialog<CalendarPickerResult>(
      CalendarPickerDialog(
        mode: mode,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        initialRangeStart: initialRangeStart,
        initialRangeEnd: initialRangeEnd,
        initialSelectedDates: initialSelectedDates,
        disabledDates: disabledDates,
        primaryColor: primaryColor,
        selectedColor: selectedColor,
        todayColor: todayColor,
        title: title ?? 'Select Date',
        confirmButtonText: confirmButtonText ?? 'Confirm',
        cancelButtonText: cancelButtonText ?? 'Cancel',
      ),
      barrierDismissible: barrierDismissible,
    );

    return result;
  }
}

enum CalendarPickerMode { single, multi, range }

class CalendarPickerResult {
  final DateTime? selectedDate;
  final List<DateTime>? selectedDates;
  final DateTimeRange? selectedRange;

  CalendarPickerResult({
    this.selectedDate,
    this.selectedDates,
    this.selectedRange,
  });
}

class CalendarPickerDialog extends StatefulWidget {
  final CalendarPickerMode mode;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? initialRangeStart;
  final DateTime? initialRangeEnd;
  final List<DateTime>? initialSelectedDates;
  final List<DateTime>? disabledDates;
  final Color primaryColor;
  final Color selectedColor;
  final Color todayColor;
  final String title;
  final String confirmButtonText;
  final String cancelButtonText;

  const CalendarPickerDialog({
    Key? key,
    required this.mode,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.initialRangeStart,
    this.initialRangeEnd,
    this.initialSelectedDates,
    this.disabledDates,
    required this.primaryColor,
    required this.selectedColor,
    required this.todayColor,
    required this.title,
    required this.confirmButtonText,
    required this.cancelButtonText,
  }) : super(key: key);

  @override
  _CalendarPickerDialogState createState() => _CalendarPickerDialogState();
}

class _CalendarPickerDialogState extends State<CalendarPickerDialog> {
  late DateTime _focusedDay;
  late CalendarFormat _calendarFormat;
  late DateTime? _selectedDay;
  late List<DateTime> _selectedDays;
  late DateTime? _rangeStart;
  late DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialDate;
    _calendarFormat = CalendarFormat.month;
    switch (widget.mode) {
      case CalendarPickerMode.single:
        _selectedDay = widget.initialDate;
        _selectedDays = [];
        _rangeStart = null;
        _rangeEnd = null;
        break;

      case CalendarPickerMode.multi:
        _selectedDay = null;
        _selectedDays = widget.initialSelectedDates ?? [];
        _rangeStart = null;
        _rangeEnd = null;
        break;

      case CalendarPickerMode.range:
        _selectedDay = null;
        _selectedDays = [];
        _rangeStart = widget.initialRangeStart;
        _rangeEnd = widget.initialRangeEnd;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildCalendar(),
            SizedBox(height: 16.h),
            _buildControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    final themeData = Theme.of(context);
    final primaryColor = widget.primaryColor;
    final selectedColor = widget.selectedColor;
    final todayColor = widget.todayColor;
    final textColor = themeData.textTheme.bodyMedium?.color ?? Colors.black;

    return TableCalendar(
      firstDay: widget.firstDate,
      lastDay: widget.lastDate,
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      startingDayOfWeek: StartingDayOfWeek.monday,
      selectedDayPredicate: (day) {
        if (widget.mode == CalendarPickerMode.single) {
          return isSameDay(_selectedDay, day);
        } else if (widget.mode == CalendarPickerMode.multi) {
          return _selectedDays
              .any((selectedDay) => isSameDay(selectedDay, day));
        }
        return false;
      },
      rangeStartDay: _rangeStart,
      rangeEndDay: _rangeEnd,
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          if (widget.mode == CalendarPickerMode.single) {
            _selectedDay = selectedDay;
          } else if (widget.mode == CalendarPickerMode.multi) {
            if (_selectedDays.any((day) => isSameDay(day, selectedDay))) {
              _selectedDays.removeWhere((day) => isSameDay(day, selectedDay));
            } else {
              _selectedDays.add(selectedDay);
            }
          }
          _focusedDay = focusedDay;
        });
      },
      onRangeSelected: widget.mode == CalendarPickerMode.range
          ? (start, end, focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
                _rangeStart = start;
                _rangeEnd = end;
              });
            }
          : null,
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      enabledDayPredicate: (day) {
        if (widget.disabledDates != null) {
          return !widget.disabledDates!
              .any((disabledDay) => isSameDay(disabledDay, day));
        }
        return true;
      },
      calendarStyle: CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: selectedColor,
          shape: BoxShape.circle,
        ),
        selectedTextStyle: AppTextThemes.bodyMedium(color: Colors.white),
        todayDecoration: BoxDecoration(
          color: todayColor.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        todayTextStyle: AppTextThemes.bodyMedium(color: Colors.white),
        defaultTextStyle: AppTextThemes.bodyMedium(color: textColor),
        weekendTextStyle:
            AppTextThemes.bodyMedium(color: textColor.withOpacity(0.7)),
        outsideTextStyle:
            AppTextThemes.bodyMedium(color: textColor.withOpacity(0.4)),
        markersMaxCount: 3,
        markerDecoration: BoxDecoration(
          color: primaryColor,
          shape: BoxShape.circle,
        ),
        rangeStartDecoration: BoxDecoration(
          color: selectedColor,
          shape: BoxShape.circle,
        ),
        rangeStartTextStyle: AppTextThemes.bodyMedium(color: Colors.white),
        rangeEndDecoration: BoxDecoration(
          color: selectedColor,
          shape: BoxShape.circle,
        ),
        rangeEndTextStyle: AppTextThemes.bodyMedium(color: Colors.white),
        withinRangeTextStyle: AppTextThemes.bodyMedium(color: textColor),
        rangeHighlightColor: selectedColor.withOpacity(0.2),
      ),
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: true,
        formatButtonDecoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.r),
        ),
        formatButtonTextStyle: AppTextThemes.button(color: primaryColor),
        titleTextStyle: AppTextThemes.heading5(color: primaryColor),
        leftChevronIcon: Icon(Icons.chevron_left, color: primaryColor),
        rightChevronIcon: Icon(Icons.chevron_right, color: primaryColor),
      ),
      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, day) {
          final text = DateFormat.E().format(day);
          return Center(
            child: Text(
              text,
              style: AppTextThemes.caption(
                color: textColor.withOpacity(0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            widget.cancelButtonText,
            style: AppTextThemes.button(color: Colors.grey[700]),
          ),
        ),
        TextButton(
          onPressed: () {
            CalendarPickerResult result;

            switch (widget.mode) {
              case CalendarPickerMode.single:
                result = CalendarPickerResult(selectedDate: _selectedDay);
                break;
              case CalendarPickerMode.multi:
                result =
                    CalendarPickerResult(selectedDates: [..._selectedDays]);
                break;
              case CalendarPickerMode.range:
                result = CalendarPickerResult(
                  selectedRange: _rangeStart != null && _rangeEnd != null
                      ? DateTimeRange(start: _rangeStart!, end: _rangeEnd!)
                      : null,
                );
                break;
            }

            Get.back(result: result);
          },
          style: TextButton.styleFrom(
            backgroundColor: widget.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.h),
          ),
          child: Text(
            widget.confirmButtonText,
            style: AppTextThemes.button(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
