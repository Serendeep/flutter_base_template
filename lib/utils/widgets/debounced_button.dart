import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_base_template/utils/theme/theme.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:flutter_base_template/core/error/app_error.dart';

class DebouncedButton extends StatefulWidget {
  final Widget textWidget;
  final AsyncCallback onPressed;
  final Duration duration;
  final double width;
  final double height;
  final bool isWhite;
  final bool isCircle;
  final Color? customColor;
  final Color? customTextColor;

  const DebouncedButton({
    super.key,
    required this.textWidget,
    required this.onPressed,
    this.duration = const Duration(milliseconds: 200),
    this.height = 50.0,
    this.width = 160.0,
    this.isWhite = false,
    this.isCircle = false,
    this.customColor,
    this.customTextColor,
  });

  @override
  State<DebouncedButton> createState() => _DebouncedButtonState();
}

class _DebouncedButtonState extends State<DebouncedButton> {
  bool _isEnabled = true;
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _handleButtonPress() async {
    if (!_isEnabled) return;

    setState(() => _isEnabled = false);

    try {
      await widget.onPressed();
    } catch (e, stackTrace) {
      AppError.create(
        message: 'DebouncedButton error',
        type: ErrorType.unknown,
        originalError: e,
        stackTrace: stackTrace,
      );
    } finally {
      _debounceTimer = Timer(widget.duration, () {
        if (mounted) {
          setState(() => _isEnabled = true);
        }
      });
    }
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    final themeData = ThemeProvider.themeOf(context).data;
    final themeColors = ThemeColor.get(context);

    if (widget.isWhite) {
      return ElevatedButton.styleFrom(
        backgroundColor: widget.customColor ?? Colors.white,
        foregroundColor: widget.customTextColor ?? themeColors.buttonBackground,
        textStyle: themeData.textTheme.labelLarge?.copyWith(
          color: widget.customTextColor ?? themeColors.buttonBackground,
          fontWeight: FontWeight.bold,
        ),
        shape: widget.isCircle
            ? CircleBorder(
                side: BorderSide(color: themeColors.textfieldBorderColor),
              )
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: themeColors.textfieldBorderColor),
              ),
      );
    }

    return ElevatedButton.styleFrom(
      backgroundColor: widget.customColor ?? themeData.colorScheme.primary,
      foregroundColor: widget.customTextColor ?? themeColors.background,
      textStyle: themeData.textTheme.labelLarge?.copyWith(
        color: widget.customTextColor ?? themeColors.background,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: ElevatedButton(
        style: _getButtonStyle(context),
        onPressed: _isEnabled ? _handleButtonPress : null,
        child: _isEnabled
            ? widget.textWidget
            : const CircularProgressIndicator.adaptive(),
      ),
    );
  }
}

typedef AsyncCallback = Future<void> Function();
