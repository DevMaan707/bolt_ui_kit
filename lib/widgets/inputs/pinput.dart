import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../theme/text_themes.dart';

enum PinInputTheme { outlined, filled, underlined, rounded, custom }

class BoltPinInput extends StatefulWidget {
  /// Number of PIN fields
  final int length;

  /// Function called when all fields are filled
  final Function(String) onCompleted;

  /// Function called on every input change
  final Function(String)? onChanged;

  /// Controls the obscuring of text (for passwords/PINs)
  final bool obscureText;

  /// Choose from predefined themes or create custom
  final PinInputTheme theme;

  /// Color of the active field
  final Color? activeColor;

  /// Color of the inactive field
  final Color? inactiveColor;

  /// Color of text
  final Color? textColor;

  /// Background color of the field (for filled theme)
  final Color? backgroundColor;

  /// Error text to display
  final String? errorText;

  /// Error text style
  final TextStyle? errorTextStyle;

  /// Focus node for the input
  final FocusNode? focusNode;

  /// Initial value for the PIN
  final String? initialValue;

  /// Input type to restrict characters
  final TextInputType keyboardType;

  /// Field width
  final double? width;

  /// Field height
  final double? height;

  /// Field margin
  final EdgeInsetsGeometry? margin;

  /// Field padding
  final EdgeInsetsGeometry? padding;

  /// Border radius for the fields
  final BorderRadius? borderRadius;

  /// Size of the text
  final double? fontSize;

  /// Decoration for the pin fields
  final Decoration? pinDecoration;

  /// Animation duration for selection changes
  final Duration animationDuration;

  /// Whether to auto-focus the field on load
  final bool autofocus;

  /// Whether to show cursor in text fields
  final bool showCursor;

  /// Input formatters to restrict input
  final List<TextInputFormatter>? inputFormatters;

  const BoltPinInput({
    super.key,
    required this.length,
    required this.onCompleted,
    this.onChanged,
    this.obscureText = false,
    this.theme = PinInputTheme.outlined,
    this.activeColor,
    this.inactiveColor,
    this.textColor,
    this.backgroundColor,
    this.errorText,
    this.errorTextStyle,
    this.focusNode,
    this.initialValue,
    this.keyboardType = TextInputType.number,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.borderRadius,
    this.fontSize,
    this.pinDecoration,
    this.animationDuration = const Duration(milliseconds: 300),
    this.autofocus = false,
    this.showCursor = true,
    this.inputFormatters,
  });

  @override
  State<BoltPinInput> createState() => _BoltPinInputState();
}

class _BoltPinInputState extends State<BoltPinInput> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late List<String> _pin;
  late FocusNode _rootFocusNode;

  @override
  void initState() {
    super.initState();
    _rootFocusNode = widget.focusNode ?? FocusNode();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
    _pin = List.filled(widget.length, '');
    if (widget.initialValue != null) {
      final initialPin = widget.initialValue!.split('');
      for (int i = 0; i < widget.length && i < initialPin.length; i++) {
        _controllers[i].text = initialPin[i];
        _pin[i] = initialPin[i];
      }
    }
    for (int i = 0; i < widget.length; i++) {
      _controllers[i].addListener(() {
        _fieldChanged(i);
      });
    }

    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(_focusNodes[0]);
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    if (widget.focusNode == null) {
      _rootFocusNode.dispose();
    }
    super.dispose();
  }

  void _fieldChanged(int index) {
    if (_controllers[index].text.isNotEmpty) {
      _pin[index] = _controllers[index].text;
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
      widget.onChanged?.call(_pin.join(''));
      if (!_pin.contains('')) {
        widget.onCompleted(_pin.join(''));
      }
    }
  }

  void _handleBackspace(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
      if (_pin[index - 1].isNotEmpty &&
          _controllers[index - 1].text.isNotEmpty) {
        _controllers[index - 1].clear();
        _pin[index - 1] = '';
        widget.onChanged?.call(_pin.join(''));
      }
    }
  }

  void clear() {
    for (int i = 0; i < widget.length; i++) {
      _controllers[i].clear();
      _pin[i] = '';
    }
    widget.onChanged?.call('');
    _focusNodes[0].requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = widget.activeColor ?? AppColors.primary;
    final inactiveColor = widget.inactiveColor ??
        (isDark ? Colors.grey.shade600 : Colors.grey.shade300);
    final textColor =
        widget.textColor ?? (isDark ? Colors.white : Colors.black87);
    const errorTextColor = Colors.redAccent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            int emptyIndex = _pin.indexOf('');
            if (emptyIndex == -1) {
              _focusNodes[widget.length - 1].requestFocus();
            } else {
              _focusNodes[emptyIndex].requestFocus();
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.length, (index) {
              return Padding(
                padding: widget.margin ?? EdgeInsets.symmetric(horizontal: 6.w),
                child: _buildPinField(context, index, activeColor,
                    inactiveColor, textColor, isDark),
              );
            }),
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: EdgeInsets.only(top: 8.h, left: 4.w),
            child: Text(
              widget.errorText!,
              style: widget.errorTextStyle ??
                  AppTextThemes.bodySmall(color: errorTextColor),
            ),
          ),
      ],
    );
  }

  Widget _buildPinField(BuildContext context, int index, Color activeColor,
      Color inactiveColor, Color textColor, bool isDark) {
    final fieldWidth = widget.width ?? 50.w;
    final fieldHeight = widget.height ?? 60.h;
    final fontSize = widget.fontSize ?? 22.sp;
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(12.r);
    final isFocused = _focusNodes[index].hasFocus;
    final hasValue = _controllers[index].text.isNotEmpty;

    BoxDecoration getDefaultDecoration() {
      switch (widget.theme) {
        case PinInputTheme.filled:
          return BoxDecoration(
            color: hasValue
                ? activeColor.withOpacity(0.12)
                : (widget.backgroundColor ??
                    (isDark
                        ? Colors.grey.shade800.withOpacity(0.5)
                        : Colors.grey.shade100.withOpacity(0.7))),
            borderRadius: borderRadius,
            border: Border.all(
                color: isFocused ? activeColor : Colors.transparent,
                width: 1.5.w),
          );
        case PinInputTheme.underlined:
          return BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isFocused ? activeColor : inactiveColor,
                width: isFocused ? 2.w : 1.w,
              ),
            ),
          );
        case PinInputTheme.rounded:
          return BoxDecoration(
            color:
                hasValue ? activeColor.withOpacity(0.08) : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: isFocused ? activeColor : inactiveColor,
              width: isFocused ? 2.w : 1.w,
            ),
          );
        case PinInputTheme.custom:
          return const BoxDecoration();
        case PinInputTheme.outlined:
          return BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(
              color: isFocused ? activeColor : inactiveColor,
              width: isFocused ? 2.w : 1.w,
            ),
          );
      }
    }

    final decoration = widget.pinDecoration ?? getDefaultDecoration();

    return Container(
      width: fieldWidth,
      height: fieldHeight,
      decoration: widget.theme != PinInputTheme.custom ? decoration : null,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        obscureText: widget.obscureText,
        textAlign: TextAlign.center,
        keyboardType: widget.keyboardType,
        maxLength: 1,
        showCursor: widget.showCursor,
        cursorColor: activeColor,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        decoration: InputDecoration(
          counter: const SizedBox.shrink(),
          contentPadding: widget.padding ?? EdgeInsets.symmetric(vertical: 8.h),
          border: widget.theme == PinInputTheme.custom
              ? OutlineInputBorder(borderRadius: borderRadius)
              : InputBorder.none,
          enabledBorder: widget.theme == PinInputTheme.custom
              ? OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: BorderSide(color: inactiveColor),
                )
              : InputBorder.none,
          focusedBorder: widget.theme == PinInputTheme.custom
              ? OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: BorderSide(color: activeColor, width: 2.w),
                )
              : InputBorder.none,
          fillColor: Colors.transparent,
          filled: false,
        ),
        inputFormatters: widget.inputFormatters ??
            [
              FilteringTextInputFormatter.digitsOnly,
            ],
        onChanged: (value) {
          if (value.isEmpty) {
            _handleBackspace(index);
          }
        },
      ),
    );
  }
}
