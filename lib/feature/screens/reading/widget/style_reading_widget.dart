import 'package:app/core_ui/app_theme.dart/app_color/app_colors.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core_ui/app_theme.dart/app_text_style.dart';

class StyleReading extends StatelessWidget {
  const StyleReading({
    super.key,
    required this.styleReading,
  });

  final ValueNotifier<bool> styleReading;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 15,
      left: 100,
      right: 100,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          height: 40,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    styleReading.value = !styleReading.value;
                  },
                  child: Container(
                    color: styleReading.value
                        ? const Color(0xff2563eb)
                        : const Color(0xff18212f),
                    alignment: Alignment.center,
                    child: Text(
                      'Classic UI',
                      style: AppsTextStyle.text14Weight600.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    styleReading.value = !styleReading.value;
                  },
                  child: Container(
                    color: styleReading.value
                        ? const Color(0xff18212f)
                        : const Color(0xff2563eb),
                    alignment: Alignment.center,
                    child: Text(
                      'Zen UI',
                      style: AppsTextStyle.text14Weight600.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
