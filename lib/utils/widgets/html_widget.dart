import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HtmlViewer extends StatefulWidget {
  final String htmlContent;

  const HtmlViewer({super.key, required this.htmlContent});

  @override
  State<HtmlViewer> createState() => _HtmlViewerState();
}

class _HtmlViewerState extends State<HtmlViewer> {
  late WebViewController controller;
  bool isLoading = true;
  double contentHeight = 1.0;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..enableZoom(false)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) async {
            await _setWebViewSettings();
            await _getContentHeight();
            setState(() {
              isLoading = false;
            });
          },
        ),
      );

    controller.loadRequest(
      Uri.dataFromString(
        widget.htmlContent,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ),
    );
  }

  Future<void> _setWebViewSettings() async {
    await controller.runJavaScript('''
      if (document.getElementsByTagName('head').length > 0) {
        var meta = document.createElement('meta');
        meta.name = 'viewport';
        meta.content = 'width=device-width, maximum-scale=1.0, user-scalable=no, shrink-to-fit=no';
        document.getElementsByTagName('head')[0].appendChild(meta);

        var style = document.createElement('style');
        style.type = 'text/css';
        style.innerHTML = 'body { -webkit-user-select: none; -webkit-user-drag: none; overflow: hidden; height: fit-content; } ';
        document.getElementsByTagName('head')[0].appendChild(style);

        // Hide the scroll bars
        var hideScrollBarStyle = document.createElement('style');
        hideScrollBarStyle.type = 'text/css';
        hideScrollBarStyle.innerHTML = 'body { overflow: hidden; }';
        document.getElementsByTagName('head')[0].appendChild(hideScrollBarStyle);
      }
    ''');

    // Additional WebView settings to disable zoom controls
    await controller.runJavaScript('''
      document.addEventListener('gesturestart', function (e) {
        e.preventDefault();
      });
    ''');
  }

  Future<void> _getContentHeight() async {
    // Get the content height from the webview
    final height = await controller.runJavaScriptReturningResult('''
      (function() {
        var body = document.body;
        var html = document.documentElement;
        if (body && html) {
          return Math.max(
            body.scrollHeight, body.offsetHeight, body.clientHeight,
            html.scrollHeight, html.offsetHeight, html.clientHeight
          );
        }
        return 1;
      })();
    ''');

    // Convert the result to double
    double newHeight = double.tryParse(height.toString()) ?? 1;

    setState(() {
      contentHeight = newHeight;
    });

    Logger().e('Content height: $contentHeight');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: contentHeight,
      child: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
