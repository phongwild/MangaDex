import 'package:app/core/app_log.dart';
import 'package:app/core_ui/app_theme.dart/app_text_style.dart';
import 'package:app/core_ui/widget/loading/shimmer.dart';
import 'package:app/feature/cubit/manga_cubit.dart';
import 'package:app/feature/screens/search/widgets/item_manga_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MangaCubit()..searchManga(''),
      child: const _BodyPage(),
    );
  }
}

class _BodyPage extends StatefulWidget {
  const _BodyPage();

  @override
  State<_BodyPage> createState() => __BodyPageState();
}

class __BodyPageState extends State<_BodyPage> {
  final TextEditingController _searchCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffd1d5db),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              const SizedBox(height: 10),
              TextField(
                controller: _searchCtrl,
                onChanged: (value) {
                  context.read<MangaCubit>().searchManga(value);
                },
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  hintText: 'Tìm kiếm manga...',
                  prefixIcon: Icon(
                    IconlyLight.search,
                    color: Colors.grey[400],
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(153, 255, 255, 255),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none, // Ẩn viền
                  ),
                ),
              ),
              const SizedBox(height: 10),
              BlocBuilder<MangaCubit, MangaState>(
                builder: (context, state) {
                  if (state is MangaLoading) {
                    return Flexible(
                      child: Center(
                        child: LoadingShimmer().loadingCircle(),
                      ),
                    );
                  }
                  if (state is MangaError) {
                    dlog('Error: ${state.message}');
                    return Flexible(
                      child: Center(
                        child: LoadingShimmer().loadingCircle(),
                      ),
                    );
                  }
                  if (state is MangaLoaded) {
                    final mangaList = state.mangas;
                    return Expanded(
                      child: ItemMangaWidget(
                        mangaList: mangaList,
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
