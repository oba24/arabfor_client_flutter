import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:saudimarchclient/common/btn.dart';
import 'package:saudimarchclient/gen/assets.gen.dart';
import 'package:saudimarchclient/generated/locale_keys.g.dart';
import 'package:saudimarchclient/helper/asset_image.dart';
import 'package:saudimarchclient/helper/extintions.dart';
import 'package:saudimarchclient/helper/rout.dart';

import '../nav_bar/view.dart';

class OrderSuccessView extends StatefulWidget {
  final dynamic id;
  const OrderSuccessView({Key? key, required this.id}) : super(key: key);

  @override
  State<OrderSuccessView> createState() => _OrderSuccessViewState();
}

class _OrderSuccessViewState extends State<OrderSuccessView> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        push(const NavBarView());
        return false;
      },
      child: Scaffold(
        backgroundColor: "#FBF9F4".toColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImage(Assets.svg.logo, width: 150.w, height: 90.h).paddingAll(24.w),
            CustomImage(Assets.svg.success, width: 215.w, height: 215.h).paddingAll(24.w),
            Text(
              LocaleKeys.order_sent_success.tr(),
              style: context.textTheme.headline1,
            ),
            Text(
              LocaleKeys.order_no.tr(),
              style: context.textTheme.headline3,
            ),
            Text(
              '# ${widget.id}',
              style: context.textTheme.bodyText1,
            ),
            Btn(
              text: LocaleKeys.continue_shopping.tr(),
              onTap: () {
                push(const NavBarView());
              },
            ).paddingAll(24.w)
          ],
        ).onCenter,
      ),
    );
  }
}
