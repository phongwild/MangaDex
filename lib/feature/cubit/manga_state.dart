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
  final int? latestUploadedChapter;
  final String? updateAt;
  final int? total;

  const MangaLoaded(
    this.mangas, {
    this.total,
    this.latestUploadedChapter,
    this.updateAt,
  });

  @override
  List<Object> get props => [mangas, total!];
}

class MangaError extends MangaState {
  final String message;

  const MangaError(this.message);

  @override
  List<Object> get props => [message];
}
