part of 'manga_cubit.dart';

abstract class MangaState extends Equatable {
  const MangaState();

  @override
  List<Object?> get props => [];
}

class MangaInitial extends MangaState {
  const MangaInitial();
}

class MangaLoading extends MangaState {
  const MangaLoading();
}

class MangaLoaded extends MangaState {
  final List<Manga> mangas;
  final int total;

  const MangaLoaded(this.mangas, {required this.total});

  @override
  List<Object?> get props => [mangas, total];
}

class MangaError extends MangaState {
  final String message;

  const MangaError(this.message);

  @override
  List<Object?> get props => [message];
}

class MangaNoData extends MangaState {
  const MangaNoData();
}
