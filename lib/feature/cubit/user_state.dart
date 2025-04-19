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
  final int total;
  final int totalPages;
  final int currentPage;
  const ListFollowMangaLoaded(
    this.mangas,
    this.total,
    this.totalPages,
    this.currentPage,
  );

  @override
  List<Object> get props => [mangas, total, totalPages, currentPage];
}

class CheckFollowManga extends UserState {
  final List<String> listId;
  const CheckFollowManga(this.listId);

  @override
  List<Object> get props => [listId];
}

class ListHistoryMangaLoaded extends UserState {
  final List<Manga> mangas;
  final int total;
  final int totalPages;
  final int currentPage;
  const ListHistoryMangaLoaded(
    this.mangas,
    this.total,
    this.totalPages,
    this.currentPage,
  );

  @override
  List<Object> get props => [mangas, total, totalPages, currentPage];
}
