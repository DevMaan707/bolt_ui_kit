import 'package:flutter_pdfview/flutter_pdfview.dart';

/// Controller for the PDFViewer
class PDFViewerController {
  PDFViewController? _controller;

  /// Sets the PDFViewController instance
  void setController(PDFViewController controller) {
    _controller = controller;
  }

  /// Gets the current page number
  Future<int?> getCurrentPage() async {
    return await _controller?.getCurrentPage();
  }

  /// Gets the total number of pages
  Future<int?> getPageCount() async {
    return await _controller?.getPageCount();
  }

  /// Jumps to the specified page
  Future<bool?> setPage(int page) async {
    return await _controller?.setPage(page);
  }

  /// Navigate to the next page
  Future<bool?> nextPage() async {
    final currentPage = await getCurrentPage();
    final pageCount = await getPageCount();

    if (currentPage != null &&
        pageCount != null &&
        currentPage < pageCount - 1) {
      return setPage(currentPage + 1);
    }
    return false;
  }

  /// Navigate to the previous page
  Future<bool?> previousPage() async {
    final currentPage = await getCurrentPage();

    if (currentPage != null && currentPage > 0) {
      return setPage(currentPage - 1);
    }
    return false;
  }

  /// Jump to the first page
  Future<bool?> jumpToFirst() async {
    return setPage(0);
  }

  /// Jump to the last page
  Future<bool?> jumpToLast() async {
    final pageCount = await getPageCount();
    if (pageCount != null) {
      return setPage(pageCount - 1);
    }
    return false;
  }
}
