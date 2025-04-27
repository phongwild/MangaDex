import 'package:app/core/app_log.dart';
import 'package:app/core_ui/widget/loading/shimmer.dart';
import 'package:app/feature/screens/detail/widget/comment_item_widget.dart';
import 'package:app/feature/screens/detail/widget/empty_comment_widget.dart';
import 'package:app/feature/screens/detail/widget/write_comment_widget.dart';
import 'package:app/feature/utils/time_utils.dart';
import 'package:app/feature/utils/toast_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core_ui/app_theme.dart/app_color/app_colors.dart';
import '../../../../core_ui/app_theme.dart/app_text_style.dart';
import '../../../cubit/comments_cubit.dart';

class CommentWidget extends StatefulWidget {
  const CommentWidget({super.key, required this.mangaID, required this.uid});
  final String mangaID;
  final String uid;
  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bình luận:',
            style: AppsTextStyle.text14Weight600,
          ),
          const SizedBox(height: 8),
          BlocConsumer<CommentsCubit, CommentsState>(
            buildWhen: (previous, current) => current is CommentsStateLoaded,
            listener: (context, state) {
              if (state is CommentsStateError) {
                showToast('Có lỗi xảy ra :<');
                return;
              }
              if (state is CommentDeleteSuccess) {
                showToast('Xoá thành công !');
                context.read<CommentsCubit>().getComments(widget.mangaID);
                return;
              }
              if (state is CommentDeleteError) {
                showToast('Có lỗi xảy ra: ${state.message}');
                return;
              }
              if (state is CommentSendSuccess) {
                showToast('Bình luận thành công !');
                context.read<CommentsCubit>().getComments(widget.mangaID);
                return;
              }
              if (state is CommentSendError) {
                showToast('Có lỗi xảy ra: ${state.message}', isError: true);
                return;
              }
              if (state is ReplySendSuccess) {
                showToast('Trả lời thành công !');
                context.read<CommentsCubit>().getComments(widget.mangaID);
                return;
              }
              if (state is ReplySendError) {
                showToast('Có lỗi xảy ra: ${state.message}', isError: true);
                return;
              }
              if (state is ReplyDeleteSuccess) {
                showToast('Xoá thành công !');
                context.read<CommentsCubit>().getComments(widget.mangaID);
                return;
              }
              if (state is ReplyDeleteError) {
                showToast('Có lỗi xảy ra ${state.message}', isError: true);
                return;
              }
            },
            builder: (context, state) {
              if (state is CommentsStateLoading) {
                return Center(child: LoadingShimmer().loadingCircle());
              }

              if (state is CommentsStateLoaded) {
                final comments = state.comments;
                if (comments.isEmpty) {
                  return const EmptyComment();
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: comments.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = comments[index];
                    dlog(widget.uid);
                    return CommentItem(
                      avatarUrl: item.userId.avatar,
                      username: item.userId.username,
                      content: item.content,
                      timeAgo: timeAgoComment(item.createdAt.toString()),
                      isUser: widget.uid == item.userId.id,
                      mangaID: widget.mangaID,
                      commentID: item.sId,
                      replies: item.replies,
                      idUser: widget.uid,
                    );
                  },
                );
              }
              return const EmptyComment();
            },
          ),
          const SizedBox(height: 12),
          BlocListener<CommentsCubit, CommentsState>(
            listener: (context, state) {
              if (state is CommentSendSuccess) {
                showToast('Bình luận thành công !');
                context.read<CommentsCubit>().getComments(widget.mangaID);
              } else if (state is CommentSendError) {
                showToast(state.message, isError: true);
              }
            },
            child: WriteCommentWidget(
              onSend: (text) async {
                await context
                    .read<CommentsCubit>()
                    .sendComment(widget.mangaID, text);
              },
            ),
          )
        ],
      ),
    );
  }
}
