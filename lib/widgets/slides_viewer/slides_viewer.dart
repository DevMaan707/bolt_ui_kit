import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_themes.dart';
import '../../components/navbar/navbar.dart';
import '../buttons/buttons.dart';
import '../cards/cards.dart';

enum SlidesSourceType { file, network, googleSlides, pptx, pdf }

class BoltSlidesViewer extends StatefulWidget {
  /// File path for local presentation files
  final String? filePath;

  /// URL for network presentations
  final String? url;

  /// Google Slides ID for direct viewing
  final String? googleSlidesId;

  /// Source type of the presentation
  final SlidesSourceType sourceType;

  /// Whether to enable slide navigation
  final bool enableNavigation;

  /// Whether to show the slide counter
  final bool showSlideCounter;

  /// Whether to show toolbar with actions
  final bool showToolbar;

  /// Whether to enable interactions like zooming
  final bool enableInteractions;

  /// Starting slide index (1-based)
  final int initialSlide;

  /// Loading color (overrides theme)
  final Color? loadingColor;

  /// Title of the viewer
  final String? title;

  /// Custom toolbar actions
  final List<Widget>? toolbarActions;

  /// Custom loading widget
  final Widget? loadingWidget;

  /// Custom error widget
  final Widget? errorWidget;

  /// Background color (overrides theme)
  final Color? backgroundColor;

  /// Callback when current slide changes
  final Function(int)? onSlideChanged;

  /// Callback when an error occurs
  final Function(dynamic)? onError;

  /// Whether viewer is displayed as a modal
  final bool isModal;

  /// Whether to enable presentation mode (full screen)
  final bool presentationMode;

  /// Convert format to PDF for better viewing (when applicable)
  final bool convertToPdf;

  const BoltSlidesViewer({
    super.key,
    this.filePath,
    this.url,
    this.googleSlidesId,
    required this.sourceType,
    this.enableNavigation = true,
    this.showSlideCounter = true,
    this.showToolbar = true,
    this.enableInteractions = true,
    this.initialSlide = 1,
    this.loadingColor,
    this.title,
    this.toolbarActions,
    this.loadingWidget,
    this.errorWidget,
    this.backgroundColor,
    this.onSlideChanged,
    this.onError,
    this.isModal = false,
    this.presentationMode = false,
    this.convertToPdf = true,
  }) : assert(
          (sourceType == SlidesSourceType.file && filePath != null) ||
              (sourceType == SlidesSourceType.network && url != null) ||
              (sourceType == SlidesSourceType.googleSlides &&
                  googleSlidesId != null) ||
              (sourceType == SlidesSourceType.pptx &&
                  (filePath != null || url != null)) ||
              (sourceType == SlidesSourceType.pdf &&
                  (filePath != null || url != null)),
          'Must provide appropriate path/url based on source type',
        );

  static Future<void> showSlidesDialog({
    required BuildContext context,
    String? filePath,
    String? url,
    String? googleSlidesId,
    required SlidesSourceType sourceType,
    String? title,
    bool barrierDismissible = true,
    bool enableNavigation = true,
    bool enableInteractions = true,
    int initialSlide = 1,
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
            child: BoltSlidesViewer(
              filePath: filePath,
              url: url,
              googleSlidesId: googleSlidesId,
              sourceType: sourceType,
              title: title,
              enableNavigation: enableNavigation,
              enableInteractions: enableInteractions,
              isModal: true,
              initialSlide: initialSlide,
            ),
          ),
        ),
      ),
    );
  }

  static Future<void> openSlidesViewer({
    required BuildContext context,
    String? filePath,
    String? url,
    String? googleSlidesId,
    required SlidesSourceType sourceType,
    String? title,
    bool enableNavigation = true,
    bool enableInteractions = true,
    bool presentationMode = false,
    int initialSlide = 1,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BoltSlidesViewer(
          filePath: filePath,
          url: url,
          googleSlidesId: googleSlidesId,
          sourceType: sourceType,
          title: title,
          enableNavigation: enableNavigation,
          enableInteractions: enableInteractions,
          presentationMode: presentationMode,
          initialSlide: initialSlide,
        ),
      ),
    );
  }

  @override
  State<BoltSlidesViewer> createState() => _BoltSlidesViewerState();
}

class _BoltSlidesViewerState extends State<BoltSlidesViewer>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  bool _hasError = false;
  String? _processedPath;
  String? _errorMessage;
  bool _isFullScreen = false;
  int _currentSlide = 0; // 0-indexed internally
  int _totalSlides = 0;
  bool _isDark = false;
  bool _isControlsVisible = true;
  WebViewController? _webViewController;
  PDFViewController? _pdfViewController;
  bool _isWebView = false;
  bool _isPdfView = false;
  bool _isInternetConnected = true;
  bool _isConvertingToPdf = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _currentSlide = widget.initialSlide - 1; // Convert to 0-indexed
    _isFullScreen = widget.presentationMode;
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

    _checkInternetConnection();
    _loadPresentation();
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

  Future<void> _checkInternetConnection() async {
    _isInternetConnected = await InternetConnectionChecker().hasConnection;
    if (!_isInternetConnected &&
        (widget.sourceType == SlidesSourceType.network ||
            widget.sourceType == SlidesSourceType.googleSlides)) {
      _setError(
          'No internet connection. Please check your connection and try again.');
    }
  }

  Future<void> _loadPresentation() async {
    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      // Determine if we're using WebView or PDF viewer
      if (widget.sourceType == SlidesSourceType.googleSlides) {
        _isWebView = true;
        _isPdfView = false;
        _processedPath = _getGoogleSlidesEmbedUrl(widget.googleSlidesId!);
      } else if (widget.sourceType == SlidesSourceType.file) {
        if (widget.filePath!.toLowerCase().endsWith('.pdf')) {
          _isPdfView = true;
          _isWebView = false;
          _processedPath = widget.filePath;
        } else if (widget.filePath!.toLowerCase().endsWith('.pptx')) {
          if (widget.convertToPdf) {
            _isConvertingToPdf = true;
            await _convertPptxToPdf();
            _isPdfView = true;
            _isWebView = false;
          } else {
            // Can't show PPTX directly - use office web viewer
            _isWebView = true;
            _isPdfView = false;
            _processedPath = _getOfficeOnlineViewerUrl(widget.filePath!);
          }
        } else {
          _setError('Unsupported file format. Please use PDF or PPTX files.');
        }
      } else if (widget.sourceType == SlidesSourceType.network) {
        if (widget.url!.toLowerCase().endsWith('.pdf')) {
          _isPdfView = true;
          _isWebView = false;
          _processedPath = await _downloadFile(widget.url!);
        } else if (widget.url!.toLowerCase().endsWith('.pptx')) {
          if (widget.convertToPdf) {
            _isConvertingToPdf = true;
            String tempPath = await _downloadFile(widget.url!);
            _processedPath = await _convertRemotePptxToPdf(tempPath);
            _isPdfView = true;
            _isWebView = false;
            _isConvertingToPdf = false;
          } else {
            // Use Office Online viewer for PPTX
            _isWebView = true;
            _isPdfView = false;
            _processedPath = _getOfficeOnlineViewerUrl(widget.url!);
          }
        } else if (_isGoogleSlidesUrl(widget.url!)) {
          _isWebView = true;
          _isPdfView = false;
          _processedPath = _convertGoogleSlidesLinkToEmbed(widget.url!);
        } else {
          // Try to use Office Online viewer for other formats
          _isWebView = true;
          _isPdfView = false;
          _processedPath = _getOfficeOnlineViewerUrl(widget.url!);
        }
      } else if (widget.sourceType == SlidesSourceType.pptx) {
        if (widget.filePath != null) {
          if (widget.convertToPdf) {
            _isConvertingToPdf = true;
            await _convertPptxToPdf();
            _isPdfView = true;
            _isWebView = false;
          } else {
            _isWebView = true;
            _isPdfView = false;
            _processedPath = _getOfficeOnlineViewerUrl(widget.filePath!);
          }
        } else if (widget.url != null) {
          if (widget.convertToPdf) {
            _isConvertingToPdf = true;
            String tempPath = await _downloadFile(widget.url!);
            _processedPath = await _convertRemotePptxToPdf(tempPath);
            _isPdfView = true;
            _isWebView = false;
            _isConvertingToPdf = false;
          } else {
            _isWebView = true;
            _isPdfView = false;
            _processedPath = _getOfficeOnlineViewerUrl(widget.url!);
          }
        }
      } else if (widget.sourceType == SlidesSourceType.pdf) {
        _isPdfView = true;
        _isWebView = false;
        if (widget.filePath != null) {
          _processedPath = widget.filePath;
        } else if (widget.url != null) {
          _processedPath = await _downloadFile(widget.url!);
        }
      }

      if (_processedPath != null) {
        setState(() {
          _isLoading = false;
        });
      } else {
        _setError('Failed to load presentation');
      }
    } catch (e) {
      _setError('Error loading presentation: $e');
      if (widget.onError != null) {
        widget.onError!(e);
      }
    }
  }

  Future<String> _downloadFile(String url) async {
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
        throw Exception('Failed to download file: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error downloading file: $e');
    }
  }

  // Note: In a real implementation, you would need a server-side component or library to convert PPTX to PDF.
  // This is a placeholder for that functionality.
  Future<void> _convertPptxToPdf() async {
    // In a real implementation, this would use a conversion library or API
    // For now, we simulate a conversion delay and set an error
    await Future.delayed(const Duration(seconds: 2));
    _setError(
        'PPTX to PDF conversion requires a server-side component or native plugin.');
    // In reality you would convert the file and update _processedPath
  }

  // Similar placeholder for remote file conversion
  Future<String> _convertRemotePptxToPdf(String localPptxPath) async {
    // In a real implementation, this would use a conversion library or API
    await Future.delayed(const Duration(seconds: 2));
    _setError(
        'PPTX to PDF conversion requires a server-side component or native plugin.');
    return localPptxPath; // Return the original path, which won't work
  }

  String _getGoogleSlidesEmbedUrl(String slideId) {
    // Format for embedding: https://docs.google.com/presentation/d/{id}/embed
    // For specific slide, add ?slide=id.{slideNum}
    String baseUrl = 'https://docs.google.com/presentation/d/$slideId/embed';
    if (_currentSlide > 0) {
      baseUrl += '?slide=id.p$_currentSlide';
    }
    return baseUrl;
  }

  bool _isGoogleSlidesUrl(String url) {
    return url.contains('docs.google.com/presentation');
  }

  String _convertGoogleSlidesLinkToEmbed(String url) {
    // Convert sharing URL to embed URL
    // Example: https://docs.google.com/presentation/d/{id}/edit -> https://docs.google.com/presentation/d/{id}/embed
    Uri uri = Uri.parse(url);
    String path = uri.path;

    // Extract the ID
    RegExp regExp = RegExp(r'\/d\/([^\/]+)');
    Match? match = regExp.firstMatch(path);
    if (match != null && match.groupCount >= 1) {
      String slideId = match.group(1)!;
      return 'https://docs.google.com/presentation/d/$slideId/embed';
    }

    // If we can't parse it properly, try simple replacement
    return url.replaceAll('/edit', '/embed').replaceAll('/pub', '/embed');
  }

  String _getOfficeOnlineViewerUrl(String filePath) {
    // For Microsoft's Office Online viewer
    // Note: Only works for publicly accessible files
    if (filePath.startsWith('http')) {
      return 'https://view.officeapps.live.com/op/embed.aspx?src=${Uri.encodeComponent(filePath)}';
    } else {
      _setError(
          'Cannot view local PPTX files without conversion. Please use a network URL or convert to PDF.');
      return '';
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

  Future<void> _nextSlide() async {
    if (_isPdfView && _pdfViewController != null) {
      if (_currentSlide < _totalSlides - 1) {
        await _pdfViewController!.setPage(_currentSlide + 1);
      }
    } else if (_isWebView && _webViewController != null) {
      // For Google Slides, navigate to next slide using JavaScript
      await _webViewController!.runJavaScript(
          'if(typeof SlidesApp !== "undefined") {SlidesApp.getActivePresentation().getSelection().getNextSlide();}');
      setState(() {
        _currentSlide++;
      });
    }
  }

  Future<void> _prevSlide() async {
    if (_isPdfView && _pdfViewController != null) {
      if (_currentSlide > 0) {
        await _pdfViewController!.setPage(_currentSlide - 1);
      }
    } else if (_isWebView && _webViewController != null) {
      // For Google Slides, navigate to previous slide using JavaScript
      await _webViewController!.runJavaScript(
          'if(typeof SlidesApp !== "undefined") {SlidesApp.getActivePresentation().getSelection().getPreviousSlide();}');
      setState(() {
        if (_currentSlide > 0) _currentSlide--;
      });
    }
  }

  Future<void> _jumpToSlide(int slideIndex) async {
    if (slideIndex < 0 || (_totalSlides > 0 && slideIndex >= _totalSlides))
      return;

    if (_isPdfView && _pdfViewController != null) {
      await _pdfViewController!.setPage(slideIndex);
    } else if (_isWebView && _webViewController != null) {
      // For Google Slides, navigate to specific slide
      if (widget.sourceType == SlidesSourceType.googleSlides) {
        // Need to reload with the specific slide parameter
        String newUrl = _getGoogleSlidesEmbedUrl(widget.googleSlidesId!);
        await _webViewController!.loadRequest(Uri.parse(newUrl));
      } else {
        // Try generic JavaScript approach
        await _webViewController!.runJavaScript(
            'if(typeof SlidesApp !== "undefined") {SlidesApp.getActivePresentation().getSlides()[\$slideIndex].selectAsCurrentSlide();}');
      }
      setState(() {
        _currentSlide = slideIndex;
      });
    }
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
              title: widget.title ?? 'Slides Viewer',
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
                      widget.title ?? 'Slides Viewer',
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
              child: _buildSlidesView(),
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

  Widget _buildSlidesView() {
    if (_isLoading) {
      return _buildLoadingWidget();
    }

    if (_isConvertingToPdf) {
      return _buildConvertingWidget();
    }

    if (_hasError) {
      return _buildErrorWidget();
    }

    return Stack(
      children: [
        if (_isWebView)
          _buildWebView()
        else if (_isPdfView)
          _buildPdfView()
        else
          Center(child: Text('Unsupported presentation format')),
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
        if (widget.showSlideCounter &&
            !_isLoading &&
            !_hasError &&
            _totalSlides > 0)
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
                  '${_currentSlide + 1}${_totalSlides > 0 ? ' of $_totalSlides' : ''}',
                  style: AppTextThemes.bodyMedium(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        if (widget.enableNavigation &&
            _isControlsVisible &&
            !_isLoading &&
            !_hasError)
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: 1.0 - _fadeAnimation.value,
                child: child!,
              );
            },
            child: Positioned.fill(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: _prevSlide,
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _nextSlide,
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildWebView() {
    // Create the WebView controller
    final webViewWidget = WebViewWidget(
      controller: _createWebViewController(),
    );

    // Return the WebView
    return webViewWidget;
  }

  WebViewController _createWebViewController() {
    // Create controller first
    WebViewController webController = WebViewController();

    // Configure the controller
    webController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(widget.backgroundColor ?? Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });

            // Use webController here since it's already defined
            _getTotalSlidesCount(webController);
          },
          onWebResourceError: (WebResourceError error) {
            print('WebView error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(_processedPath!));

    // Store the controller reference
    _webViewController = webController;
    return webController;
  }

  // Separate method to get total slides count
  Future<void> _getTotalSlidesCount(WebViewController controller) async {
    // Add a small delay to ensure the page is fully loaded
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final result = await controller.runJavaScriptReturningResult(
          'if(typeof SlidesApp !== "undefined") { '
          'var totalSlides = SlidesApp.getActivePresentation().getSlides().length; '
          'totalSlides;'
          '} else { 0 }');

      if (result != null) {
        final count = int.tryParse(result.toString());
        if (count != null) {
          setState(() {
            _totalSlides = count;
          });
        }
      }
    } catch (e) {
      print('Error getting total slides count: $e');
      // Optionally retry after a delay
      if (mounted) {
        Future.delayed(const Duration(seconds: 1), () {
          _getTotalSlidesCount(controller);
        });
      }
    }
  }

  Widget _buildPdfView() {
    return PDFView(
      filePath: _processedPath,
      enableSwipe: widget.enableNavigation,
      swipeHorizontal: true,
      autoSpacing: true,
      pageFling: true,
      pageSnap: true,
      defaultPage: _currentSlide,
      fitPolicy: FitPolicy.BOTH,
      nightMode: _isDark,
      onRender: (pages) {
        setState(() {
          _totalSlides = pages!;
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
      },
      onPageChanged: (int? page, int? total) {
        if (page != null) {
          setState(() {
            _currentSlide = page;
          });
          if (widget.onSlideChanged != null) {
            widget.onSlideChanged!(page);
          }
        }
      },
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
            'Loading Presentation...',
            style: AppTextThemes.bodyLarge(
              fontWeight: FontWeight.w500,
              color: _isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),
          if (widget.sourceType == SlidesSourceType.network ||
              widget.sourceType == SlidesSourceType.googleSlides)
            Text(
              'Downloading content...',
              style: AppTextThemes.bodySmall(
                color: _isDark ? Colors.white60 : Colors.black54,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildConvertingWidget() {
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
            'Converting Presentation...',
            style: AppTextThemes.bodyLarge(
              fontWeight: FontWeight.w500,
              color: _isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'This may take a moment',
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
              'Failed to load presentation',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                    _loadPresentation();
                  },
                ),
                SizedBox(width: 12.w),
                if (widget.sourceType == SlidesSourceType.network ||
                    widget.sourceType == SlidesSourceType.googleSlides)
                  Button(
                    text: 'Open in Browser',
                    type: ButtonType.outlined,
                    size: ButtonSize.medium,
                    icon: Icons.open_in_browser,
                    onPressed: () => _openInBrowser(),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openInBrowser() async {
    String? urlToLaunch;

    if (widget.sourceType == SlidesSourceType.googleSlides) {
      // Format for viewing: https://docs.google.com/presentation/d/{id}/view
      urlToLaunch =
          'https://docs.google.com/presentation/d/${widget.googleSlidesId}/view';
    } else if (widget.sourceType == SlidesSourceType.network) {
      urlToLaunch = widget.url;
    }

    if (urlToLaunch != null) {
      final Uri uri = Uri.parse(urlToLaunch);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $urlToLaunch')),
        );
      }
    }
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
                onPressed: _currentSlide > 0 ? () => _jumpToSlide(0) : null,
                tooltip: 'First Slide',
              ),
              IconButton(
                icon: Icon(Icons.arrow_back_ios,
                    size: isWideScreen ? 20.sp : 16.sp),
                color: AppColors.primary,
                onPressed: _currentSlide > 0 ? _prevSlide : null,
                tooltip: 'Previous Slide',
              ),
              if (isWideScreen)
                SizedBox(
                  width: 70.w,
                  child: Text(
                    '${_currentSlide + 1}${_totalSlides > 0 ? ' / $_totalSlides' : ''}',
                    style:
                        AppTextThemes.bodyMedium(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                )
              else
                Text(
                  '\${_currentSlide + 1}',
                  style: AppTextThemes.bodyMedium(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios,
                    size: isWideScreen ? 20.sp : 16.sp),
                color: AppColors.primary,
                onPressed: _totalSlides > 0 && _currentSlide < _totalSlides - 1
                    ? _nextSlide
                    : null,
                tooltip: 'Next Slide',
              ),
              IconButton(
                icon: Icon(Icons.last_page, size: isWideScreen ? 24.sp : 20.sp),
                color: AppColors.primary,
                onPressed: _totalSlides > 0 && _currentSlide < _totalSlides - 1
                    ? () => _jumpToSlide(_totalSlides - 1)
                    : null,
                tooltip: 'Last Slide',
              ),
            ],
          ),

          // Action buttons
          Row(
            children: [
              if (_isWebView && isWideScreen)
                Button(
                  text: 'Refresh',
                  type: ButtonType.outlined,
                  size: ButtonSize.small,
                  onPressed: () => _webViewController?.reload(),
                  icon: Icons.refresh,
                )
              else if (_isWebView)
                IconButton(
                  icon: Icon(Icons.refresh, size: 20.sp),
                  color: AppColors.primary,
                  onPressed: () => _webViewController?.reload(),
                  tooltip: 'Refresh',
                ),
              if (isWideScreen &&
                  (widget.sourceType == SlidesSourceType.network ||
                      widget.sourceType == SlidesSourceType.googleSlides))
                Button(
                  text: 'Open in Browser',
                  type: ButtonType.outlined,
                  size: ButtonSize.small,
                  onPressed: () => _openInBrowser(),
                  icon: Icons.open_in_browser,
                )
              else if (widget.sourceType == SlidesSourceType.network ||
                  widget.sourceType == SlidesSourceType.googleSlides)
                IconButton(
                  icon: Icon(Icons.open_in_browser, size: 20.sp),
                  color: AppColors.primary,
                  onPressed: () => _openInBrowser(),
                  tooltip: 'Open in Browser',
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

  void _showJumpToSlideDialog() {
    final TextEditingController slideController = TextEditingController();
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
                  'Jump to Slide',
                  style: AppTextThemes.heading5(),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Enter a slide number between 1 and ${_totalSlides > 0 ? _totalSlides : '?'}',
                  style: AppTextThemes.bodyMedium(),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                TextField(
                  controller: slideController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  autofocus: true,
                  style: AppTextThemes.bodyLarge(fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    hintText: 'Slide number',
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
                        final slideNumber = int.tryParse(slideController.text);
                        if (slideNumber != null && slideNumber > 0) {
                          _jumpToSlide(slideNumber - 1); // Convert to 0-indexed
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
