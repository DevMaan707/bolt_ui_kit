import 'dart:convert';
import 'dart:developer' as developer;

enum LogLevel { debug, info, warning, error }

class Logger {
  static bool _enableLogging = true;
  static LogLevel _minLevel = LogLevel.debug;

  static void configure(
      {bool enableLogging = true, LogLevel minLevel = LogLevel.debug}) {
    _enableLogging = enableLogging;
    _minLevel = minLevel;
  }

  static void debug(String message, {String? tag, Object? data}) {
    _log(LogLevel.debug, message, tag: tag, data: data);
  }

  static void info(String message, {String? tag, Object? data}) {
    _log(LogLevel.info, message, tag: tag, data: data);
  }

  static void warning(String message, {String? tag, Object? data}) {
    _log(LogLevel.warning, message, tag: tag, data: data);
  }

  static void error(String message,
      {String? tag, Object? data, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, tag: tag, data: data, stackTrace: stackTrace);
  }

  static void _log(
    LogLevel level,
    String message, {
    String? tag,
    Object? data,
    StackTrace? stackTrace,
  }) {
    if (!_enableLogging || level.index < _minLevel.index) return;

    final String logTag = tag ?? 'FlutterKit';
    final String levelStr = _getLevelString(level);
    final String timeStr = DateTime.now().toString().split('.').first;
    final StringBuffer logMessage = StringBuffer();

    logMessage.write('[$timeStr] $levelStr [$logTag] $message');

    if (data != null) {
      logMessage.write('\nData: ${_formatData(data)}');
    }

    if (stackTrace != null) {
      logMessage.write('\nStackTrace: $stackTrace');
    }

    print(logMessage.toString());
    developer.log(
      message,
      name: logTag,
      error: level == LogLevel.error ? data ?? message : null,
      stackTrace: stackTrace,
    );
  }

  static String _getLevelString(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '💙 DEBUG';
      case LogLevel.info:
        return '💚 INFO';
      case LogLevel.warning:
        return '💛 WARNING';
      case LogLevel.error:
        return '❤️ ERROR';
    }
  }

  static String _formatData(Object data) {
    if (data is Map || data is List) {
      try {
        const JsonEncoder encoder = JsonEncoder.withIndent('  ');
        return encoder.convert(data);
      } catch (e) {
        return data.toString();
      }
    }
    return data.toString();
  }
}
