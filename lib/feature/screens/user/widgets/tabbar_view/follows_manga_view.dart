import 'package:app/core/app_log.dart';
import 'package:app/feature/cubit/user_cubit.dart';
import 'package:app/feature/router/nettromdex_router.dart';
import 'package:app/feature/screens/search/widgets/item_manga_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core_ui/widget/loading/shimmer.dart';
import '../../../../utils/is_login.dart';
import '../../../../widgets/button_app_widget.dart';

class FollowsMangaView extends StatefulWidget {
  const FollowsMangaView({super.key});

  @override
  State<FollowsMangaView> createState() => _FollowsMangaViewState();
}

class _FollowsMangaViewState extends State<FollowsMangaView> {
  final IsLogin _isLogin = IsLogin.getInstance();
  @override
  void initState() {
    super.initState();
    if (_isLogin.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<UserCubit>().listFollowManga();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var blocBuilder = BlocBuilder<UserCubit, UserState>(
      buildWhen: (previous, current) => current is ListFollowMangaLoaded,
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
        if (state is ListFollowMangaLoaded) {
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
                text: 'Bạn cần đăng nhập để theo dõi truyện',
                color: const Color(0xff2563eb),
                textColor: Colors.white,
                onTap: () =>
                    Navigator.pushNamed(context, NettromdexRouter.mainLogin),
                isBoxShadow: false,
                width: 320,
              ),
            ],
          );
    ;
  }
}
