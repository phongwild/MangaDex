import 'package:flutter/cupertino.dart';
import '../../../widgets/bottom_sheet_app_widget.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({
    super.key,
    required this.onSelected,
  });

  final Function(Set<String>) onSelected;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      maxChildSize: 0.9,
      minChildSize: 0.2,
      expand: false,
      builder: (context, scrollController) {
        return BottomSheetAppWidget(
          onSelectTags: onSelected,
        );
      },
    );
  }
}
