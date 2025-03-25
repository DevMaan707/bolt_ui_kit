import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../buttons/buttons.dart';

class AppForm extends StatefulWidget {
  final GlobalKey<FormState>? formKey;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final double? spacing;
  final ScrollPhysics? physics;
  final VoidCallback? onSubmit;
  final String? submitLabel;
  final bool showSubmitButton;
  final ButtonType submitButtonType;
  final bool autovalidateMode;

  const AppForm({
    Key? key,
    this.formKey,
    required this.children,
    this.padding,
    this.spacing,
    this.physics,
    this.onSubmit,
    this.submitLabel,
    this.showSubmitButton = true,
    this.submitButtonType = ButtonType.primary,
    this.autovalidateMode = false,
  }) : super(key: key);

  @override
  State<AppForm> createState() => _AppFormState();
}

class _AppFormState extends State<AppForm> {
  late GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = widget.formKey ?? GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPadding = widget.padding ?? EdgeInsets.all(16.w);
    final defaultSpacing = widget.spacing ?? 16.h;

    return Form(
      key: _formKey,
      autovalidateMode: widget.autovalidateMode
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      child: SingleChildScrollView(
        physics: widget.physics ?? BouncingScrollPhysics(),
        padding: defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...List.generate(
              widget.children.length,
              (index) => Padding(
                padding: EdgeInsets.only(
                  bottom:
                      index < widget.children.length - 1 ? defaultSpacing : 0,
                ),
                child: widget.children[index],
              ),
            ),
            if (widget.showSubmitButton && widget.onSubmit != null) ...[
              SizedBox(height: 24.h),
              Button(
                text: widget.submitLabel ?? 'Submit',
                type: widget.submitButtonType,
                onPressed: _validateAndSubmit,
                size: ButtonSize.large,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _validateAndSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      widget.onSubmit?.call();
    }
  }
}
