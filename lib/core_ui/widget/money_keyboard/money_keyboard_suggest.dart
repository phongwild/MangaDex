import 'package:flutter/material.dart';
import 'package:app/common/define/app_size.dart';
import 'package:app/common/extensions/num_exts.dart';
import 'package:app/core_ui/app_theme.dart/app_color/app_colors.dart';
import 'package:app/core_ui/app_theme.dart/app_text_style.dart';


class MoneyKeyboardSuggest extends StatelessWidget {
  const MoneyKeyboardSuggest(
      {super.key, required this.listMoneySuggest, required this.onCallBack});

  final List<num> listMoneySuggest;
  final Function(num) onCallBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSize.k16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          height: 40,
          child: Row(
              children: List.generate(
                  listMoneySuggest.length,
                  (index) => _Item(
                        money: listMoneySuggest[index],
                        isLastIndex: index == listMoneySuggest.length - 1,
                        callBack: (money) {
                          onCallBack(money);
                        },
                      ))),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item(
      {required this.money,
      required this.callBack,
      required this.isLastIndex});
  final num money;
  final Function(num) callBack;
  final bool isLastIndex;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: AppColors.transparent,
          ),
          onPressed: () {
            callBack(money);
          },
          child: Text(money.stringMoney(),
              style: AppsTextStyle.text14Weight400
                  .copyWith(color: AppColors.black)),
        ),
        const SizedBox(width: AppSize.k8),
        Visibility(
            visible: !isLastIndex,
            child: Container(width: 0.5, height: 25, color: AppColors.gray500))
      ],
    );
  }
}
