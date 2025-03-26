import 'dart:math' as math;
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

class AppChart extends StatefulWidget {
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
  State<AppChart> createState() => _AppChartState();
}

class _AppChartState extends State<AppChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.animated ? 1200 : 0),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      padding: widget.padding ?? EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null) ...[
            Text(
              widget.title!,
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
          if (widget.showLegend) ...[
            SizedBox(height: 16.h),
            _buildLegend(),
          ],
        ],
      ),
    );
  }

  Widget _buildChart() {
    switch (widget.type) {
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: PieChartPainter(
            data: widget.data,
            animation: _animation.value,
            colorPalette: widget.colorPalette,
            showLabels: widget.showLabels,
          ),
        );
      },
    );
  }

  Widget _buildDonutChart() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: DonutChartPainter(
            data: widget.data,
            animation: _animation.value,
            colorPalette: widget.colorPalette,
            showLabels: widget.showLabels,
          ),
        );
      },
    );
  }

  Widget _buildBarChart() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: BarChartPainter(
            data: widget.data,
            animation: _animation.value,
            colorPalette: widget.colorPalette,
            showValues: widget.showValues,
          ),
        );
      },
    );
  }

  Widget _buildLineChart() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: LineChartPainter(
            data: widget.data,
            animation: _animation.value,
            colorPalette: widget.colorPalette,
            showValues: widget.showValues,
          ),
        );
      },
    );
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 16.w,
      runSpacing: 8.h,
      children: widget.data.map((item) {
        final color = item.color ?? _getColorForItem(widget.data.indexOf(item));

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
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 4.w),
            if (widget.showValues)
              Text(
                '${item.value.toStringAsFixed(1)}',
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
    final defaultColors = widget.colorPalette ??
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

class PieChartPainter extends CustomPainter {
  final List<AppChartData> data;
  final double animation;
  final List<Color>? colorPalette;
  final bool showLabels;

  PieChartPainter({
    required this.data,
    required this.animation,
    this.colorPalette,
    this.showLabels = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 * 0.85;
    final rect = Rect.fromCircle(center: center, radius: radius);

    double startAngle = -math.pi / 2;
    double total = data.fold(0, (sum, item) => sum + item.value);

    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final sweepAngle = (item.value / total) * math.pi * 2 * animation;
      final color = item.color ?? _getColorForIndex(i);
      final paint = Paint()
        ..style = PaintingStyle.fill
        ..color = color;

      final shader = RadialGradient(
        colors: [color.withOpacity(0.9), color],
        stops: [0.6, 1.0],
      ).createShader(rect);
      paint.shader = shader;

      canvas.drawShadow(Path()..addArc(rect.inflate(1), startAngle, sweepAngle),
          Colors.black26, 2, true);

      canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
      if (animation == 1.0) {
        final separatorPaint = Paint()
          ..color = Colors.white.withOpacity(0.6)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

        final separatorPath = Path();
        separatorPath.moveTo(center.dx, center.dy);
        final endX = center.dx + radius * math.cos(startAngle);
        final endY = center.dy + radius * math.sin(startAngle);
        separatorPath.lineTo(endX, endY);
        canvas.drawPath(separatorPath, separatorPaint);
      }
      if (showLabels && animation > 0.8 && item.value / total > 0.05) {
        final midAngle = startAngle + (sweepAngle / 2);
        final labelRadius = radius * 0.75;
        final labelPos = Offset(
          center.dx + labelRadius * math.cos(midAngle),
          center.dy + labelRadius * math.sin(midAngle),
        );

        final textSpan = TextSpan(
          text: '${(item.value / total * 100).toStringAsFixed(0)}%',
          style: TextStyle(
            color: _getContrastingColor(color),
            fontSize: 10,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(0.5, 0.5),
                color: Colors.black26,
                blurRadius: 2,
              ),
            ],
          ),
        );

        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        );

        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            labelPos.dx - textPainter.width / 2,
            labelPos.dy - textPainter.height / 2,
          ),
        );
      }

      startAngle += sweepAngle;
    }
  }

  Color _getColorForIndex(int index) {
    final defaultColors = colorPalette ??
        [
          Colors.blueAccent,
          Colors.redAccent,
          Colors.greenAccent,
          Colors.purpleAccent,
          Colors.orangeAccent,
          Colors.tealAccent,
          Colors.pinkAccent,
          Colors.indigoAccent,
        ];

    return defaultColors[index % defaultColors.length];
  }

  Color _getContrastingColor(Color color) {
    final luminance =
        (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    return luminance > 0.6 ? Colors.black : Colors.white;
  }

  @override
  bool shouldRepaint(PieChartPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}

class DonutChartPainter extends CustomPainter {
  final List<AppChartData> data;
  final double animation;
  final List<Color>? colorPalette;
  final bool showLabels;

  DonutChartPainter({
    required this.data,
    required this.animation,
    this.colorPalette,
    this.showLabels = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 * 0.85;
    final outerRect = Rect.fromCircle(center: center, radius: radius);
    final innerRadius = radius * 0.6;
    final innerRect = Rect.fromCircle(center: center, radius: innerRadius);

    double startAngle = -math.pi / 2;
    double total = data.fold(0, (sum, item) => sum + item.value);
    final centerCirclePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawShadow(Path()..addOval(innerRect), Colors.black26, 4, true);
    canvas.drawCircle(center, innerRadius, centerCirclePaint);
    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final sweepAngle = (item.value / total) * math.pi * 2 * animation;
      final color = item.color ?? _getColorForIndex(i);
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = (radius - innerRadius)
        ..color = color;
      final gradient = SweepGradient(
        colors: [color.withOpacity(0.8), color],
        startAngle: startAngle,
        endAngle: startAngle + sweepAngle,
        tileMode: TileMode.clamp,
      );

      paint.shader = gradient.createShader(outerRect);

      canvas.drawArc(
          Rect.fromCircle(
            center: center,
            radius: (radius - innerRadius) / 2 + innerRadius,
          ),
          startAngle,
          sweepAngle,
          false,
          paint);

      if (animation == 1.0) {
        final linePaint = Paint()
          ..color = Colors.white.withOpacity(0.7)
          ..strokeWidth = 1.5;

        final outerX = center.dx + radius * math.cos(startAngle);
        final outerY = center.dy + radius * math.sin(startAngle);
        final innerX = center.dx + innerRadius * math.cos(startAngle);
        final innerY = center.dy + innerRadius * math.sin(startAngle);

        canvas.drawLine(
          Offset(innerX, innerY),
          Offset(outerX, outerY),
          linePaint,
        );
      }

      // Draw labels if enabled
      if (showLabels && animation > 0.8 && item.value / total > 0.05) {
        final midAngle = startAngle + (sweepAngle / 2);
        final labelRadius = (radius + innerRadius) / 2;
        final labelPos = Offset(
          center.dx + labelRadius * math.cos(midAngle),
          center.dy + labelRadius * math.sin(midAngle),
        );

        final textSpan = TextSpan(
          text: '${(item.value / total * 100).toStringAsFixed(0)}%',
          style: TextStyle(
            color: _getContrastingColor(color),
            fontSize: 10,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(0.5, 0.5),
                color: Colors.black.withOpacity(0.3),
                blurRadius: 2,
              ),
            ],
          ),
        );

        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            labelPos.dx - textPainter.width / 2,
            labelPos.dy - textPainter.height / 2,
          ),
        );
      }

      startAngle += sweepAngle;
    }

    if (animation > 0.9) {
      final textSpan = TextSpan(
        text: 'Total\n${total.toInt()}',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          height: 1.2,
        ),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );

      textPainter.layout(minWidth: innerRadius * 1.5);
      textPainter.paint(
        canvas,
        Offset(
          center.dx - textPainter.width / 2,
          center.dy - textPainter.height / 2,
        ),
      );
    }
  }

  Color _getColorForIndex(int index) {
    final defaultColors = colorPalette ??
        [
          Colors.blueAccent,
          Colors.redAccent,
          Colors.greenAccent,
          Colors.purpleAccent,
          Colors.orangeAccent,
          Colors.tealAccent,
          Colors.pinkAccent,
          Colors.indigoAccent,
        ];

    return defaultColors[index % defaultColors.length];
  }

  Color _getContrastingColor(Color color) {
    final luminance =
        (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;
    return luminance > 0.6 ? Colors.black : Colors.white;
  }

  @override
  bool shouldRepaint(DonutChartPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}

class BarChartPainter extends CustomPainter {
  final List<AppChartData> data;
  final double animation;
  final List<Color>? colorPalette;
  final bool showValues;

  BarChartPainter({
    required this.data,
    required this.animation,
    this.colorPalette,
    this.showValues = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final chartAreaHeight = size.height * 0.85;
    final chartAreaWidth = size.width * 0.9;
    final leftPadding = size.width * 0.1;
    final bottomPadding = size.height * 0.1;
    double maxValue = data.map((e) => e.value).reduce(math.max);
    maxValue = (maxValue * 1.1).ceilToDouble();

    final barWidth = chartAreaWidth / data.length * 0.7;
    final spacing = chartAreaWidth / data.length * 0.3;
    final baselinePaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(leftPadding, size.height - bottomPadding),
      Offset(size.width, size.height - bottomPadding),
      baselinePaint,
    );
    final gridLinePaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final numGridLines = 5;
    for (int i = 1; i <= numGridLines; i++) {
      final y =
          size.height - bottomPadding - (i / numGridLines) * chartAreaHeight;
      canvas.drawLine(
        Offset(leftPadding, y),
        Offset(size.width, y),
        gridLinePaint,
      );
      final gridValue = (i / numGridLines * maxValue).toStringAsFixed(0);
      final textSpan = TextSpan(
        text: gridValue,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 10,
        ),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.right,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(leftPadding - textPainter.width - 4, y - textPainter.height / 2),
      );
    }
    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final normalizedValue = item.value / maxValue;
      final animatedHeight = normalizedValue * chartAreaHeight * animation;
      final color = item.color ?? _getColorForIndex(i);

      final barX = leftPadding + (i * (barWidth + spacing)) + spacing / 2;
      final barY = size.height - bottomPadding - animatedHeight;

      final barRect = Rect.fromLTWH(
        barX,
        barY,
        barWidth,
        animatedHeight,
      );
      final gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withOpacity(0.9),
          color,
        ],
      );

      final barPaint = Paint()
        ..shader = gradient.createShader(barRect)
        ..style = PaintingStyle.fill;
      final shadowPath = Path()
        ..addRRect(RRect.fromRectAndRadius(
          barRect,
          Radius.circular(barWidth / 4),
        ));

      canvas.drawShadow(shadowPath, Colors.black.withOpacity(0.2), 3, true);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          barRect,
          Radius.circular(barWidth / 4),
        ),
        barPaint,
      );
      final highlightPaint = Paint()
        ..color = Colors.white.withOpacity(0.4)
        ..style = PaintingStyle.fill;

      final highlightRect = Rect.fromLTWH(
        barX + barWidth * 0.25,
        barY,
        barWidth * 0.5,
        animatedHeight * 0.1,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          highlightRect,
          Radius.circular(barWidth / 6),
        ),
        highlightPaint,
      );
      final labelSpan = TextSpan(
        text: item.label,
        style: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      );

      final labelPainter = TextPainter(
        text: labelSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );

      labelPainter.layout();
      labelPainter.paint(
        canvas,
        Offset(
          barX + barWidth / 2 - labelPainter.width / 2,
          size.height - bottomPadding + 4,
        ),
      );
      if (showValues && animation > 0.7) {
        final valueSpan = TextSpan(
          text: item.value.toStringAsFixed(0),
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        );

        final valuePainter = TextPainter(
          text: valueSpan,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        );

        valuePainter.layout();
        valuePainter.paint(
          canvas,
          Offset(
            barX + barWidth / 2 - valuePainter.width / 2,
            barY - valuePainter.height - 4,
          ),
        );
      }
    }
  }

  Color _getColorForIndex(int index) {
    final defaultColors = colorPalette ??
        [
          Colors.blueAccent,
          Colors.redAccent,
          Colors.greenAccent,
          Colors.purpleAccent,
          Colors.orangeAccent,
          Colors.tealAccent,
        ];

    return defaultColors[index % defaultColors.length];
  }

  @override
  bool shouldRepaint(BarChartPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}

class LineChartPainter extends CustomPainter {
  final List<AppChartData> data;
  final double animation;
  final List<Color>? colorPalette;
  final bool showValues;

  LineChartPainter({
    required this.data,
    required this.animation,
    this.colorPalette,
    this.showValues = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final chartAreaHeight = size.height * 0.85;
    final chartAreaWidth = size.width * 0.9;
    final leftPadding = size.width * 0.1;
    final bottomPadding = size.height * 0.1;
    double maxValue = data.map((e) => e.value).reduce(math.max);
    maxValue = (maxValue * 1.1).ceilToDouble();
    final baselinePaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(leftPadding, size.height - bottomPadding),
      Offset(size.width, size.height - bottomPadding),
      baselinePaint,
    );

    final gridLinePaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    final numGridLines = 5;
    for (int i = 1; i <= numGridLines; i++) {
      final y =
          size.height - bottomPadding - (i / numGridLines) * chartAreaHeight;
      canvas.drawLine(
        Offset(leftPadding, y),
        Offset(size.width, y),
        gridLinePaint,
      );

      final gridValue = (i / numGridLines * maxValue).toStringAsFixed(0);
      final textSpan = TextSpan(
        text: gridValue,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 10,
        ),
      );

      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.right,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(leftPadding - textPainter.width - 4, y - textPainter.height / 2),
      );
    }

    final pointWidth = chartAreaWidth / (data.length - 1);
    final pointRadius = 6.0;
    final linePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.primary.withOpacity(0.5),
        AppColors.primary.withOpacity(0.0),
      ],
    );

    final path = Path();
    final fillPath = Path();
    final animatedPath = Path();
    final animatedFillPath = Path();

    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final normalizedValue = item.value / maxValue;
      final x = leftPadding + i * pointWidth;
      final y = size.height - bottomPadding - normalizedValue * chartAreaHeight;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, y);

        if (animation > 0) {
          animatedPath.moveTo(x, y);
          animatedFillPath.moveTo(x, y);
        }
      } else {
        final prevX = leftPadding + (i - 1) * pointWidth;
        final prevY = size.height -
            bottomPadding -
            (data[i - 1].value / maxValue) * chartAreaHeight;

        final controlX = (x + prevX) / 2;

        path.quadraticBezierTo(controlX, prevY, x, y);
        fillPath.quadraticBezierTo(controlX, prevY, x, y);
        final segmentProgress = math.min(
            1.0, math.max(0.0, (animation * data.length - (i - 1)) / 1.0));

        if (segmentProgress > 0) {
          final animX = prevX + (x - prevX) * segmentProgress;
          final animY = prevY + (y - prevY) * segmentProgress;

          animatedPath.quadraticBezierTo(controlX, prevY, animX, animY);
          animatedFillPath.quadraticBezierTo(controlX, prevY, animX, animY);
          if (segmentProgress < 1.0) {
            final pointPaint = Paint()
              ..color = AppColors.primary
              ..style = PaintingStyle.fill
              ..strokeWidth = 2;
            final glowPaint = Paint()
              ..color = AppColors.primary.withOpacity(0.3)
              ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4);

            canvas.drawCircle(
                Offset(animX, animY), pointRadius * 1.5, glowPaint);

            canvas.drawCircle(Offset(animX, animY), pointRadius, pointPaint);
          }
        }
      }
    }

    fillPath.lineTo(leftPadding + (data.length - 1) * pointWidth,
        size.height - bottomPadding);
    fillPath.lineTo(leftPadding, size.height - bottomPadding);
    fillPath.close();
    if (animation < 1.0) {
      final lastPoint = animatedPath.getBounds().bottomRight;
      animatedFillPath.lineTo(lastPoint.dx, size.height - bottomPadding);
      animatedFillPath.lineTo(leftPadding, size.height - bottomPadding);
      animatedFillPath.close();
    } else {
      animatedFillPath.addPath(fillPath, Offset.zero);
    }
    final fillPaint = Paint()
      ..shader = gradient
          .createShader(Rect.fromLTWH(0, 0, size.width, chartAreaHeight))
      ..style = PaintingStyle.fill;

    canvas.drawPath(animatedFillPath, fillPaint);
    canvas.drawPath(animatedPath, linePaint);

    if (animation > 0.95) {
      for (int i = 0; i < data.length; i++) {
        final item = data[i];
        final normalizedValue = item.value / maxValue;
        final x = leftPadding + i * pointWidth;
        final y =
            size.height - bottomPadding - normalizedValue * chartAreaHeight;

        final pointPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

        final pointStrokePaint = Paint()
          ..color = AppColors.primary
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
        canvas.drawCircle(Offset(x, y), pointRadius, pointPaint);
        canvas.drawCircle(Offset(x, y), pointRadius, pointStrokePaint);
        final labelSpan = TextSpan(
          text: item.label,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        );

        final labelPainter = TextPainter(
          text: labelSpan,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.center,
        );

        labelPainter.layout();
        labelPainter.paint(
          canvas,
          Offset(
            x - labelPainter.width / 2,
            size.height - bottomPadding + 4,
          ),
        );

        // Draw value if enabled
        if (showValues) {
          final valueSpan = TextSpan(
            text: item.value.toStringAsFixed(0),
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          );

          final valuePainter = TextPainter(
            text: valueSpan,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
          );

          valuePainter.layout();
          valuePainter.paint(
            canvas,
            Offset(
              x - valuePainter.width / 2,
              y - pointRadius - valuePainter.height - 4,
            ),
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(LineChartPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}
