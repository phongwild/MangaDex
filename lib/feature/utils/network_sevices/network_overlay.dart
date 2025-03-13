import 'package:app/core/app_log.dart';
import 'package:flutter/cupertino.dart';

class NetworkOverlay {
  static OverlayEntry? _overlayEntry;

  static void show(BuildContext context) {
    dlog("📢 show() được gọi!");
    if (_overlayEntry != null) {
      dlog("⚠️ Overlay đã tồn tại, không tạo mới!");
      return;
    }

    final overlay = Overlay.of(context, rootOverlay: true);
    if (overlay == null) {
      dlog("❌ Không tìm thấy Overlay! Context có thể chưa sẵn sàng.");
      return;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) {
        dlog("📌 OverlayEntry đang được build");
        return Positioned(
          top: 50,
          left: 20,
          right: 20,
          child: CupertinoPopupSurface(
            child: Container(
              padding: const EdgeInsets.all(10),
              color: CupertinoColors.systemRed,
              child: const Center(
                child: Text(
                  "Không có kết nối mạng!",
                  style: TextStyle(color: CupertinoColors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        );
      },
    );

    dlog("📢 Chèn overlay vào màn hình");
    overlay.insert(_overlayEntry!);
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
