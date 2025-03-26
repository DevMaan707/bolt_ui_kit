import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import '../theme/app_colors.dart';
import 'permission_handler.dart';

class QRScannerUtil {
  // Singleton instance
  static final QRScannerUtil _instance = QRScannerUtil._internal();
  factory QRScannerUtil() => _instance;
  QRScannerUtil._internal();

  // Scan QR code with a beautiful UI
  Future<String?> scanQR({
    String? title,
    String? cancelButtonText,
    Color? primaryColor,
    String? scanInstructions,
    bool showFlashlight = true,
    bool vibrate = true,
    ScannerTheme? theme,
  }) async {
    bool hasPermission = await _checkCameraPermission();
    if (!hasPermission) return null;

    primaryColor ??= AppColors.primary;
    final scannerTheme = theme ??
        ScannerTheme(
          primaryColor: primaryColor,
          scanAreaWidth: 260,
          scanAreaHeight: 260,
        );

    final result = await Get.to<String>(
      () => QRScannerScreen(
        title: title ?? 'Scan QR Code',
        cancelButtonText: cancelButtonText ?? 'Cancel',
        scanInstructions:
            scanInstructions ?? 'Position the QR code within the frame to scan',
        theme: scannerTheme,
        showFlashlight: showFlashlight,
        vibrate: vibrate,
      ),
      transition: Transition.downToUp,
      fullscreenDialog: true,
    );

    return result;
  }

  // Check camera permission
  Future<bool> _checkCameraPermission() async {
    final permissionUtil = PermissionUtil();
    return await permissionUtil.request(
      permission: Permission.camera,
      icon: Icons.camera_alt_rounded,
      iconColor: Colors.blue,
    );
  }
}

class QRScannerScreen extends StatefulWidget {
  final String title;
  final String cancelButtonText;
  final String scanInstructions;
  final ScannerTheme theme;
  final bool showFlashlight;
  final bool vibrate;

  const QRScannerScreen({
    Key? key,
    required this.title,
    required this.cancelButtonText,
    required this.scanInstructions,
    required this.theme,
    required this.showFlashlight,
    required this.vibrate,
  }) : super(key: key);

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen>
    with SingleTickerProviderStateMixin {
  late MobileScannerController _controller;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isFlashlightOn = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );

    // Setup animation for scan line
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    )..addListener(() {
        setState(() {});
      });

    _animationController.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (widget.showFlashlight)
            IconButton(
              icon: Icon(
                _isFlashlightOn ? Icons.flash_on : Icons.flash_off,
                color: Colors.white,
              ),
              onPressed: () {
                _controller.toggleTorch();
                setState(() {
                  _isFlashlightOn = !_isFlashlightOn;
                });
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          // QR Scanner
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && barcodes[0].rawValue != null) {
                final String code = barcodes[0].rawValue!;

                // If vibrate is enabled, use haptic feedback
                if (widget.vibrate) {
                  HapticFeedback.heavyImpact();
                }

                _controller.stop();
                Navigator.of(context).pop(code);
              }
            },
          ),

          // Overlay with scan area
          _buildScannerOverlay(),

          // Scan instructions
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              alignment: Alignment.center,
              child: Text(
                widget.scanInstructions,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          // Cancel button
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  widget.cancelButtonText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerOverlay() {
    final scanAreaWidth = widget.theme.scanAreaWidth;
    final scanAreaHeight = widget.theme.scanAreaHeight;
    final cornerSize = widget.theme.cornerSize;
    final cornerColor = widget.theme.primaryColor;
    final primaryColor = widget.theme.primaryColor;

    return Stack(
      children: [
        // Semi-transparent overlay with hole in the middle
        Container(
          width: double.infinity,
          height: double.infinity,
          child: CustomPaint(
            painter: ScannerOverlayPainter(
              scanAreaWidth: scanAreaWidth,
              scanAreaHeight: scanAreaHeight,
              overlayColor: widget.theme.overlayColor,
            ),
          ),
        ),

        // Center positioning for scan area
        Center(
          child: Container(
            width: scanAreaWidth,
            height: scanAreaHeight,
            child: Stack(
              children: [
                // Corner indicators
                Positioned(
                  left: 0,
                  top: 0,
                  child: _buildCorner(cornerColor, cornerSize, topLeft: true),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: _buildCorner(cornerColor, cornerSize, topRight: true),
                ),
                Positioned(
                  left: 0,
                  bottom: 0,
                  child:
                      _buildCorner(cornerColor, cornerSize, bottomLeft: true),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child:
                      _buildCorner(cornerColor, cornerSize, bottomRight: true),
                ),

                // Animated scan line
                Positioned(
                  top: scanAreaHeight * _animation.value - 1,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          primaryColor.withOpacity(0.8),
                          primaryColor,
                          primaryColor.withOpacity(0.8),
                          Colors.transparent,
                        ],
                        stops: [0.0, 0.2, 0.5, 0.8, 1.0],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCorner(
    Color color,
    double size, {
    bool topLeft = false,
    bool topRight = false,
    bool bottomLeft = false,
    bool bottomRight = false,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: topLeft || bottomLeft ? color : Colors.transparent,
            width: 3,
          ),
          top: BorderSide(
            color: topLeft || topRight ? color : Colors.transparent,
            width: 3,
          ),
          right: BorderSide(
            color: topRight || bottomRight ? color : Colors.transparent,
            width: 3,
          ),
          bottom: BorderSide(
            color: bottomLeft || bottomRight ? color : Colors.transparent,
            width: 3,
          ),
        ),
      ),
    );
  }
}

// Custom painter for scanner overlay
class ScannerOverlayPainter extends CustomPainter {
  final double scanAreaWidth;
  final double scanAreaHeight;
  final Color overlayColor;

  ScannerOverlayPainter({
    required this.scanAreaWidth,
    required this.scanAreaHeight,
    this.overlayColor = const Color(0x88000000),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final scanAreaLeft = centerX - scanAreaWidth / 2;
    final scanAreaTop = centerY - scanAreaHeight / 2;

    final backgroundPaint = Paint()
      ..color = overlayColor
      ..style = PaintingStyle.fill;

    // Create path for the entire screen with a hole for the scan area
    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRect(Rect.fromLTWH(
        scanAreaLeft,
        scanAreaTop,
        scanAreaWidth,
        scanAreaHeight,
      ))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(backgroundPath, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Theme for the scanner UI
class ScannerTheme {
  final Color primaryColor;
  final Color overlayColor;
  final double scanAreaWidth;
  final double scanAreaHeight;
  final double cornerSize;

  ScannerTheme({
    required this.primaryColor,
    this.overlayColor = const Color(0x88000000),
    this.scanAreaWidth = 260,
    this.scanAreaHeight = 260,
    this.cornerSize = 40,
  });
}
