part of 'manga_cubit.dart';

abstract class MangaState extends Equatable {
  const MangaState();

  @override
  List<Object> get props => [];
}

class MangaStateInitial extends MangaState {}

class MangaLoading extends MangaState {}

class MangaLoaded extends MangaState {
  final List<Manga> mangas;
  final int? total;

  const MangaLoaded(this.mangas, {this.total});

  @override
  List<Object> get props => [mangas, total!];
}

class MangaError extends MangaState {
  final String message;

  const MangaError(this.message);

  @override
  List<Object> get props => [message];
}
