import 'package:app/feature/widgets/button_app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core_ui/widget/loading/shimmer.dart';
import '../cubit/tag_cubit.dart';
import '../screens/detail/widget/tag_widget.dart';

class BottomSheetAppWidget extends StatefulWidget {
  const BottomSheetAppWidget({
    super.key,
    required this.onSelectTags,
  });

  final Function(Set<String>) onSelectTags;

  @override
  State<BottomSheetAppWidget> createState() => _BottomSheetAppWidgetState();
}

class _BottomSheetAppWidgetState extends State<BottomSheetAppWidget> {
  final ValueNotifier<Set<String>> _selectedTags = ValueNotifier({});

  void toggleTagSelection(String tagId) {
    final selected = _selectedTags.value.toSet();
    if (selected.contains(tagId)) {
      selected.remove(tagId);
    } else {
      selected.add(tagId);
    }
    _selectedTags.value = selected;
  }

  @override
  Widget build(BuildContext context) {
    return buildBottomSheet(context);
  }

  Widget buildBottomSheet(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 5,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  BlocBuilder<TagCubit, TagState>(
                    builder: (context, state) {
                      if (state is TagLoaded) {
                        return Positioned.fill(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                TagWidget(
                                  listTag: state.tags,
                                  onTap: (tag) {
                                    toggleTagSelection(tag.id);
                                  },
                                ),
                                const SizedBox(height: 80),
                              ],
                            ),
                          ),
                        );
                      }
                      return Center(child: LoadingShimmer().loadingCircle());
                    },
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: ValueListenableBuilder<Set<String>>(
                      valueListenable: _selectedTags,
                      builder: (context, selectedTags, child) {
                        return selectedTags.isNotEmpty
                            ? bottomWidget()
                            : const SizedBox();
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 45,
            width: MediaQuery.of(context).size.width * 0.4,
            child: ButtonAppWidget(
              text: 'Huỷ',
              color: const Color(0xffffffff),
              isBoxShadow: true,
              onTap: () {
                Navigator.pop(context);
              },
              textColor: const Color(0xff000000),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: 45,
            width: MediaQuery.of(context).size.width * 0.4,
            child: ButtonAppWidget(
              text: 'Chọn',
              color: const Color(0xff2563eb),
              isBoxShadow: true,
              onTap: () {
                widget.onSelectTags(_selectedTags.value);
                Navigator.pop(context);
              },
              textColor: const Color(0xffffffff),
            ),
          ),
        ],
      ),
    );
  }
}
