import 'package:app/core/app_log.dart';
import 'package:app/feature/dio/dio_client.dart';
import 'package:app/feature/models/comment_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/cache/shared_prefs.dart';

part 'comments_state.dart';

const String baseUrl = 'https://api-manga-user.vercel.app';

class CommentsCubit extends Cubit<CommentsState> with NetWorkMixin {
  CommentsCubit() : super(CommentsStateInitial());

  Future<void> getComments(String mangaID) async {
    if (state is CommentsStateLoading) return;
    try {
      emit(CommentsStateLoading());
      final response = await callApiGet(endPoint: '$baseUrl/comments/$mangaID');
      if (response.statusCode == 200) {
        final List<Comment> data = (response.data['data'] as List)
            .map((e) => Comment.fromJson(e as Map<String, dynamic>))
            .toList();
        emit(CommentsStateLoaded(data));
      } else {
        emit(CommentsStateError(response.data['message']));
      }
    } catch (e) {
      dlog('Error: $e');
      emit(CommentsStateError(e.toString()));
    }
  }

  Future<void> sendComment(String mangaID, String content) async {
    try {
      emit(CommentSendLoading());
      final uid = await SharedPref.getString('uid');
      final response = await callApiPost('$baseUrl/comments/post/$mangaID', {
        'userId': uid,
        'content': content,
      });
      if (response.statusCode == 201) {
        emit(CommentSendSuccess());
      } else {
        emit(CommentSendError('${response.data['message']}'));
      }
    } catch (e) {
      dlog('Error: $e');
      emit(CommentSendError(e.toString()));
    }
  }

  Future<void> deleteComment(String mangaID, String commentID) async {
    try {
      final response =
          await callApiDelete('$baseUrl/comments/delete/$mangaID/$commentID');
      if (response.statusCode == 200) {
        emit(CommentDeleteSuccess());
      } else {
        emit(CommentDeleteError('${response.data['message']}'));
      }
    } catch (e) {
      dlog('Error: $e');
      emit(CommentDeleteError(e.toString()));
    }
  }

  //Reply
  Future<void> sendReply(
    String mangaID,
    String commentID,
    String content,
  ) async {
    try {
      emit(ReplySendLoading());
      final uid = await SharedPref.getString('uid');
      final response = await callApiPost(
        '$baseUrl/comments/reply/$mangaID/$commentID',
        {
          'userId': uid,
          'content': content,
        },
      );
      if (response.statusCode == 201) {
        emit(ReplySendSuccess());
      } else {
        emit(ReplySendError('${response.data['message']}'));
      }
    } catch (e) {
      dlog('Error: $e');
      emit(ReplySendError(e.toString()));
    }
  }

  Future<void> deleteReply(
      String mangaID, String commentID, String replyID) async {
    try {
      final response = await callApiDelete(
        '$baseUrl/comments/reply/$mangaID/$commentID/$replyID',
      );
      if (response.statusCode == 200) {
        emit(ReplyDeleteSuccess());
      } else {
        emit(ReplyDeleteError('${response.data['message']}'));
      }
    } catch (e) {
      dlog('Error: $e');
      emit(ReplyDeleteError(e.toString()));
    }
  }
}
