part of 'detail_manga_cubit.dart';

abstract class DetailMangaState extends Equatable {
  const DetailMangaState();

  @override
  List<Object> get props => [];
}

class DetailMangaStateInitial extends DetailMangaState {}

class DetailMangaStateLoading extends DetailMangaState {}

class DetailMangaStateError extends DetailMangaState {
  final String message;

  const DetailMangaStateError(this.message);

  @override
  List<Object> get props => [message];
}

class DetailMangaStateLoaded extends DetailMangaState {
  final Manga manga;
  final List<Chapter> chapters; // Danh sách chương
  final int total;
  final String firstChapter;

  const DetailMangaStateLoaded(
    this.manga,
    this.chapters,
    this.total,
    this.firstChapter,
  );
  DetailMangaStateLoaded copyWith({List<Chapter>? chapters}) {
    return DetailMangaStateLoaded(
      manga,
      chapters ?? this.chapters,
      total,
      firstChapter,
    );
  }

  @override
  List<Object> get props => [manga, chapters, total, firstChapter];
}

class ChapterStateLoaded extends DetailMangaState {
  final ChapterData chapterData;

  const ChapterStateLoaded(this.chapterData);

  @override
  List<Object> get props => [chapterData];
}
