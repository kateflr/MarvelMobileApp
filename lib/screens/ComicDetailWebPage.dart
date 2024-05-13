import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ComicDetailWebPage extends StatefulWidget {
  final String comicUrl;

  ComicDetailWebPage({
    Key? key,
    required this.comicUrl,
  }) : super(key: key);

  @override
  State<ComicDetailWebPage> createState() => _ComicDetailWebPageState();
}

class _ComicDetailWebPageState extends State<ComicDetailWebPage> {
  late WebViewController controller;
  late String httpsUrl;

  @override
  void initState() {
    super.initState();
    httpsUrl = widget.comicUrl.replaceFirst('http://', 'https://');
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.disabled)
      ..loadRequest(Uri.parse(httpsUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
