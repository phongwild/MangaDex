import 'package:app/core_ui/widget/loading/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core_ui/app_theme.dart/app_color/app_colors.dart';
import '../../../../core_ui/app_theme.dart/app_text_style.dart';
import '../../../utils/is_login.dart';

class WriteCommentWidget extends StatefulWidget {
  final Function(String) onSend;
  final String hintText;
  final Color? colorBg;
  final Color? colorTextField;
  const WriteCommentWidget({
    super.key,
    required this.onSend,
    this.colorBg,
    this.colorTextField,
    this.hintText = 'Viết bình luận...',
  });

  @override
  State<WriteCommentWidget> createState() => _WriteCommentWidgetState();
}

class _WriteCommentWidgetState extends State<WriteCommentWidget> {
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<bool> _isWriting = ValueNotifier(false);
  final IsLogin _isLogin = IsLogin.getInstance();
  @override
  void dispose() {
    _controller.dispose();
    _isWriting.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      _controller.clear();
      _isWriting.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLogin.isLoggedIn) return const SizedBox.shrink();
    String? avatarUrl;
    if (_isLogin.isLoggedIn) {
      avatarUrl = _isLogin.avatar;
    }
    return Container(
      // padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: widget.colorBg ?? AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _UserAvatar(avatarUrl),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: widget.colorTextField ?? AppColors.buttonDisablePopup,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _controller,
                onChanged: (value) {
                  _isWriting.value = value.trim().isNotEmpty;
                },
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: AppsTextStyle.text14Weight400.copyWith(
                    color: AppColors.gray700,
                  ),
                  border: InputBorder.none,
                  isCollapsed: true,
                ),
                style: AppsTextStyle.text14Weight400.copyWith(
                  color: AppColors.black,
                ),
                minLines: 1,
                maxLines: 5,
              ),
            ),
          ),
          const SizedBox(width: 5),
          ValueListenableBuilder<bool>(
            valueListenable: _isWriting,
            builder: (context, isWriting, child) {
              if (!isWriting) return const SizedBox.shrink();
              return IconButton(
                icon: Icon(Icons.send, color: AppColors.blue, size: 20),
                onPressed: _handleSend,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar(this.imageUrl);
  final String? imageUrl;
  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: (imageUrl != null && imageUrl!.isNotEmpty) // Kiểm tra null trước
          ? CachedNetworkImage(
              imageUrl: imageUrl!,
              width: 36,
              height: 36,
              fit: BoxFit.cover,
              placeholder: (context, url) => LoadingShimmer().loadingAvatar(),
              errorWidget: (context, url, error) =>
                  LoadingShimmer().loadingAvatar(),
            )
          : LoadingShimmer()
              .loadingAvatar(), // Nếu không có ảnh, hiển thị shimmer
    );
  }
}
