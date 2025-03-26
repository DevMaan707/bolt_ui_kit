import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_kit/components/navbar/navbar.dart';
import 'package:flutter_kit/flutter_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PickersScreen extends StatefulWidget {
  @override
  _PickersScreenState createState() => _PickersScreenState();
}

class _PickersScreenState extends State<PickersScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  DateTimeRange? _selectedDateRange;
  List<DateTime>? _selectedMultipleDates;
  Duration? _selectedDuration;
  File? _selectedImage;
  File? _selectedFile;
  String? _scannedQRCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(
        title: 'Pickers',
        style: NavbarStyle.standard,
      ),
      body: AppLayout(
        type: AppLayoutType.scroll,
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Date & Time Pickers'),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: _buildPickerCard(
                    title: 'Date Picker',
                    value: _selectedDate != null
                        ? DatePickerUtil.formatDate(_selectedDate!)
                        : 'Select Date',
                    icon: Icons.calendar_today,
                    onTap: _pickDate,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildPickerCard(
                    title: 'Time Picker',
                    value: _selectedTime != null
                        ? TimePickerUtil.formatTimeOfDay(_selectedTime!)
                        : 'Select Time',
                    icon: Icons.access_time,
                    onTap: _pickTime,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: _buildPickerCard(
                    title: 'Date Range',
                    value: _selectedDateRange != null
                        ? DatePickerUtil.formatDateRange(_selectedDateRange!)
                        : 'Select Range',
                    icon: Icons.date_range,
                    onTap: _pickDateRange,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildPickerCard(
                    title: 'Duration',
                    value: _selectedDuration != null
                        ? TimePickerUtil.formatDuration(_selectedDuration!)
                        : 'Select Duration',
                    icon: Icons.timer,
                    onTap: _pickDuration,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            _buildPickerCard(
              title: 'Multiple Dates',
              value: _selectedMultipleDates != null
                  ? '${_selectedMultipleDates!.length} dates selected'
                  : 'Select Multiple Dates',
              icon: Icons.calendar_month,
              onTap: _pickMultipleDates,
            ),
            SizedBox(height: 32.h),
            _sectionTitle('File Pickers'),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: _buildPickerCard(
                    title: 'Image Picker',
                    value: _selectedImage != null
                        ? 'Image selected'
                        : 'Select Image',
                    icon: Icons.image,
                    onTap: _pickImage,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildPickerCard(
                    title: 'File Picker',
                    value:
                        _selectedFile != null ? 'File selected' : 'Select File',
                    icon: Icons.file_open,
                    onTap: _pickFile,
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.h),
            _sectionTitle('Scan & Capture'),
            SizedBox(height: 16.h),
            _buildPickerCard(
              title: 'QR Scanner',
              value: _scannedQRCode ?? 'Scan QR Code',
              icon: Icons.qr_code_scanner,
              onTap: _scanQRCode,
            ),
            SizedBox(height: 32.h),
            if (_selectedImage != null) ...[
              _sectionTitle('Selected Image'),
              SizedBox(height: 16.h),
              Container(
                height: 200.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Button(
                text: 'Clear Image',
                type: ButtonType.outlined,
                icon: Icons.delete,
                onPressed: () {
                  setState(() {
                    _selectedImage = null;
                  });
                },
              ),
              SizedBox(height: 32.h),
            ],
            AppCard(
              type: CardType.outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About Pickers',
                    style: AppTextThemes.heading6(),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'The pickers use the app\'s theme colors and typography for a consistent look and feel. In real usage, you can customize colors, text styles, and other properties as needed.',
                    style: AppTextThemes.bodyMedium(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: AppTextThemes.heading5(),
    );
  }

  Widget _buildPickerCard({
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return AppCard(
      type: CardType.elevated,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: AppColors.primary,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                title,
                style: AppTextThemes.bodyMedium(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: AppTextThemes.bodyMedium(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final DateTime? result = await DatePickerUtil.showCustomDatePicker(
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Select Date',
      confirmText: 'Choose',
      cancelText: 'Cancel',
    );

    if (result != null) {
      setState(() {
        _selectedDate = result;
      });
      Toast.show(
        message: 'Date selected: ${DatePickerUtil.formatDate(result)}',
        type: ToastType.success,
      );
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? result = await TimePickerUtil.showCustomTimePicker(
      initialTime: _selectedTime ?? TimeOfDay.now(),
      helpText: 'Select Time',
      confirmText: 'Choose',
      cancelText: 'Cancel',
    );

    if (result != null) {
      setState(() {
        _selectedTime = result;
      });
      Toast.show(
        message: 'Time selected: ${TimePickerUtil.formatTimeOfDay(result)}',
        type: ToastType.success,
      );
    }
  }

  Future<void> _pickDateRange() async {
    final DateTimeRange? result =
        await DatePickerUtil.showCustomDateRangePicker(
      initialDateRange: _selectedDateRange,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Select Date Range',
      confirmText: 'Choose',
      cancelText: 'Cancel',
    );

    if (result != null) {
      setState(() {
        _selectedDateRange = result;
      });
      Toast.show(
        message:
            'Date range selected: ${DatePickerUtil.formatDateRange(result)}',
        type: ToastType.success,
      );
    }
  }

  Future<void> _pickMultipleDates() async {
    final result = await CalendarPickerUtil.showCalendarPicker(
      mode: CalendarPickerMode.multi,
      initialSelectedDates: _selectedMultipleDates,
      title: 'Select Multiple Dates',
      confirmButtonText: 'Choose',
      cancelButtonText: 'Cancel',
      primaryColor: AppColors.primary,
      selectedColor: AppColors.primary,
    );

    if (result?.selectedDates != null) {
      setState(() {
        _selectedMultipleDates = result!.selectedDates;
      });
      Toast.show(
        message: '${result!.selectedDates!.length} dates selected',
        type: ToastType.success,
      );
    }
  }

  Future<void> _pickDuration() async {
    final Duration? result = await TimePickerUtil.showDurationPicker(
      initialDuration: _selectedDuration ?? Duration(minutes: 30),
      maxDuration: Duration(hours: 10),
      primaryColor: AppColors.primary,
      backgroundColor: Theme.of(context).cardColor,
      textColor: Theme.of(context).textTheme.bodyLarge?.color,
    );

    if (result != null) {
      setState(() {
        _selectedDuration = result;
      });
      Toast.show(
        message: 'Duration selected: ${TimePickerUtil.formatDuration(result)}',
        type: ToastType.success,
      );
    }
  }

  Future<void> _pickImage() async {
    try {
      final File? result = await ImagePickerUtil().showCustomImagePicker(
        enableCrop: true,
        primaryColor: AppColors.primary,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: 'Select Image',
        cropSettings: CropSettings.square(
          primaryColor: AppColors.primary,
        ),
      );

      if (result != null) {
        setState(() {
          _selectedImage = result;
        });
        Toast.show(
          message: 'Image selected successfully',
          type: ToastType.success,
        );
      }
    } catch (e) {
      Toast.show(
        message: 'Failed to pick image: $e',
        type: ToastType.error,
      );
    }
  }

  Future<void> _pickFile() async {
    try {
      final File? result = await FilePickerUtil().showCustomFilePicker(
        context: context,
        title: 'Select File',
        primaryColor: AppColors.primary,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      );

      if (result != null) {
        setState(() {
          _selectedFile = result;
        });
        Toast.show(
          message: 'File selected: ${result.path.split('/').last}',
          type: ToastType.success,
        );
      }
    } catch (e) {
      Toast.show(
        message: 'Failed to pick file: $e',
        type: ToastType.error,
      );
    }
  }

  Future<void> _scanQRCode() async {
    try {
      final String? result = await QRScannerUtil().scanQR(
        title: 'Scan QR Code',
        scanInstructions: 'Position the QR code within the frame to scan',
        primaryColor: AppColors.primary,
        theme: ScannerTheme(
          primaryColor: AppColors.primary,
          scanAreaWidth: 250,
          scanAreaHeight: 250,
        ),
      );

      if (result != null) {
        setState(() {
          _scannedQRCode = result;
        });
        Toast.show(
          message: 'QR code scanned: $result',
          type: ToastType.success,
        );
      }
    } catch (e) {
      Toast.show(
        message: 'Failed to scan QR code: $e',
        type: ToastType.error,
      );
    }
  }
}
