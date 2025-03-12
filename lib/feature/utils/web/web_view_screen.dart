import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key, required this.initialUrl});

  final String initialUrl;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController controller;
  ValueNotifier<bool> isLoading = ValueNotifier(true);
  ValueNotifier<bool> canGoBack = ValueNotifier(false);
  ValueNotifier<bool> canGoForward = ValueNotifier(false);
  ValueNotifier<String> pageTitle = ValueNotifier("Trình duyệt");

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => isLoading.value = true,
          onPageFinished: (url) async {
            isLoading.value = false;
            canGoBack.value = await controller.canGoBack();
            canGoForward.value = await controller.canGoForward();
            String? title = await controller.getTitle();
            if (title != null) {
              pageTitle.value = title;
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.initialUrl));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      navigationBar: CupertinoNavigationBar(
        middle: ValueListenableBuilder<String>(
          valueListenable: pageTitle,
          builder: (context, title, _) {
            return Text(
              title,
              overflow: TextOverflow.ellipsis,
            );
          },
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  WebViewWidget(controller: controller),
                  ValueListenableBuilder<bool>(
                    valueListenable: isLoading,
                    builder: (context, loading, _) {
                      return loading
                          ? const Center(
                              child: CupertinoActivityIndicator(radius: 15))
                          : const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
            _buildBottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGroupedBackground.resolveFrom(context),
        border:
            Border(top: BorderSide(color: Colors.grey.shade300, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: canGoBack,
            builder: (context, canGoBack, _) {
              return CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: canGoBack ? () => controller.goBack() : null,
                child: Icon(
                  CupertinoIcons.back,
                  size: 24,
                  color: canGoBack ? Colors.black : Colors.grey,
                ),
              );
            },
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => controller.reload(),
            child: const Icon(CupertinoIcons.refresh, size: 24),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: canGoForward,
            builder: (context, canGoForward, _) {
              return CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: canGoForward ? () => controller.goForward() : null,
                child: Icon(
                  CupertinoIcons.forward,
                  size: 24,
                  color: canGoForward ? Colors.black : Colors.grey,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
