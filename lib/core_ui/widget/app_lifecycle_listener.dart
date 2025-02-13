import 'package:flutter/cupertino.dart';

abstract class AppLifeCycleListener<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  bool isAppInBackground = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      onPauseApp();

      isAppInBackground = true;
    }

    if (state == AppLifecycleState.inactive) {
      onInactiveApp();
    }

    if (state == AppLifecycleState.resumed) {
      if (isAppInBackground) {
        onResumeApp();
      }

      isAppInBackground = false;
    }
  }

  void onResumeApp() {}

  void onPauseApp() {}

  void onInactiveApp() {}

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
