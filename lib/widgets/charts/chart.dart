import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';

enum AppChartType { line, bar, pie, donut }

class AppChartData {
  final String label;
  final double value;
  final Color? color;

  AppChartData({
    required this.label,
    required this.value,
    this.color,
  });
}

class AppChart extends StatelessWidget {
  final AppChartType type;
  final List<AppChartData> data;
  final String? title;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final List<Color>? colorPalette;
  final bool showLabels;
  final bool showLegend;
  final bool showValues;
  final bool animated;

  const AppChart({
    Key? key,
    required this.type,
    required this.data,
    this.title,
    this.height,
    this.width,
    this.padding,
    this.colorPalette,
    this.showLabels = true,
    this.showLegend = true,
    this.showValues = true,
    this.animated = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding ?? EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
          ],
          Expanded(
            child: _buildChart(),
          ),
          if (showLegend) ...[
            SizedBox(height: 16.h),
            _buildLegend(),
          ],
        ],
      ),
    );
  }

  Widget _buildChart() {
    switch (type) {
      case AppChartType.pie:
        return _buildPieChart();
      case AppChartType.donut:
        return _buildDonutChart();
      case AppChartType.bar:
        return _buildBarChart();
      case AppChartType.line:
        return _buildLineChart();
    }
  }

  Widget _buildPieChart() {
    // Placeholder for pie chart implementation
    // In a real implementation, you would use a chart package like fl_chart, charts_flutter, or syncfusion_flutter_charts
    return Center(
      child: Text('Pie Chart - Implement with chart package'),
    );
  }

  Widget _buildDonutChart() {
    // Placeholder for donut chart implementation
    return Center(
      child: Text('Donut Chart - Implement with chart package'),
    );
  }

  Widget _buildBarChart() {
    // Placeholder for bar chart implementation
    return Center(
      child: Text('Bar Chart - Implement with chart package'),
    );
  }

  Widget _buildLineChart() {
    // Placeholder for line chart implementation
    return Center(
      child: Text('Line Chart - Implement with chart package'),
    );
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 16.w,
      runSpacing: 8.h,
      children: data.map((item) {
        final color = item.color ?? _getColorForItem(data.indexOf(item));

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 12.sp,
              ),
            ),
            SizedBox(width: 4.w),
            if (showValues)
              Text(
                '\${item.value.toStringAsFixed(1)}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        );
      }).toList(),
    );
  }

  Color _getColorForItem(int index) {
    final defaultColors = colorPalette ??
        [
          AppColors.primary,
          AppColors.accent,
          Colors.orangeAccent,
          Colors.greenAccent,
          Colors.purpleAccent,
          Colors.tealAccent,
          Colors.redAccent,
          Colors.blueAccent,
        ];

    return defaultColors[index % defaultColors.length];
  }
}
