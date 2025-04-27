import 'package:app/feature/models/comment_model.dart';
import 'package:app/feature/screens/detail/widget/write_comment_widget.dart';
import 'package:app/feature/utils/time_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core_ui/app_theme.dart/app_color/app_colors.dart';
import '../../../../core_ui/app_theme.dart/app_text_style.dart';
import '../../../cubit/comments_cubit.dart';
import 'avatar_comment_widget.dart';

class CommentItem extends StatelessWidget {
  final String avatarUrl;
  final String username;
  final String content;
  final String timeAgo;
  final String mangaID;
  final String commentID;
  final bool isUser;
  final List<Reply> replies;
  final String idUser;
  const CommentItem({
    super.key,
    required this.avatarUrl,
    required this.username,
    required this.content,
    required this.timeAgo,
    required this.isUser,
    required this.mangaID,
    required this.commentID,
    required this.replies,
    required this.idUser,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final ValueNotifier<bool> isShowReply = ValueNotifier(false);
    final ValueNotifier<bool> isShowReplyField = ValueNotifier(false);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.buttonDisablePopup,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Avatar(avatarUrl: avatarUrl),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: AppsTextStyle.text14Weight600.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      content,
                      style: AppsTextStyle.text14Weight400.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          timeAgo,
                          style: AppsTextStyle.text10Weight400.copyWith(
                            color: AppColors.gray700,
                          ),
                        ),
                        // const Spacer(),
                        GestureDetector(
                          onTap: () {
                            isShowReplyField.value = !isShowReplyField.value;
                          },
                          child: Text(
                            'Phản hồi',
                            style: AppsTextStyle.text10Weight500.copyWith(
                              color: AppColors.gray700,
                            ),
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              isUser
                  ? GestureDetector(
                      onTapDown: (details) async {
                        final position = details.globalPosition;
                        final selected = await showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(
                            position.dx,
                            position.dy,
                            screenSize.width - position.dx - 12,
                            0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: AppColors.buttonDisablePopup,
                          items: [
                            // PopupMenuItem(
                            //   value: 'edit',
                            //   child: Text(
                            //     'Sửa',
                            //     style: AppsTextStyle.text14Weight500.copyWith(
                            //       color: AppColors.black,
                            //     ),
                            //   ),
                            // ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text(
                                'Xoá',
                                style: AppsTextStyle.text14Weight500.copyWith(
                                  color: AppColors.red,
                                ),
                              ),
                            ),
                          ],
                        );

                        if (selected == 'edit') {
                          //
                        } else if (selected == 'delete') {
                          if (!context.mounted) return;
                          context
                              .read<CommentsCubit>()
                              .deleteComment(mangaID, commentID);
                        }
                      },
                      child: Icon(Icons.more_horiz, color: AppColors.gray700),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          ValueListenableBuilder<bool>(
            valueListenable: isShowReply,
            builder: (context, value, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hiển thị danh sách replies nếu isShowReply == true
                  if (value)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        children: replies.map((reply) {
                          return _ReplyItem(
                            reply.userId.avatar,
                            reply.userId.username,
                            reply.content,
                            reply.createdAt.toString(),
                            mangaID,
                            commentID,
                            idUser == reply.userId.id,
                            reply.sId,
                          );
                        }).toList(),
                      ),
                    ),
                  // Nếu có reply thì hiển thị nút "Xem phản hồi"
                  if (replies.isNotEmpty)
                    GestureDetector(
                      onTap: () => isShowReply.value = !value,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          value
                              ? 'Thu gọn'
                              : 'Xem tất cả ${replies.length} phản hồi',
                          style: AppsTextStyle.text10Weight500.copyWith(
                            color: AppColors.gray700,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          ValueListenableBuilder<bool>(
            valueListenable: isShowReplyField,
            builder: (context, value, child) {
              if (!value) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 8, left: 20),
                child: WriteCommentWidget(
                  hintText: 'Trả lời $username',
                  colorBg: AppColors.buttonDisablePopup,
                  colorTextField: AppColors.white,
                  onSend: (text) {
                    if (!context.mounted) return;
                    context.read<CommentsCubit>().sendReply(
                          mangaID,
                          commentID,
                          '@$username: $text',
                        );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class _ReplyItem extends StatelessWidget {
  final String avatarUrl;
  final String username;
  final String content;
  final String timeStamp;
  final String mangaID;
  final String commentID;
  final String replyID;
  final bool isUser;
  const _ReplyItem(
    this.avatarUrl,
    this.username,
    this.content,
    this.timeStamp,
    this.mangaID,
    this.commentID,
    this.isUser,
    this.replyID,
  );

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Avatar(avatarUrl: avatarUrl, width: 30, height: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: AppsTextStyle.text14Weight600.copyWith(
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: AppsTextStyle.text14Weight400.copyWith(
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      timeAgoComment(timeStamp),
                      style: AppsTextStyle.text10Weight400.copyWith(
                        color: AppColors.gray700,
                      ),
                    ),
                    // const Spacer(),
                    GestureDetector(
                      child: Text(
                        'Phản hồi',
                        style: AppsTextStyle.text10Weight500.copyWith(
                          color: AppColors.gray700,
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.3),
                  ],
                ),
              ],
            ),
          ),
          isUser
              ? GestureDetector(
                  onTapDown: (details) async {
                    final position = details.globalPosition;
                    final selected = await showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(
                        position.dx,
                        position.dy,
                        screenSize.width - position.dx - 12,
                        0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: AppColors.buttonDisablePopup,
                      items: [
                        // PopupMenuItem(
                        //   value: 'edit',
                        //   child: Text(
                        //     'Sửa',
                        //     style: AppsTextStyle.text14Weight500.copyWith(
                        //       color: AppColors.black,
                        //     ),
                        //   ),
                        // ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(
                            'Xoá',
                            style: AppsTextStyle.text14Weight500.copyWith(
                              color: AppColors.red,
                            ),
                          ),
                        ),
                      ],
                    );

                    // if (selected == 'edit') {
                    //   //
                    // } else
                    if (selected == 'delete') {
                      if (!context.mounted) return;
                      context
                          .read<CommentsCubit>()
                          .deleteReply(mangaID, commentID, replyID);
                    }
                  },
                  child: Icon(Icons.more_horiz, color: AppColors.gray700),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
