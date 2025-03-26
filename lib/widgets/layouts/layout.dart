import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum AppLayoutType { standard, scroll, safeArea, constrained }

class AppLayout extends StatelessWidget {
  final AppLayoutType type;
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final bool extendBodyBehindAppBar;
  final bool resizeToAvoidBottomInset;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final ScrollPhysics? physics;
  final bool centerChild;
  final BoxConstraints? constraints;
  final bool safeTop;
  final bool safeBottom;
  final bool safeLeft;
  final bool safeRight;

  const AppLayout({
    super.key,
    this.type = AppLayoutType.standard,
    required this.child,
    this.backgroundColor,
    this.padding,
    this.extendBodyBehindAppBar = false,
    this.resizeToAvoidBottomInset = true,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.floatingActionButtonLocation,
    this.physics,
    this.centerChild = false,
    this.constraints,
    this.safeTop = true,
    this.safeBottom = true,
    this.safeLeft = true,
    this.safeRight = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      endDrawer: endDrawer,
      floatingActionButtonLocation: floatingActionButtonLocation,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    Widget content = child;
    if (padding != null) {
      content = Padding(
        padding: padding!,
        child: content,
      );
    }
    if (centerChild) {
      content = Center(child: content);
    }
    if (constraints != null || type == AppLayoutType.constrained) {
      content = ConstrainedBox(
        constraints: constraints ?? BoxConstraints(maxWidth: 600.w),
        child: content,
      );
    }
    if (type == AppLayoutType.safeArea) {
      content = SafeArea(
        top: safeTop,
        bottom: safeBottom,
        left: safeLeft,
        right: safeRight,
        child: content,
      );
    }
    if (type == AppLayoutType.scroll) {
      content = SingleChildScrollView(
        physics: physics ?? const BouncingScrollPhysics(),
        child: content,
      );
    }

    return content;
  }
}
