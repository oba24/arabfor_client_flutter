import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:saudimarchclient/helper/rout.dart';
import 'package:saudimarchclient/view/auth/login/view.dart';
import 'package:saudimarchclient/view/auth/register/view.dart';
import '../../common/btn.dart';
import '../../generated/locale_keys.g.dart';
import '/../gen/assets.gen.dart';
import '/../helper/asset_image.dart';
import '/../helper/extintions.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.primaryContainer,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 398.h,
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage(Assets.images.welcome.path))),
            alignment: Alignment.topCenter,
            child: CustomImage(Assets.svg.welcome, height: 249.76.h).paddingOnly(top: 44.h),
          ),
          CustomImage(Assets.svg.logo, height: 84.15.h).paddingOnly(top: 37.h, bottom: 21.h),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: LocaleKeys.welcome.tr(), style: context.textTheme.headline1!.copyWith(fontSize: 40)),
                const TextSpan(text: "\n"),
                TextSpan(
                  text: LocaleKeys.Record_and_enjoy_a_unique_feature_and_experience.tr(),
                  style: context.textTheme.subtitle1!.copyWith(color: context.color.tertiary),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          Btn(onTap: () => pushAndRemoveUntil(const RegisterView()), text: LocaleKeys.Create_an_account.tr())
              .paddingSymmetric(horizontal: 38.h, vertical: 24.w),
          InkWell(
            onTap: () => push(const LoginView()),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: LocaleKeys.You_have_already_account.tr(), style: context.textTheme.subtitle1),
                  const TextSpan(text: " "),
                  TextSpan(text: LocaleKeys.Login.tr(), style: context.textTheme.headline5?.copyWith(color: context.color.secondary)),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
