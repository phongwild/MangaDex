// ignore_for_file: unnecessary_null_comparison

import 'package:app/core/app_log.dart';
import 'package:app/core_ui/app_theme.dart/app_color/app_colors.dart';
import 'package:app/core_ui/app_theme.dart/app_text_style.dart';
import 'package:app/core_ui/design_system/app_button.dart';
import 'package:app/core_ui/widget/loading/shimmer.dart';
import 'package:app/feature/cubit/comments_cubit.dart';
import 'package:app/feature/cubit/detail_manga_cubit.dart';
import 'package:app/feature/cubit/user_cubit.dart';
import 'package:app/feature/models/chapter_model.dart';
import 'package:app/feature/models/manga_model.dart';
import 'package:app/feature/models/tag_model.dart';
import 'package:app/feature/router/nettromdex_router.dart';
import 'package:app/feature/screens/detail/widget/comment_widget.dart';
import 'package:app/feature/screens/detail/widget/list_chapter_widget.dart';
import 'package:app/feature/screens/detail/widget/tag_widget.dart';
import 'package:app/feature/screens/more/more_manga_page.dart';
import 'package:app/feature/screens/reading/read_chapter_page.dart';
import 'package:app/feature/utils/is_login.dart';
import 'package:app/feature/utils/time_utils.dart';
import 'package:app/feature/utils/toast_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import '../../widgets/button_app_widget.dart';
import 'widget/cover_detail_widget.dart';
import 'widget/description_widget.dart';

class DetailMangaPage extends StatelessWidget {
  const DetailMangaPage(
      {super.key,
      required this.idManga,
      required this.coverArt,
      required this.lastUpdate,
      required this.title});
  final String idManga;
  final String title;
  final String coverArt;
  final String lastUpdate;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final cubit = DetailMangaCubit();
            cubit.getDetailManga(idManga, true).then((_) {
              cubit.getAllChapter(idManga);
            });
            return cubit;
          },
        ),
        BlocProvider.value(value: context.read<UserCubit>()),
        BlocProvider(
          create: (context) => CommentsCubit(),
        )
      ],
      child: _BodyPage(
        idManga: idManga,
        coverArt: coverArt,
        lastUpdate: lastUpdate,
        title: title,
      ),
    );
  }
}

class _BodyPage extends StatefulWidget {
  const _BodyPage({
    required this.idManga,
    required this.coverArt,
    required this.lastUpdate,
    required this.title,
  });
  final String idManga;
  final String coverArt;
  final String lastUpdate;
  final String title;
  @override
  State<_BodyPage> createState() => __BodyPageState();
}

class __BodyPageState extends State<_BodyPage> {
  final ValueNotifier<int> currentPage = ValueNotifier(1);
  final ValueNotifier<List<Chapter>> listAllChapters = ValueNotifier([]);
  final ValueNotifier<bool> isFollowing = ValueNotifier(false);
  final ValueNotifier<bool> isFollowingLoading = ValueNotifier(false);
  List<Manga> listFollows = [];
  final IsLogin _isLogin = IsLogin.getInstance();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_isLogin.isLoggedIn) {
        context.read<UserCubit>().addToHistory(widget.idManga);
        context.read<CommentsCubit>().getComments(widget.idManga);
        final listId =
            await context.read<UserCubit>().checkListFollowManga(limit: 500);
        isFollowing.value = listId.contains(widget.idManga);
      }
    });
  }

  @override
  void didUpdateWidget(covariant _BodyPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_isLogin.isLoggedIn) {
        final listId =
            await context.read<UserCubit>().checkListFollowManga(limit: 500);
        isFollowing.value = listId.contains(widget.idManga);
      }
    });
  }

  // Hàm xử lý trạng thái theo dõi
  void handleUserState(UserState state) {
    if (state is UserError) {
      showToast('Bạn cần đăng nhập để theo dõi truyện !!', isError: true);
    } else if (state is AlreadyFollowedManga) {
      showToast('Truyện đã được theo dõi !!', isError: true);
    } else if (state is FollowMangaSuccess) {
      showToast('Theo dõi thành công !!');
      isFollowing.value = true;
    } else if (state is UnFollowMangaSuccess) {
      showToast('Huỷ theo dõi thành công !!', isError: true);
      isFollowing.value = false;
    }
    isFollowingLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        toolbarHeight: 40,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_rounded, color: AppColors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) => CupertinoActionSheet(
                  actions: <CupertinoActionSheetAction>[
                    CupertinoActionSheetAction(
                      onPressed: () {
                        final urlManga =
                            'https://mangadex.org/title/${widget.idManga}';
                        Clipboard.setData(ClipboardData(text: urlManga));
                        Navigator.pop(context);
                        showToast('Sao chép thành công');
                      },
                      isDefaultAction: true,
                      child: Text(
                        'Sao chép địa chỉ manga',
                        style: AppsTextStyle.text14Weight600,
                      ),
                    ),
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    isDestructiveAction: true,
                    child: Text(
                      'Huỷ',
                      style: AppsTextStyle.text14Weight600,
                    ),
                  ),
                ),
              );
            },
            icon: Icon(Icons.ios_share_outlined, color: AppColors.white),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(
            left: 8,
            right: 8,
            bottom: 10,
          ),
          child: BlocBuilder<DetailMangaCubit, DetailMangaState>(
            buildWhen: (previous, current) => current is DetailMangaStateLoaded,
            builder: (context, state) {
              if (state is DetailMangaStateLoading) {
                return Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: LoadingShimmer().loadingCircle(),
                      ),
                    ),
                  ],
                );
              }
              if (state is DetailMangaStateError) {
                return Center(
                  child: Text(state.message),
                );
              }
              if (state is DetailMangaStateLoaded) {
                final data = state.manga;
                final List<ChapterWrapper> chapters = state.chapters;
                final List<Tag> tag = data.attributes.tags;
                final description = data.attributes.getPreferredDescription();
                final String firstChapter = state.firstChapter;
                final int total = state.total;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 12),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: AppColors.black.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: const Offset(4, 4),
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CoverDetailWidget(
                                      coverArt: widget.coverArt,
                                    ),
                                    const SizedBox(height: 15),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                        data.attributes.getPreferredTitle(),
                                        style: AppsTextStyle.text18Weight700,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                        data.attributes.getAltTitle(),
                                        style: AppsTextStyle.text14Weight400,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          IconlyLight.timeCircle,
                                          color: AppColors.blue,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          timeAgo(state
                                                  .manga.attributes.updatedAt ??
                                              ''),
                                          style: AppsTextStyle.text12Weight400,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      child: TagWidget(
                                        listTag: tag,
                                        isEnable: false,
                                        onTap: (id) {
                                          Navigator.pushNamed(
                                            context,
                                            NettromdexRouter.moreManga,
                                            arguments:
                                                MoreMangaPage(tag: id.id),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: BlocListener<UserCubit, UserState>(
                                        listener: (context, state) {
                                          handleUserState(state);
                                          if (state is CheckFollowManga) {
                                            isFollowing.value = state.listId
                                                .contains(widget.idManga);
                                          }
                                          if (state is UserError) {
                                            dlog('Lỗi: ${state.message}');
                                          }
                                        },
                                        child: ValueListenableBuilder<bool>(
                                          valueListenable: isFollowingLoading,
                                          builder: (context, isLoading, child) {
                                            return AppButton(
                                                action: isLoading
                                                    ? 'Đang xử lý...'
                                                    : (isFollowing.value
                                                        ? 'Đang theo dõi'
                                                        : 'Theo dõi truyện'),
                                                borderRadius: 12,
                                                colorEnable: AppColors.blue,
                                                colorDisable: AppColors.blue,
                                                textStyle: AppsTextStyle
                                                    .text14Weight500
                                                    .copyWith(
                                                  color: AppColors.white,
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 12,
                                                ),
                                                loading: isLoading,
                                                onPressed: () async {
                                                  if (!_isLogin.isLoggedIn) {
                                                    showToast(
                                                        'Bạn cần đăng nhập để theo dõi truyện !!',
                                                        isError: true);
                                                    return;
                                                  }
                                                  if (isFollowing.value) {
                                                    // Đang theo dõi -> huỷ theo dõi
                                                    isFollowingLoading.value =
                                                        true;
                                                    await context
                                                        .read<UserCubit>()
                                                        .unFollowManga(
                                                            widget.idManga);
                                                    isFollowing.value = false;
                                                    isFollowingLoading.value =
                                                        false;
                                                  } else {
                                                    // Chưa theo dõi -> thực hiện theo dõi
                                                    isFollowingLoading.value =
                                                        true;
                                                    await context
                                                        .read<UserCubit>()
                                                        .followManga(
                                                            widget.idManga);
                                                    isFollowing.value = true;
                                                    isFollowingLoading.value =
                                                        false;
                                                  }
                                                });
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: ButtonAppWidget(
                                        text: 'Đọc từ chap 1',
                                        color: AppColors.bgMain,
                                        isBoxShadow: false,
                                        textColor: AppColors.black,
                                        onTap: () {
                                          if (firstChapter == null) {
                                            showToast(
                                              'Truyện chưa có chương nào :<',
                                              isError: true,
                                            );
                                            return;
                                          }
                                          Navigator.pushNamed(context,
                                              NettromdexRouter.readChapter,
                                              arguments: ReadChapterPage(
                                                idChapter: firstChapter,
                                                idManga: widget.idManga,
                                                listChapters: chapters,
                                                chapter: '1',
                                              ));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      DescriptionWidget(
                        desc: description,
                      ),
                      const SizedBox(height: 10),
                      if (chapters.isNotEmpty && total > 0)
                        ListChapterWidget(
                          key: ValueKey(chapters.length),
                          listChapters: chapters,
                          idManga: widget.idManga,
                          total: total,
                          currentPage: currentPage,
                        )
                      else
                        listNull(),
                      CommentWidget(
                        mangaID: widget.idManga,
                        uid: _isLogin.uid ?? '',
                      )
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget listNull() {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.buttonDisablePopup,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'Truyện chưa có chương nào :((',
          style: AppsTextStyle.text14Weight400.copyWith(
            color: AppColors.gray700,
          ),
        ),
      ),
    );
  }
}
