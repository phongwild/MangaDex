import 'package:app/core_ui/widget/loading/loading.dart';
import 'package:app/feature/cubit/manga_cubit.dart';
import 'package:app/feature/models/manga_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core_ui/app_theme.dart/app_text_style.dart';

class ListMangaByGenreWidget extends StatefulWidget {
  const ListMangaByGenreWidget({super.key, required this.title});
  final String title;
  @override
  State<ListMangaByGenreWidget> createState() => _ListMangaByGenreWidgetState();
}

class _ListMangaByGenreWidgetState extends State<ListMangaByGenreWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: AppsTextStyle.text18Weight700
                .copyWith(color: const Color(0xff374151)),
          ),
          const SizedBox(height: 10),
          list([])
        ],
      ),
    );
  }

  Widget list(List<Manga> mangas) {
    return BlocBuilder<MangaCubit, MangaState>(
      builder: (context, state) {
        if (state is MangaLoading) {
          return const VPBankLoading();
        }
        if (state is MangaError) {
          return Center(
            child: Text(state.message),
          );
        }
        if (state is MangaLoaded) {}
        return const SizedBox();
      },
    );
  }
}
