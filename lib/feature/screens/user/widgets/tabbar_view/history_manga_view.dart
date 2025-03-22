import 'package:app/feature/utils/is_login.dart';
import 'package:app/feature/widgets/button_app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/app_log.dart';
import '../../../../../core_ui/widget/loading/shimmer.dart';
import '../../../../cubit/user_cubit.dart';
import '../../../../router/nettromdex_router.dart';
import '../../../search/widgets/item_manga_widget.dart';

class HistoryMangaView extends StatefulWidget {
  const HistoryMangaView({super.key});

  @override
  State<HistoryMangaView> createState() => _HistoryMangaViewState();
}

class _HistoryMangaViewState extends State<HistoryMangaView> {
  final IsLogin _isLogin = IsLogin.getInstance();
  @override
  void initState() {
    super.initState();
    if (_isLogin.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<UserCubit>().listHistory();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var blocBuilder = BlocBuilder<UserCubit, UserState>(
      buildWhen: (previous, current) => current is ListHistoryMangaLoaded,
      builder: (context, state) {
        if (state is UserLoading) {
          return Center(
            child: LoadingShimmer().loadingCircle(),
          );
        }
        if (state is UserError) {
          dlog('Error: ${state.message}');
          return Center(
            child: LoadingShimmer().loadingCircle(),
          );
        }
        if (state is ListHistoryMangaLoaded) {
          return ItemMangaWidget(mangaList: state.mangas);
        }
        return const SizedBox();
      },
    );
    return _isLogin.isLoggedIn
        ? blocBuilder
        : Column(
            children: [
              ButtonAppWidget(
                text: 'Bạn cần đăng nhập để lưu lịch sử đọc truyện',
                color: const Color(0xff2563eb),
                textColor: Colors.white,
                onTap: () =>
                    Navigator.pushNamed(context, NettromdexRouter.mainLogin),
                isBoxShadow: false,
                width: 320,
              ),
            ],
          );
  }
}
