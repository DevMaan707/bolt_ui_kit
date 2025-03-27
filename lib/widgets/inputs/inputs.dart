import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
export 'pinput.dart';

enum InputType {
  text,
  password,
  email,
  number,
  phone,
  multiline,
  search,
  custom
}

class AppInput extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? initialValue;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final InputType type;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final bool readOnly;
  final bool enabled;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Color? textColor;
  final TextStyle? style;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final VoidCallback? suffixIconOnPressed;
  final Widget? suffix;
  final Widget? prefix;
  final String? errorText;
  final BorderRadius? borderRadius;
  final double borderWidth;
  final double focusedBorderWidth;
  final TextAlign textAlign;

  const AppInput({
    Key? key,
    this.label,
    this.hint,
    this.initialValue,
    this.prefixIcon,
    this.suffixIcon,
    this.type = InputType.text,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.controller,
    this.focusNode,
    this.validator,
    this.inputFormatters,
    this.textInputAction,
    this.autofocus = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.width,
    this.height,
    this.contentPadding,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.textColor,
    this.style,
    this.labelStyle,
    this.hintStyle,
    this.suffixIconOnPressed,
    this.suffix,
    this.prefix,
    this.errorText,
    this.borderRadius,
    this.borderWidth = 1.0,
    this.focusedBorderWidth = 2.0,
    this.textAlign = TextAlign.start,
  }) : super(key: key);

  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  late TextEditingController _controller;
  bool _obscureText = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _focusNode = widget.focusNode ?? FocusNode();
    _obscureText = widget.type == InputType.password;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: widget.width,
      height: widget.height,
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        obscureText: _obscureText,
        keyboardType: _getKeyboardType(),
        textInputAction: widget.textInputAction,
        textAlign: widget.textAlign,
        maxLength: widget.maxLength,
        maxLines: widget.type == InputType.multiline ? widget.maxLines ?? 5 : 1,
        minLines: widget.type == InputType.multiline ? widget.minLines ?? 3 : 1,
        autofocus: widget.autofocus,
        readOnly: widget.readOnly,
        enabled: widget.enabled,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onSubmitted,
        onTap: widget.onTap,
        validator: widget.validator,
        inputFormatters: widget.inputFormatters ?? _getInputFormatters(),
        style: widget.style ??
            TextStyle(
              fontSize: 16.sp,
              color:
                  widget.textColor ?? (isDark ? Colors.white : Colors.black87),
            ),
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          errorText: widget.errorText,
          filled: true,
          fillColor: widget.fillColor ??
              (isDark ? Colors.grey.shade800 : Colors.grey.shade50),
          contentPadding: widget.contentPadding ??
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          prefixIcon: _buildPrefixIcon(),
          suffixIcon: _buildSuffixIcon(),
          suffix: widget.suffix,
          prefix: widget.prefix,
          labelStyle: widget.labelStyle ??
              TextStyle(
                fontSize: 14.sp,
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
              ),
          hintStyle: widget.hintStyle ??
              TextStyle(
                fontSize: 14.sp,
                color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
              ),
          border: _buildBorder(),
          enabledBorder: _buildBorder(),
          focusedBorder: _buildFocusedBorder(),
          errorBorder: _buildErrorBorder(),
          focusedErrorBorder: _buildErrorBorder(),
          disabledBorder: _buildDisabledBorder(),
        ),
      ),
    );
  }

  Widget? _buildPrefixIcon() {
    if (widget.prefixIcon != null) {
      return Icon(
        widget.prefixIcon,
        size: 20.sp,
        color: AppColors.textLight,
      );
    }
    return null;
  }

  Widget? _buildSuffixIcon() {
    if (widget.type == InputType.password) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          size: 20.sp,
          color: AppColors.textLight,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    } else if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(
          widget.suffixIcon,
          size: 20.sp,
          color: AppColors.textLight,
        ),
        onPressed: widget.suffixIconOnPressed,
      );
    }
    return null;
  }

  InputBorder _buildBorder() {
    final borderColor = widget.borderColor ??
        (Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkBorder
            : AppColors.lightBorder);

    return OutlineInputBorder(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(8.r),
      borderSide: BorderSide(
        color: borderColor,
        width: widget.borderWidth,
      ),
    );
  }

  InputBorder _buildFocusedBorder() {
    final focusedBorderColor = widget.focusedBorderColor ?? AppColors.primary;

    return OutlineInputBorder(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(8.r),
      borderSide: BorderSide(
        color: focusedBorderColor,
        width: widget.focusedBorderWidth,
      ),
    );
  }

  InputBorder _buildErrorBorder() {
    return OutlineInputBorder(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(8.r),
      borderSide: BorderSide(
        color: AppColors.error,
        width: widget.borderWidth,
      ),
    );
  }

  InputBorder _buildDisabledBorder() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final disabledColor = isDark ? Colors.grey.shade700 : Colors.grey.shade300;

    return OutlineInputBorder(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(8.r),
      borderSide: BorderSide(
        color: disabledColor,
        width: widget.borderWidth,
      ),
    );
  }

  TextInputType _getKeyboardType() {
    switch (widget.type) {
      case InputType.text:
        return TextInputType.text;
      case InputType.password:
        return TextInputType.visiblePassword;
      case InputType.email:
        return TextInputType.emailAddress;
      case InputType.number:
        return TextInputType.number;
      case InputType.phone:
        return TextInputType.phone;
      case InputType.multiline:
        return TextInputType.multiline;
      case InputType.search:
        return TextInputType.text;
      case InputType.custom:
        return TextInputType.text;
    }
  }

  List<TextInputFormatter>? _getInputFormatters() {
    switch (widget.type) {
      case InputType.number:
        return [FilteringTextInputFormatter.digitsOnly];
      case InputType.phone:
        return [FilteringTextInputFormatter.digitsOnly];
      default:
        return null;
    }
  }
}
