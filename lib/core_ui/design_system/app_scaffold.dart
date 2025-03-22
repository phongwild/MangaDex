import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold(
      {super.key,
      this.resizeToAvoidBottomInset,
      this.header,
      this.child,
      this.bottomBar,
      this.floatingButton,
      this.floatingActionButtonLocation});

  final Widget? header;
  final Widget? child;
  final Widget? bottomBar;
  final bool? resizeToAvoidBottomInset;
  final Widget? floatingButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: floatingActionButtonLocation,
        floatingActionButton: floatingButton,
        bottomNavigationBar: bottomBar,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        body: SafeArea(
            child: Column(
          children: [
            header ?? _defaultHeader(context),
            Expanded(
                child: SizedBox(
                    width: double.infinity,
                    child: child ?? const SizedBox.shrink()))
          ],
        )));
  }

  Widget _defaultHeader(BuildContext context) {
    return SizedBox(
        height: 55,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(children: [
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.transparent,
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ))),
            const Expanded(child: SizedBox.shrink())
          ]),
        ));
  }
}
