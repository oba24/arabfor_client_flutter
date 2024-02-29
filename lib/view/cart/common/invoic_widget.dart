import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:saudimarchclient/helper/extintions.dart';

import '../../../generated/locale_keys.g.dart';

class IvoiceWidget extends StatelessWidget {
  final double price;
  final double textSize;
  final String title;
  const IvoiceWidget({Key? key, required this.price, this.textSize = 18, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: context.textTheme.headline5),
        Expanded(
          child: Row(
            children: List.generate(
              25,
              (index) => Expanded(
                child: Container(height: 1, color: context.color.secondary.withOpacity(0.2)).paddingSymmetric(horizontal: 2),
              ),
            ),
          ).paddingSymmetric(horizontal: 6.w),
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: price.toString(),
                style: context.textTheme.bodyText2?.copyWith(fontSize: textSize),
              ),
              TextSpan(
                text: " ${LocaleKeys.SR.tr()}  ",
                style: context.textTheme.bodyText2?.copyWith(fontSize: 22.0),
              ),
            ],
          ),
        ),
      ],
    ).paddingSymmetric(vertical: 5.h, horizontal: 26.w);
  }
}
