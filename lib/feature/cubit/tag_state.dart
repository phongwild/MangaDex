part of 'tag_cubit.dart';

abstract class TagState extends Equatable {
  const TagState();

  @override
  List<Object> get props => [];
}

class TagStateInitial extends TagState {}

class TagLoading extends TagState {}

class TagError extends TagState {
  final String message;

  const TagError(this.message);

  @override
  List<Object> get props => [message];
}

class TagLoaded extends TagState {
  final List<Tag> tags;

  const TagLoaded(this.tags);

  @override
  List<Object> get props => [tags];
}
