import 'package:flutter/material.dart';
import 'package:flutter_kit/components/navbar/navbar.dart';
import 'package:flutter_kit/flutter_kit.dart';
import 'package:flutter_kit/widgets/charts/chart.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChartsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(
        title: 'Charts',
        style: NavbarStyle.standard,
      ),
      body: AppLayout(
        type: AppLayoutType.scroll,
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Pie Chart Example'),
            SizedBox(height: 16.h),
            AppCard(
              child: SizedBox(
                height: 200.h,
                child: AppChart(
                  type: AppChartType.pie,
                  title: 'Revenue By Product',
                  data: _getSampleData(),
                ),
              ),
            ),
            SizedBox(height: 32.h),
            _sectionTitle('Bar Chart Example'),
            SizedBox(height: 16.h),
            AppCard(
              child: SizedBox(
                height: 200.h,
                child: AppChart(
                  type: AppChartType.bar,
                  title: 'Monthly Sales',
                  data: _getMonthlySalesData(),
                ),
              ),
            ),
            SizedBox(height: 32.h),
            _sectionTitle('Donut Chart Example'),
            SizedBox(height: 16.h),
            AppCard(
              child: SizedBox(
                height: 200.h,
                child: AppChart(
                  type: AppChartType.donut,
                  title: 'Traffic Sources',
                  data: _getTrafficSourcesData(),
                ),
              ),
            ),
            SizedBox(height: 32.h),
            _sectionTitle('Line Chart Example'),
            SizedBox(height: 16.h),
            AppCard(
              child: SizedBox(
                height: 200.h,
                child: AppChart(
                  type: AppChartType.line,
                  title: 'User Growth',
                  data: _getUserGrowthData(),
                ),
              ),
            ),
            SizedBox(height: 32.h),
            _buildChartNote(),
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

  List<AppChartData> _getSampleData() {
    return [
      AppChartData(label: 'Product A', value: 35),
      AppChartData(label: 'Product B', value: 25),
      AppChartData(label: 'Product C', value: 20),
      AppChartData(label: 'Product D', value: 15),
      AppChartData(label: 'Product E', value: 5),
    ];
  }

  List<AppChartData> _getMonthlySalesData() {
    return [
      AppChartData(label: 'Jan', value: 12),
      AppChartData(label: 'Feb', value: 17),
      AppChartData(label: 'Mar', value: 22),
      AppChartData(label: 'Apr', value: 19),
      AppChartData(label: 'May', value: 25),
      AppChartData(label: 'Jun', value: 32),
    ];
  }

  List<AppChartData> _getTrafficSourcesData() {
    return [
      AppChartData(label: 'Direct', value: 30),
      AppChartData(label: 'Organic', value: 25),
      AppChartData(label: 'Social', value: 20),
      AppChartData(label: 'Referral', value: 15),
      AppChartData(label: 'Email', value: 10),
    ];
  }

  List<AppChartData> _getUserGrowthData() {
    return [
      AppChartData(label: 'Jan', value: 1000),
      AppChartData(label: 'Feb', value: 1500),
      AppChartData(label: 'Mar', value: 2300),
      AppChartData(label: 'Apr', value: 3100),
      AppChartData(label: 'May', value: 4200),
      AppChartData(label: 'Jun', value: 5800),
    ];
  }

  Widget _buildChartNote() {
    return AppCard(
      type: CardType.outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Note About Charts',
            style: AppTextThemes.heading6(),
          ),
          SizedBox(height: 8.h),
          Text(
            'The charts shown here are placeholder implementations. In a real application, you would integrate a charting library like fl_chart, charts_flutter, or syncfusion_flutter_charts for interactive data visualization.',
            style: AppTextThemes.bodyMedium(),
          ),
        ],
      ),
    );
  }
}
