import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_themes.dart';
import '../../components/navbar/navbar.dart';
import '../buttons/buttons.dart';
import '../cards/cards.dart';
import 'pdf_controller.dart';

enum PDFViewSource { file, network, asset }

class BoltPDFViewer extends StatefulWidget {
  /// File path for local files
  final String? filePath;

  /// URL for network PDFs
  final String? url;

  /// Asset path for PDF assets
  final String? assetPath;

  /// Source type of the PDF
  final PDFViewSource source;

  /// Whether to enable PDF page navigation
  final bool enableNavigation;

  /// Whether to show the page counter
  final bool showPageCounter;

  /// Whether to show toolbar with actions
  final bool showToolbar;

  /// Whether to enable text selection
  final bool enableTextSelection;
  final String? password;
  final int defaultPage;
  final Color? loadingColor;
  final String? title;
  final List<Widget>? toolbarActions;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Color? backgroundColor;
  final Function(PDFViewController)? onViewCreated;
  final Function(int)? onPageChanged;
  final Function(dynamic)? onError;

  final bool isModal;

  const BoltPDFViewer({
    super.key,
    this.filePath,
    this.url,
    this.assetPath,
    this.source = PDFViewSource.file,
    this.enableNavigation = true,
    this.showPageCounter = true,
    this.showToolbar = true,
    this.enableTextSelection = true,
    this.password,
    this.defaultPage = 0,
    this.loadingColor,
    this.title,
    this.toolbarActions,
    this.loadingWidget,
    this.errorWidget,
    this.backgroundColor,
    this.onViewCreated,
    this.onPageChanged,
    this.onError,
    this.isModal = false,
  }) : assert(
          (source == PDFViewSource.file && filePath != null) ||
              (source == PDFViewSource.network && url != null) ||
              (source == PDFViewSource.asset && assetPath != null),
          'Must provide a filePath for file source, a url for network source, or an assetPath for asset source',
        );
  static Future<void> showPdfDialog({
    required BuildContext context,
    String? filePath,
    String? url,
    String? assetPath,
    PDFViewSource source = PDFViewSource.file,
    String? title,
    bool barrierDismissible = true,
    bool enableNavigation = true,
    bool enableTextSelection = true,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.8,
            child: BoltPDFViewer(
              filePath: filePath,
              url: url,
              assetPath: assetPath,
              source: source,
              title: title,
              enableNavigation: enableNavigation,
              enableTextSelection: enableTextSelection,
              isModal: true,
            ),
          ),
        ),
      ),
    );
  }

  static Future<void> openPdf({
    required BuildContext context,
    String? filePath,
    String? url,
    String? assetPath,
    PDFViewSource source = PDFViewSource.file,
    String? title,
    bool enableNavigation = true,
    bool enableTextSelection = true,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BoltPDFViewer(
          filePath: filePath,
          url: url,
          assetPath: assetPath,
          source: source,
          title: title,
          enableNavigation: enableNavigation,
          enableTextSelection: enableTextSelection,
        ),
      ),
    );
  }

  @override
  State<BoltPDFViewer> createState() => _BoltPDFViewerState();
}

class _BoltPDFViewerState extends State<BoltPDFViewer>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  bool _hasError = false;
  String? _pdfPath;
  int _currentPage = 0;
  int _totalPages = 0;
  PDFViewController? _pdfViewController;
  String? _errorMessage;
  double _currentZoom = 1.0;
  bool _isFullScreen = false;
  final PDFViewerController _pdfController = PDFViewerController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isControlsVisible = true;
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    _loadPDF();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isDark = Theme.of(context).brightness == Brightness.dark;
  }

  Future<void> _loadPDF() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      switch (widget.source) {
        case PDFViewSource.file:
          _pdfPath = widget.filePath;
          break;

        case PDFViewSource.network:
          _pdfPath = await _downloadPDF(widget.url!);
          break;

        case PDFViewSource.asset:
          // For asset paths, the PDFView widget expects assets prefix
          _pdfPath = widget.assetPath;
          break;
      }

      if (_pdfPath != null) {
        setState(() {
          _isLoading = false;
        });
      } else {
        _setError('Failed to load PDF');
      }
    } catch (e) {
      _setError('Error loading PDF: $e');
    }
  }

  Future<String> _downloadPDF(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final fileName = url.split('/').last;
        final filePath = '${tempDir.path}/$fileName';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      } else {
        throw Exception('Failed to download PDF: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error downloading PDF: $e');
    }
  }

  void _setError(String message) {
    setState(() {
      _hasError = true;
      _isLoading = false;
      _errorMessage = message;
    });
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
  }

  void _toggleControls() {
    setState(() {
      _isControlsVisible = !_isControlsVisible;
      if (_isControlsVisible) {
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final defaultBackgroundColor =
        isDarkMode ? Colors.grey[900] : Colors.grey[50];

    return Scaffold(
      backgroundColor: widget.backgroundColor ?? defaultBackgroundColor,
      appBar: !_isFullScreen && widget.showToolbar && !widget.isModal
          ? Navbar(
              title: widget.title ?? 'PDF Viewer',
              style: isDarkMode ? NavbarStyle.elevated : NavbarStyle.standard,
              backgroundColor:
                  isDarkMode ? Colors.grey[850] : AppColors.primary,
              titleColor: Colors.white,
              actions: [
                ...?widget.toolbarActions,
                IconButton(
                  icon: Icon(
                      _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
                  onPressed: _toggleFullScreen,
                ),
              ],
            )
          : widget.isModal && widget.showToolbar
              ? PreferredSize(
                  preferredSize: Size.fromHeight(56.h),
                  child: AppBar(
                    title: Text(
                      widget.title ?? 'PDF Viewer',
                      style: AppTextThemes.heading6(color: Colors.white),
                    ),
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    leading: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    centerTitle: true,
                  ),
                )
              : null,
      body: GestureDetector(
        onTap: () {
          if (!_isLoading && !_hasError) {
            _toggleControls();
          }
        },
        child: Column(
          children: [
            Expanded(
              child: _buildPDFView(),
            ),
            if (!_isFullScreen &&
                widget.enableNavigation &&
                !_isLoading &&
                !_hasError &&
                _isControlsVisible)
              _buildNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildPDFView() {
    if (_isLoading) {
      return _buildLoadingWidget();
    }

    if (_hasError) {
      return _buildErrorWidget();
    }

    return Stack(
      children: [
        PDFView(
          filePath: _pdfPath,
          enableSwipe: widget.enableNavigation,
          swipeHorizontal: true,
          autoSpacing: true,
          pageFling: true,
          pageSnap: true,
          defaultPage: widget.defaultPage,
          fitPolicy: FitPolicy.BOTH,
          preventLinkNavigation: false,
          password: widget.password,
          nightMode: _isDark,
          onRender: (pages) {
            setState(() {
              _totalPages = pages!;
              _isLoading = false;
            });
          },
          onError: (error) {
            setState(() {
              _hasError = true;
              _errorMessage = error.toString();
            });
            if (widget.onError != null) {
              widget.onError!(error);
            }
          },
          onPageError: (page, error) {
            print('Error while loading page $page: $error');
          },
          onViewCreated: (PDFViewController controller) {
            _pdfViewController = controller;
            _pdfController.setController(controller);
            if (widget.onViewCreated != null) {
              widget.onViewCreated!(controller);
            }
          },
          onPageChanged: (int? page, int? total) {
            if (page != null) {
              setState(() {
                _currentPage = page;
              });
              if (widget.onPageChanged != null) {
                widget.onPageChanged!(page);
              }
            }
          },
        ),
        if (_isFullScreen)
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: 1.0 - _fadeAnimation.value,
                child: Visibility(
                  visible: _isControlsVisible,
                  child: child!,
                ),
              );
            },
            child: Positioned(
              top: MediaQuery.of(context).padding.top + 16.h,
              right: 16.w,
              child: Material(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(25.r),
                child: IconButton(
                  icon: const Icon(Icons.fullscreen_exit, color: Colors.white),
                  onPressed: _toggleFullScreen,
                ),
              ),
            ),
          ),
        if (widget.showPageCounter && !_isLoading && !_hasError)
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: 1.0 - _fadeAnimation.value,
                child: Visibility(
                  visible: _isControlsVisible,
                  child: child!,
                ),
              );
            },
            child: Positioned(
              bottom: 20.h,
              right: 20.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  '${_currentPage + 1} of $_totalPages',
                  style: AppTextThemes.bodyMedium(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNavigationBar() {
    final isWideScreen = MediaQuery.of(context).size.width > 600.w;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 8.h,
        horizontal: isWideScreen ? 24.w : 16.w,
      ),
      decoration: BoxDecoration(
        color: _isDark ? Colors.grey[850] : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Navigation controls group
          Row(
            children: [
              IconButton(
                icon:
                    Icon(Icons.first_page, size: isWideScreen ? 24.sp : 20.sp),
                color: AppColors.primary,
                onPressed: _currentPage > 0
                    ? () {
                        _pdfViewController?.setPage(0);
                      }
                    : null,
                tooltip: 'First Page',
              ),
              IconButton(
                icon: Icon(Icons.arrow_back_ios,
                    size: isWideScreen ? 20.sp : 16.sp),
                color: AppColors.primary,
                onPressed: _currentPage > 0
                    ? () {
                        _pdfViewController?.setPage(_currentPage - 1);
                      }
                    : null,
                tooltip: 'Previous Page',
              ),
              if (isWideScreen)
                SizedBox(
                  width: 70.w,
                  child: Text(
                    '${_currentPage + 1} / $_totalPages',
                    style:
                        AppTextThemes.bodyMedium(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                )
              else
                Text(
                  '${_currentPage + 1}',
                  style: AppTextThemes.bodyMedium(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios,
                    size: isWideScreen ? 20.sp : 16.sp),
                color: AppColors.primary,
                onPressed: _currentPage < _totalPages - 1
                    ? () {
                        _pdfViewController?.setPage(_currentPage + 1);
                      }
                    : null,
                tooltip: 'Next Page',
              ),
              IconButton(
                icon: Icon(Icons.last_page, size: isWideScreen ? 24.sp : 20.sp),
                color: AppColors.primary,
                onPressed: _currentPage < _totalPages - 1
                    ? () {
                        _pdfViewController?.setPage(_totalPages - 1);
                      }
                    : null,
                tooltip: 'Last Page',
              ),
            ],
          ),

          // Action buttons
          Row(
            children: [
              if (isWideScreen)
                Button(
                  text: 'Jump to Page',
                  type: ButtonType.outlined,
                  size: ButtonSize.small,
                  onPressed: () => _showJumpToPageDialog(),
                  icon: Icons.keyboard_tab_rounded,
                )
              else
                IconButton(
                  icon: Icon(Icons.keyboard_tab_rounded, size: 20.sp),
                  color: AppColors.primary,
                  onPressed: () => _showJumpToPageDialog(),
                  tooltip: 'Jump to Page',
                ),
              SizedBox(width: 8.w),
              IconButton(
                icon: Icon(Icons.zoom_in, size: isWideScreen ? 24.sp : 20.sp),
                color: AppColors.primary,
                onPressed: () {
                  // Zoom in functionality
                  _currentZoom += 0.25;
                  // Zoom functionality would be implemented based on PDF library capabilities
                },
                tooltip: 'Zoom In',
              ),
              IconButton(
                icon: Icon(
                  _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                  size: isWideScreen ? 24.sp : 20.sp,
                ),
                color: AppColors.primary,
                onPressed: _toggleFullScreen,
                tooltip: _isFullScreen ? 'Exit Fullscreen' : 'Fullscreen',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget() {
    if (widget.loadingWidget != null) {
      return widget.loadingWidget!;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: CircularProgressIndicator(
              color: widget.loadingColor ?? AppColors.primary,
              strokeWidth: 3.w,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Loading PDF...',
            style: AppTextThemes.bodyLarge(
              fontWeight: FontWeight.w500,
              color: _isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),
          if (widget.source == PDFViewSource.network)
            Text(
              'Downloading file...',
              style: AppTextThemes.bodySmall(
                color: _isDark ? Colors.white60 : Colors.black54,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    if (widget.errorWidget != null) {
      return widget.errorWidget!;
    }

    return Center(
      child: AppCard(
        type: CardType.elevated,
        margin: EdgeInsets.all(24.w),
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                color: AppColors.error,
                size: 48.w,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Failed to load PDF',
              style: AppTextThemes.heading6(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              _errorMessage ?? 'An unknown error occurred',
              style: AppTextThemes.bodyMedium(
                color: _isDark ? Colors.white70 : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            Button(
              text: 'Retry',
              type: ButtonType.primary,
              size: ButtonSize.medium,
              icon: Icons.refresh,
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _hasError = false;
                });
                _loadPDF();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showJumpToPageDialog() {
    final TextEditingController pageController = TextEditingController();
    final isWideScreen = MediaQuery.of(context).size.width > 600.w;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Container(
            width: isWideScreen ? 400.w : null,
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Jump to Page',
                  style: AppTextThemes.heading5(),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Enter a page number between 1 and $_totalPages',
                  style: AppTextThemes.bodyMedium(),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                TextField(
                  controller: pageController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  autofocus: true,
                  style: AppTextThemes.bodyLarge(fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    hintText: 'Page number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: _isDark ? Colors.grey[600]! : Colors.grey[300]!,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: AppColors.primary,
                        width: 2.w,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    filled: true,
                    fillColor: _isDark ? Colors.grey[800] : Colors.grey[50],
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Button(
                      text: 'Cancel',
                      type: ButtonType.outlined,
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 12.w),
                    Button(
                      text: 'Jump',
                      type: ButtonType.primary,
                      onPressed: () {
                        final pageNumber = int.tryParse(pageController.text);
                        if (pageNumber != null &&
                            pageNumber > 0 &&
                            pageNumber <= _totalPages) {
                          _pdfViewController?.setPage(pageNumber - 1);
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
