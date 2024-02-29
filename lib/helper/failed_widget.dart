import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:saudimarchclient/common/btn.dart';
import 'package:saudimarchclient/gen/assets.gen.dart';
import 'package:saudimarchclient/generated/locale_keys.g.dart';
import 'package:saudimarchclient/helper/extintions.dart';
import 'package:saudimarchclient/view/auth/login/common/alert.dart';

class FailedWidget extends StatelessWidget {
  final int errType;
  final String title;
  final double? height;
  final double? width;
  final double fontSize;
  final void Function()? onTap;
  final int statusCode;
  const FailedWidget({
    Key? key,
    required this.errType,
    required this.title,
    required this.onTap,
    this.height,
    this.width,
    this.fontSize = 14,
    required this.statusCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: width ?? 150.w,
              height: height,
              child: Lottie.asset(
                [Assets.loattie.networkError, Assets.loattie.worn, Assets.loattie.error][errType],
                width: 150.w,
                // height: 150.w,
                fit: BoxFit.contain,
                repeat: false,
              ),
            ),
            Text(
              title,
              style: context.textTheme.headline1?.copyWith(fontSize: fontSize, color: context.color.secondary),
            ),
            if (statusCode == 401)
              Btn(
                text: LocaleKeys.Login.tr(),
                onTap: () => LoginAlert.loginAlert().then(
                  (value) {
                    if (value == true && onTap != null) {
                      onTap!();
                    }
                  },
                ),
              ).paddingSymmetric(horizontal: 32.w, vertical: 40.h)
          ],
        ),
      ),
    );
  }
}
