part of 'detail_manga_cubit.dart';

abstract class DetailMangaState extends Equatable {
  const DetailMangaState();

  @override
  List<Object?> get props => [];
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
  final List<ChapterWrapper> chapters;
  final int total;
  final String firstChapter;

  final ChapterData? chapterData;
  final bool isChapterLoading;

  const DetailMangaStateLoaded(
    this.manga,
    this.chapters,
    this.total,
    this.firstChapter, {
    this.chapterData,
    this.isChapterLoading = false,
  });

  DetailMangaStateLoaded copyWith({
    List<ChapterWrapper>? chapters,
    ChapterData? chapterData,
    bool? isChapterLoading,
  }) {
    return DetailMangaStateLoaded(
      manga,
      chapters ?? this.chapters,
      total,
      firstChapter,
      chapterData: chapterData ?? this.chapterData,
      isChapterLoading: isChapterLoading ?? this.isChapterLoading,
    );
  }

  @override
  List<Object?> get props => [
        manga,
        chapters,
        firstChapter,
        chapterData,
        isChapterLoading,
      ];
}

// class ChapterStateLoaded extends DetailMangaState {
//   final ChapterData chapterData;

//   const ChapterStateLoaded(this.chapterData);

//   @override
//   List<Object> get props => [chapterData];
// }
