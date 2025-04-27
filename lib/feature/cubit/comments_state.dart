part of 'comments_cubit.dart';

abstract class CommentsState extends Equatable {
  const CommentsState();

  @override
  List<Object> get props => [];
}

class CommentsStateInitial extends CommentsState {}

class CommentsStateLoading extends CommentsState {}

class CommentsStateLoaded extends CommentsState {
  final List<Comment> comments;
  const CommentsStateLoaded(this.comments);
  @override
  List<Object> get props => [comments];
}

class CommentsStateError extends CommentsState {
  final String message;
  const CommentsStateError(this.message);
  @override
  List<Object> get props => [message];
}

class CommentSendLoading extends CommentsState {}

class CommentSendSuccess extends CommentsState {}

class CommentDeleteSuccess extends CommentsState {}

class CommentDeleteError extends CommentsState {
  final String message;
  const CommentDeleteError(this.message);
  @override
  List<Object> get props => [message];
}

class CommentSendError extends CommentsState {
  final String message;
  const CommentSendError(this.message);
  @override
  List<Object> get props => [message];
}

//Reply
class ReplySendLoading extends CommentsState {}

class ReplySendSuccess extends CommentsState {}

class ReplySendError extends CommentsState {
  final String message;
  const ReplySendError(this.message);
  @override
  List<Object> get props => [message];
}

class ReplyDeleteSuccess extends CommentsState {}

class ReplyDeleteError extends CommentsState {
  final String message;
  const ReplyDeleteError(this.message);
  @override
  List<Object> get props => [message];
}
