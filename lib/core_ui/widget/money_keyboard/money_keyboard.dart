import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:app/common/define/app_size.dart';
import 'package:app/common/extensions/num_exts.dart';
import 'package:app/common/extensions/string_exts.dart';
import 'package:app/core_ui/app_theme.dart/app_color/app_colors.dart';
import 'package:app/core_ui/app_theme.dart/app_color/color_theme/color_define.dart';
import 'package:app/core_ui/app_theme.dart/app_text_style.dart';
import 'package:app/core_ui/design_system/app_divider.dart';
import 'package:app/core_ui/widget/money_keyboard/money_keyboard_suggest.dart';

double heightKeyboard = (46 * 4) + 24;
double heightSuggest = heightKeyboard + 50;

class MoneyKeyboard extends StatefulWidget {
  const MoneyKeyboard(
      {super.key,
      required this.controller,
      this.maxLength = 30,
      this.onChange,
      this.onDone,
      this.showSuggest = true});
  final TextEditingController controller;
  final int maxLength;
  final Function? onChange;
  final Function? onDone;
  final bool showSuggest;

  @override
  State<MoneyKeyboard> createState() => _MoneyKeyboardState();
}

class _MoneyKeyboardState extends State<MoneyKeyboard> {
  StreamController<List<num>> controllerSuggest = StreamController<List<num>>();

  final defaultSuggest = [1000000, 10000000, 100000000];

  @override
  void dispose() {
    controllerSuggest.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StreamBuilder<List<num>>(
            stream: controllerSuggest.stream,
            builder: (context, snapshot) {
              return MoneyKeyboardSuggest(
                  listMoneySuggest: snapshot.data ?? defaultSuggest,
                  onCallBack: (money) {
                    widget.controller.text = money.stringMoney();
                    widget.controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: widget.controller.text.length));
                    widget.onChange?.call();
                  });
            }),
        const AppDivider(),
        const Gap(8),
        _keyboard(),
      ],
    );
  }

  Container _keyboard() {
    return Container(
      color: AppColors.gray300,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          height: heightKeyboard,
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.75,
                child: Column(
                  children: [
                    Row(children: [
                      _phoneKey(label: "1"),
                      const Gap(AppSize.k6),
                      _phoneKey(label: "2"),
                      const Gap(AppSize.k6),
                      _phoneKey(label: "3")
                    ]),
                    const Gap(AppSize.k6),
                    Row(children: [
                      _phoneKey(label: "4"),
                      const Gap(AppSize.k6),
                      _phoneKey(label: "5"),
                      const Gap(AppSize.k6),
                      _phoneKey(label: "6")
                    ]),
                    const Gap(AppSize.k6),
                    Row(children: [
                      _phoneKey(label: "7"),
                      const Gap(AppSize.k6),
                      _phoneKey(label: "8"),
                      const Gap(AppSize.k6),
                      _phoneKey(label: "9")
                    ]),
                    const Gap(AppSize.k6),
                    Row(children: [
                      _phoneKey(label: "000"),
                      const Gap(AppSize.k6),
                      _phoneKey(label: "0"),
                      const Gap(AppSize.k6),
                      _phoneKey(label: "")
                    ])
                  ],
                ),
              ),
              const Gap(AppSize.k6),
              Expanded(
                  child: Column(children: [
                Expanded(child: _backspaceKey(context)),
                const Gap(AppSize.k6),
                Expanded(child: _doneKey(context)),
                const Gap(AppSize.k6),
              ]))
            ],
          ),
        ),
      ),
    );
  }

  Widget _phoneKey({required label}) {
    return Expanded(
        child: SizedBox(
            height: 46,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.white,
                ),
              ),
              onPressed: () {
                String temp = widget.controller.text + label;
                final stringMoney = temp.numFromMoney().stringMoney();
                if (stringMoney.length > widget.maxLength) return;
                widget.controller.text = stringMoney;
                widget.controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: widget.controller.text.length));
                _buildListSugget(stringMoney);
                widget.onChange?.call();
              },
              child: Text(
                label,
                style: AppsTextStyle.text24Weight400
                    .copyWith(color: AppColors.gray900),
              ),
            )));
  }

  Widget _backspaceKey(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            Colors.white,
          ),
        ),
        onPressed: () {
          if (widget.controller.text.isEmpty) {
            return;
          }
          String temp = widget.controller.text
              .substring(0, widget.controller.text.length - 1);
          final stringMoney = temp.numFromMoney().stringMoney();
          stringMoney != '0'
              ? widget.controller.text = stringMoney
              : widget.controller.clear();
          widget.controller.selection = TextSelection.fromPosition(
              TextPosition(offset: widget.controller.text.length));
          _buildListSugget(stringMoney);
          widget.onChange?.call();
        },
        child: Icon(
          Icons.backspace,
          size: 24,
          color: AppColors.gray900,
        ),
      ),
    );
  }

  Widget _doneKey(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            ColorDefine.kssPrimary,
          ),
        ),
        onPressed: () {
          if (widget.onDone != null) {
            widget.onDone!();
          }
        },
        child: Text("Xong", style: AppsTextStyle.text16Weight500),
      ),
    );
  }

  _buildListSugget(String text) {
    List<num> listMoneySuggest = defaultSuggest;
    num offset = 10;
    num money = text.numFromMoney();
    if (money != 0) {
      if ('$money'.length <= 5) {
        final x1 = 7 - '$money'.length;
        offset = pow(10, x1);
      }

      if ('$money'.length <= 8 && '$money'.length > 5) {
        offset = 10;
      }

      if (money.toString().length > 8 && money > listMoneySuggest[2]) {
        listMoneySuggest = defaultSuggest;
        controllerSuggest.sink.add(listMoneySuggest);
        return;
      }
      listMoneySuggest = [
        money * offset,
        money * offset * 10,
        money * offset * 100
      ];
    }
    controllerSuggest.sink.add(listMoneySuggest);
  }
}
