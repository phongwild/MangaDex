part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserError extends UserState {
  final String message;
  const UserError(this.message);

  @override
  List<Object> get props => [message];
}

//Follow
class FollowMangaSuccess extends UserState {}

class AlreadyFollowedManga extends UserState {}

class UnFollowMangaSuccess extends UserState {}

class AlreadyRemovedManga extends UserState {}

class ListFollowMangaLoaded extends UserState {
  final List<Manga> mangas;
  const ListFollowMangaLoaded(this.mangas);

  @override
  List<Object> get props => [mangas];
}

class ListHistoryMangaLoaded extends UserState {
  final List<Manga> mangas;
  const ListHistoryMangaLoaded(this.mangas);

  @override
  List<Object> get props => [mangas];
}
