import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class LunarWebViewScreen extends StatefulWidget {
  const LunarWebViewScreen({super.key});

  @override
  State<LunarWebViewScreen> createState() => _LunarWebViewScreenState();
}

class _LunarWebViewScreenState extends State<LunarWebViewScreen> {
  final ValueNotifier<double> progressBar = ValueNotifier<double>(0.0);
  InAppWebViewController? webViewController;
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lunar Webview'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: ValueListenableBuilder(
            valueListenable: progressBar,
            builder: (BuildContext context, double progress, Widget? child) {
              return Visibility(
                visible: progressBar.value < 1.0,
                child: LinearProgressIndicator(
                  value: progress,
                  color: Colors.purple,
                  backgroundColor: Colors.transparent,
                ),
              );
            },
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: InAppWebView(
              initialFile: "assets/webview/index.html",
              onWebViewCreated: (InAppWebViewController controller) {
                webViewController = controller;
                controller.addJavaScriptHandler(
                  handlerName: 'showMessageInNative',
                  callback: (args) {
                    _showMyDialog(context, args[0]);
                  },
                );
              },
              onProgressChanged: (InAppWebViewController controller, int progress) {
                progressBar.value = progress / 100;
              },
              onLoadStop: (InAppWebViewController controller, WebUri? url) async {},
              initialSettings: InAppWebViewSettings(
                supportZoom: false,
                builtInZoomControls: false,
                displayZoomControls: false,
                disableContextMenu: true,
                useWideViewPort: true,
                loadWithOverviewMode: true,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      labelText: "Enter text to send",
                      labelStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          color: Colors.indigo,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                    onPressed: () {
                      String text = textController.text;
                      if (webViewController != null && text.isNotEmpty) {
                        webViewController!.evaluateJavascript(
                            source: "window.updateFromNative('$text');");
                      }
                    },
                    child: const Text('Send data to Web', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMyDialog(BuildContext context, String text) {
    String message = text.isEmpty ? "Please input message" : text;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: Text(message),
            actions: [
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Dismiss', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
    );
  }
}
