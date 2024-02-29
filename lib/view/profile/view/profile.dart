import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimarchclient/view/auth/login/view.dart';
import 'package:saudimarchclient/view/wallet/view.dart';
import 'package:share_plus/share_plus.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen_bloc/profile/bloc.dart';
import '../../../gen_bloc/profile/events.dart';
import '../../../gen_bloc/profile/states.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../helper/asset_image.dart';
import '../../../helper/extintions.dart';
import '../../../helper/flash_helper.dart';
import '../../../helper/loading_app.dart';
import '../../../helper/rout.dart';
import '../../../helper/user_data.dart';

import '../../competition/competition_view.dart';
import '../../favorit/view.dart';
import '../../orders/view.dart';
import '../../setting/common_questions.dart';
import '../../setting/contact_view.dart';
import '../../setting/pages.dart';
import '../../setting/support_view.dart';
import '../../user_address/view/addresses.dart';
import 'update_profile.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ProfileBloc _logoutBloc = KiwiContainer().resolve<ProfileBloc>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: "#FBF9F4".toColor,
      floatingActionButton: FloatingActionButton(
          backgroundColor: "#44DE8C".toColor,
          child: CustomIconImg(
            Assets.svg.contact,
            color: Colors.white,
          ),
          onPressed: () => push(const ContactView())),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 50.h),
        children: [
          Row(
            children: [
              CustomImage(
                UserHelper.isAuth ? UserHelper.userDatum.image : Assets.svg.homeLogo,
                fit: BoxFit.contain,
                width: 78.h,
                border: Border.all(color: Colors.white, width: 2.w),
                height: 78.h,
                borderRadius: BorderRadius.circular(1000),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: Text(
                  UserHelper.isAuth ? UserHelper.userDatum.userName : LocaleKeys.app_name.tr(),
                  style: context.textTheme.headline2,
                ),
              ),
              if (UserHelper.isAuth) IconButton(onPressed: () => push(const EditProfileView()), icon: CustomImage(Assets.svg.edit))
            ],
          ).paddingSymmetric(horizontal: 32.w),
          SizedBox(height: 20.h),
          ListTile(
            onTap: () => push(const FavoriteView()),
            title: Text(
              LocaleKeys.Favorite.tr(),
              style: context.textTheme.subtitle1,
            ),
            leading: CustomImage(
              Assets.images.iconWishlist.path,
              height: 40.h,
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ).paddingSymmetric(horizontal: 24.w, vertical: 2.h),
          ListTile(
            onTap: () => push(const OrdersView()),
            title: Text(
              LocaleKeys.My_requests.tr(),
              style: context.textTheme.subtitle1,
            ),
            leading: CustomImage(
              Assets.images.orders.path,
              height: 40.h,
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ).paddingSymmetric(horizontal: 24.w, vertical: 2.h),
          ListTile(
            onTap: () => push(const CompetitionView()),
            title: Text(
              LocaleKeys.competitions_and_awards.tr(),
              style: context.textTheme.subtitle1,
            ),
            leading: CustomImage(
              Assets.images.quiz.path,
              height: 40.h,
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ).paddingSymmetric(horizontal: 24.w, vertical: 2.h),
          ListTile(
            onTap: () => push(const WalletView()),
            title: Text(
              LocaleKeys.Portfolio.tr(),
              style: context.textTheme.subtitle1,
            ),
            leading: CustomImage(
              Assets.images.walletIcon.path,
              height: 40.h,
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ).paddingSymmetric(horizontal: 24.w, vertical: 2.h),
          // ListTile(
          //   title: Text(
          //     LocaleKeys.Complaints_and_suggestions.tr(),
          //     style: context.textTheme.subtitle1,
          //   ),
          //   leading: CustomImage(
          //     Assets.images.iconEditProfile.path,
          //     height: 40.h,
          //   ),
          //   trailing: const Icon(Icons.arrow_forward_ios_rounded),
          // ).paddingSymmetric(horizontal: 24.w, vertical: 2.h),
          ListTile(
            onTap: () => push(const AddressesView()),
            title: Text(
              LocaleKeys.addresses.tr(),
              style: context.textTheme.subtitle1,
            ),
            leading: CustomImage(
              Assets.images.adresses.path,
              height: 40.h,
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ).paddingSymmetric(horizontal: 24.w, vertical: 2.h),
          ListTile(
            onTap: () {
              push(const CommonQuestionsView());
            },
            title: Text(
              LocaleKeys.common_questions.tr(),
              style: context.textTheme.subtitle1,
            ),
            leading: CustomImage(
              Assets.images.commonQuestion.path,
              height: 40.h,
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ).paddingSymmetric(horizontal: 24.w, vertical: 2.h),
          // ListTile(
          //   title: Text(
          //     LocaleKeys.call_us.tr(),
          //     style: context.textTheme.subtitle1,
          //   ),
          //   leading: CustomImage(
          //     Assets.images.callUs.path,
          //     height: 40.h,
          //   ),
          //   trailing: const Icon(Icons.arrow_forward_ios_rounded),
          // ).paddingSymmetric(horizontal: 24.w, vertical: 2.h),
          // ListTile(
          //   title: Text(
          //     LocaleKeys.Terms_and_Conditions.tr(),
          //     style: context.textTheme.subtitle1,
          //   ),
          //   leading: CustomImage(
          //     Assets.images.iconEditProfile.path,
          //     height: 40.h,
          //   ),
          //   trailing: const Icon(Icons.arrow_forward_ios_rounded),
          // ).paddingSymmetric(horizontal: 24.w, vertical: 2.h),
          ListTile(
            onTap: () {
              push(PagesView(type: 'policy', title: LocaleKeys.Usage_policy.tr()));
            },
            title: Text(
              LocaleKeys.Usage_policy.tr(),
              style: context.textTheme.subtitle1,
            ),
            leading: CustomImage(
              Assets.images.iconEditProfile.path,
              height: 40.h,
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ).paddingSymmetric(horizontal: 24.w, vertical: 2.h),
          ListTile(
            onTap: () {
              push(PagesView(type: 'terms', title: LocaleKeys.Terms_and_Conditions.tr()));
            },
            title: Text(
              LocaleKeys.Terms_and_Conditions.tr(),
              style: context.textTheme.subtitle1,
            ),
            leading: CustomImage(
              Assets.images.iconEditProfile.path,
              height: 40.h,
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ).paddingSymmetric(horizontal: 24.w, vertical: 2.h),
          ListTile(
            onTap: () => push(const SupportView()),
            title: Text(
              LocaleKeys.call_us.tr(),
              style: context.textTheme.subtitle1,
            ),
            leading: CustomImage(
              Assets.images.callUs.path,
              height: 40.h,
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ).paddingSymmetric(horizontal: 24.w, vertical: 2.h),
          ListTile(
            onTap: () {
              push(PagesView(type: 'about', title: LocaleKeys.About_application.tr()));
            },
            title: Text(
              LocaleKeys.About_application.tr(),
              style: context.textTheme.subtitle1,
            ),
            leading: CustomImage(
              Assets.images.aboutApp.path,
              height: 40.h,
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ).paddingSymmetric(horizontal: 24.w, vertical: 2.h),

          ListTile(
            onTap: () => Share.share(
                "يمكنك الان تحميل تطبيق عرب فور من العناوين الاتية\n\nِAndroid: https://play.google.com/store/apps/details?id=com.alalmiyalhura.saudimarchclient\n\nIos: https://apps.apple.com/us/app/%D8%B3%D8%B9%D9%88%D8%AF%D9%8A-%D9%85%D8%A7%D8%B1%D8%B4%D9%8A%D8%A9/id1629653278"),
            title: Text(
              LocaleKeys.Share_application.tr(),
              style: context.textTheme.subtitle1,
            ),
            leading: CustomImage(
              Assets.images.shear.path,
              height: 40.h,
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
          ).paddingSymmetric(horizontal: 24.w, vertical: 2.h),
          ListTile(
            onTap: () {
              print(LocaleKeys.Lang.tr());
              context.setLocale(context.locale.languageCode == "ar" ? const Locale('en', 'US') : const Locale('ar', 'SA'));
              Phoenix.rebirth(context);
            },
            title: Text(LocaleKeys.language.tr(), style: context.textTheme.subtitle1),
            leading: CustomImage(Assets.images.language.path, height: 40.h),
          ).paddingSymmetric(horizontal: 24.w, vertical: 2.h),
          BlocConsumer(
            bloc: _logoutBloc,
            listener: (context, state) {
              if (state is DoneLogoutState) {
                FlashHelper.successBar(message: state.msg);
                UserHelper.logout();
              } else if (state is FaildProfileState) {
                // FlashHelper.errorBar(message: state.msg);
                UserHelper.logout();
              }
            },
            builder: (context, snapshot) {
              return ListTile(
                onTap: () => UserHelper.isAuth ? _logoutBloc.add(StartLogoutEvent()) : push(const LoginView()),
                title: Text(UserHelper.isAuth ?LocaleKeys.Logout.tr():LocaleKeys.Login.tr(), style: context.textTheme.subtitle1, textAlign: TextAlign.right),
                leading: CustomImage(Assets.images.iconExit.path, height: 40.h),
                trailing: snapshot is LoadingProfileState
                    ? CustomProgress(size: 15.px, color: context.color.secondary)
                    : const Icon(Icons.arrow_forward_ios_rounded),
              ).paddingSymmetric(horizontal: 24.w, vertical: 2.h);
            },
          ),
        ],
      ),
    );
  }
}
