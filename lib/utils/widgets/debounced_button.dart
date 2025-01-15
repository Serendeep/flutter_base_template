import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_base_template/utils/theme/theme.dart';
import 'package:theme_provider/theme_provider.dart';

class DebouncedButton extends StatefulWidget {
  final Widget textWidget;
  final VoidCallback onPressed;
  final Duration duration;
  final double width, height;
  final bool isWhite;
  final bool isCircle;

  const DebouncedButton(
      {super.key,
      required this.textWidget,
      required this.onPressed,
      this.height = 50.0,
      this.width = 160.0,
      this.isWhite = false,
      this.isCircle = false})
      : duration = const Duration(milliseconds: 200);

  @override
  State<DebouncedButton> createState() => _DebouncedButtonState();
}

class _DebouncedButtonState extends State<DebouncedButton> {
  late ValueNotifier<bool> _isEnabled;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _isEnabled = ValueNotifier<bool>(true);
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isEnabled,
      builder: (context, isEnabled, child) => SizedBox(
        height: widget.height, //MediaQuery.sizeOf(context).height * 0.056,
        width: widget.width,
        child: ElevatedButton(
          style: _buttonStyle,
          onPressed: isEnabled ? _onButtonPressed : null,
          child: isEnabled
              ? widget.textWidget
              : const CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }

  ButtonStyle get _buttonStyle => widget.isWhite
      ? ButtonStyle(
          textStyle: WidgetStateProperty.all<TextStyle>(
              ThemeProvider.themeOf(context)
                  .data
                  .textTheme
                  .labelLarge!
                  .copyWith(
                      color: ThemeColor.get(context).buttonBackground,
                      fontWeight: FontWeight.bold)),
          surfaceTintColor: WidgetStateProperty.all<Color>(Colors.white),
          shape: widget.isCircle
              ? WidgetStateProperty.all<CircleBorder>(CircleBorder(
                  side: BorderSide(
                      color: ThemeColor.get(context).textfieldBorderColor)))
              : WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: ThemeColor.get(context).textfieldBorderColor))),
          backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
          foregroundColor: WidgetStateProperty.all<Color>(Colors.white))
      : ButtonStyle(textStyle: WidgetStateProperty.all<TextStyle>(ThemeProvider.themeOf(context).data.textTheme.labelLarge!.copyWith(color: ThemeColor.get(context).background, fontWeight: FontWeight.bold)), shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))), backgroundColor: MaterialStateProperty.all<Color>(ThemeProvider.themeOf(context).data.colorScheme.primary));

  void _onButtonPressed() {
    _isEnabled.value = false;
    widget.onPressed();
    _timer = Timer(widget.duration, () => _isEnabled.value = true);
  }
}
