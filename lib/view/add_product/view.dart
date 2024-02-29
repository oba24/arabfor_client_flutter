import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import '../../common/btn.dart';
import '../../common/custom_text_failed.dart';
import '../../gen/assets.gen.dart';
import '../../generated/locale_keys.g.dart';
import '../../helper/asset_image.dart';
import '../../helper/extintions.dart';
import '../../helper/image_picker.dart';
import '../../helper/rout.dart';
import '../nav_bar/view.dart';

import '../../common/alert.dart';
import 'bloc/event.dart';

class AddProductView extends StatefulWidget {
  const AddProductView({Key? key}) : super(key: key);

  @override
  State<AddProductView> createState() => _AddProductViewState();
}

class _AddProductViewState extends State<AddProductView> {
  final StartAddProductEvent _event = StartAddProductEvent();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: "#FBF9F4".toColor,
      appBar: AppBar(
        backgroundColor: "#FBF9F4".toColor,
        centerTitle: true,
        title: Text(
          LocaleKeys.add_product.tr(),
          style: context.textTheme.headline2,
          textAlign: TextAlign.center,
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded),
          color: context.color.secondary,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 127.h,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    _event.images.length,
                    (i) {
                      if (_event.images[i].path.startsWith("http")) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10.px),
                          child: CustomImage(
                            _event.images[i].path,
                            height: 127.h,
                            fit: BoxFit.fill,
                            width: 137.w,
                          ),
                        ).paddingSymmetric(horizontal: 8.w);
                      } else {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10.px),
                          child: Image.file(
                            _event.images[i],
                            height: 127.h,
                            fit: BoxFit.fill,
                            width: 137.w,
                          ),
                        ).paddingSymmetric(horizontal: 8.w);
                      }
                    },
                  )..add(
                      InkWell(
                        onTap: () {
                          CustomImagePicker.openImagePicker(onSubmit: (v) {
                            setState(() {
                              _event.images.add(v);
                            });
                          });
                        },
                        child: Container(
                          width: 101.h,
                          height: 93.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: const Color(0xFFF7F5EF),
                            border: Border.all(
                              width: 1.0,
                              color: "#43290A".toColor.withOpacity(0.05),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomImage(
                                Assets.images.camiraIcon.path,
                                height: 26.h,
                                color: context.color.secondary,
                              ),
                              Text(
                                LocaleKeys.add_photo.tr(),
                                style: context.textTheme.subtitle2,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ).paddingSymmetric(horizontal: 8.w),
                      ),
                    ),
                ),
              ),
            ).paddingOnly(top: 32.h, bottom: 16.h),
            CustomTextFailed(
              hint: LocaleKeys.product_name.tr(),
            ).paddingSymmetric(horizontal: 24.w, vertical: 14.h),
            CustomTextFailed(
              hint: LocaleKeys.product_description.tr(),
            ).paddingSymmetric(horizontal: 24.w, vertical: 14.h),
            CustomTextFailed(
              hint: LocaleKeys.main_category.tr(),
              endIcon: Icon(Icons.arrow_forward_ios, color: context.color.secondary, size: 15.px),
            ).paddingSymmetric(horizontal: 24.w, vertical: 14.h),
            CustomTextFailed(
              hint: LocaleKeys.sub_category.tr(),
              endIcon: Icon(Icons.arrow_forward_ios, color: context.color.secondary, size: 15.px),
            ).paddingSymmetric(horizontal: 24.w, vertical: 14.h),
            CustomTextFailed(
              hint: LocaleKeys.Price_before_discount.tr(),
              keyboardType: TextInputType.number,
              endIcon: SizedBox(
                width: 5,
                child: Text(
                  LocaleKeys.SR.tr(),
                  style: context.textTheme.headline6,
                ).onCenter,
              ),
            ).paddingSymmetric(horizontal: 24.w, vertical: 14.h),
            CustomTextFailed(
              hint: LocaleKeys.price_after_discount.tr(),
              keyboardType: TextInputType.number,
              endIcon: SizedBox(
                width: 5,
                child: Text(
                  LocaleKeys.SR.tr(),
                  style: context.textTheme.headline6,
                ).onCenter,
              ),
            ).paddingSymmetric(horizontal: 24.w, vertical: 14.h),
            CustomTextFailed(
              hint: LocaleKeys.Shipping_and_delivery_price.tr(),
              keyboardType: TextInputType.number,
              endIcon: SizedBox(
                width: 5,
                child: Text(
                  LocaleKeys.SR.tr(),
                  style: context.textTheme.headline6,
                ).onCenter,
              ),
            ).paddingSymmetric(horizontal: 24.w, vertical: 14.h),
            CustomTextFailed(
              hint: LocaleKeys.Shipping_and_delivery_period.tr(),
              keyboardType: TextInputType.number,
              endIcon: SizedBox(
                width: 5,
                child: Text(
                  LocaleKeys.days.tr(),
                  style: context.textTheme.headline6,
                ).onCenter,
              ),
            ).paddingSymmetric(horizontal: 24.w, vertical: 14.h),
            CustomTextFailed(
              hint: LocaleKeys.discount_percentage.tr(),
              keyboardType: TextInputType.number,
            ).paddingSymmetric(horizontal: 24.w, vertical: 14.h),
            CustomTextFailed(
              hint: LocaleKeys.quantity_available.tr(),
              keyboardType: TextInputType.number,
            ).paddingSymmetric(horizontal: 24.w, vertical: 14.h),
            Btn(
              text: LocaleKeys.add_product.tr(),
              onTap: () => CustomAlert.succAlert(
                LocaleKeys.product_has_been_successfully_added.tr(),
                Btn(
                  text: LocaleKeys.Main.tr(),
                  onTap: () => push(const NavBarView(page: 0)),
                ),
              ),
            ).paddingSymmetric(horizontal: 24.w, vertical: 24.h)
          ],
        ),
      ),
    );
  }
}
