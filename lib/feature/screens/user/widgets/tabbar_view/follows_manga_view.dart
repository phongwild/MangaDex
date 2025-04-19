import 'package:app/core/app_log.dart';
import 'package:app/feature/cubit/user_cubit.dart';
import 'package:app/feature/router/nettromdex_router.dart';
import 'package:app/feature/screens/search/widgets/item_manga_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core_ui/widget/loading/shimmer.dart';
import '../../../../utils/is_login.dart';
import '../../../../widgets/button_app_widget.dart';
import '../../../more/widget/item_offset_widget.dart';

class FollowsMangaView extends StatefulWidget {
  const FollowsMangaView({super.key});

  @override
  State<FollowsMangaView> createState() => _FollowsMangaViewState();
}

class _FollowsMangaViewState extends State<FollowsMangaView> {
  final IsLogin _isLogin = IsLogin.getInstance();
  final ValueNotifier<int> currentPage = ValueNotifier(1);
  final ValueNotifier<int> totals = ValueNotifier(0);
  static const int limit = 5;

  @override
  void initState() {
    super.initState();
    if (_isLogin.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetchFollowedManga();
      });
    }
  }

  void fetchFollowedManga() {
    final offset = currentPage.value;
    context.read<UserCubit>().listFollowManga(offset: offset, limit: limit);
  }

  void changePage(int newPage) {
    if (newPage != currentPage.value) {
      currentPage.value = newPage;
      fetchFollowedManga();
    }
  }

  Widget buildPagination(int totalPages) {
    if (totalPages <= 1) return const SizedBox();

    return ValueListenableBuilder<int>(
      valueListenable: currentPage,
      builder: (context, page, _) {
        List<Widget> items = [];

        // Page 1
        items.add(ItemOffsetWidget(
          text: '1',
          isActive: page == 1,
          onTap: () => changePage(1),
        ));

        if (totalPages <= 3) {
          for (var i = 2; i <= totalPages; i++) {
            items.add(ItemOffsetWidget(
              text: '$i',
              isActive: page == i,
              onTap: () => changePage(i),
            ));
          }
        } else {
          if (page > 3) {
            items.add(_buildDots());
          }

          int start = (page - 1).clamp(2, totalPages - 3);
          int end = (page + 1).clamp(4, totalPages - 1);

          for (int i = start; i <= end; i++) {
            items.add(ItemOffsetWidget(
              text: '$i',
              isActive: page == i,
              onTap: () => changePage(i),
            ));
          }

          if (page < totalPages - 2) {
            items.add(_buildDots());
          }

          items.add(ItemOffsetWidget(
            text: '$totalPages',
            isActive: page == totalPages,
            onTap: () => changePage(totalPages),
          ));
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items,
        );
      },
    );
  }

  Widget _buildDots() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: Text('...', style: TextStyle(fontSize: 18)),
    );
  }

  Widget _buildContent() {
    return BlocBuilder<UserCubit, UserState>(
      buildWhen: (previous, current) =>
          current is ListFollowMangaLoaded || current is UserLoading,
      builder: (context, state) {
        if (state is UserLoading) {
          return Center(child: LoadingShimmer().loadingCircle());
        }

        if (state is UserError) {
          dlog('Error: ${state.message}');
          return const Center(
            child: Text('Có lỗi xảy ra khi tải danh sách truyện (⁠´⁠；⁠ω⁠；⁠｀⁠)'),
          );
        }

        if (state is ListFollowMangaLoaded) {
          totals.value = state.total;
          currentPage.value = state.currentPage;

          return Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ItemMangaWidget(
                      mangaList: state.mangas,
                      onRefresh: () async {
                        fetchFollowedManga();
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: buildPagination(state.totalPages),
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLogin.isLoggedIn
        ? _buildContent()
        : Center(
            child: ButtonAppWidget(
              text: 'Bạn cần đăng nhập để theo dõi truyện',
              color: const Color(0xff2563eb),
              textColor: Colors.white,
              onTap: () =>
                  Navigator.pushNamed(context, NettromdexRouter.mainLogin),
              isBoxShadow: false,
              width: 320,
            ),
          );
  }
}
