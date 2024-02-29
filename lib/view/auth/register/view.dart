import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimarchclient/view/auth/login/view.dart';
import '../../../gen/assets.gen.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../helper/asset_image.dart';
import '../../../helper/extintions.dart';
import '../../../helper/rout.dart';
import '../../setting/pages.dart';
import 'bloc/states.dart';
import '../../../helper/flash_helper.dart';
import '../../../common/btn.dart';
import '../../../common/custom_text_failed.dart';
import '../active_code/bloc/events.dart';
import '../active_code/view.dart';
import 'bloc/bloc.dart';
import 'bloc/events.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final StartRegisterEvent _event = StartRegisterEvent();
  final RegisterBloc _bloc = KiwiContainer().resolve();
  bool isAcceptedTerms = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.primary,
      body: SingleChildScrollView(
        child: Form(
          key: _event.formKey,
          child: Column(
            children: [
              CustomImage(
                Assets.svg.logo,
                height: 85.h,
                fit: BoxFit.fill,
              ).paddingOnly(top: 95.h, bottom: 46.h).onCenter,
              Container(
                width: double.infinity,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(50.px), color: context.theme.primaryColor),
                child: Column(
                  children: [
                    Text(LocaleKeys.welcome.tr(), style: context.textTheme.headline1).paddingOnly(top: 38.h, bottom: 14.h),
                    Text(
                      LocaleKeys.Please_enter_the_following_data_to_create_a_new_account.tr(),
                      style: context.textTheme.subtitle1,
                      textAlign: TextAlign.center,
                    ).paddingOnly(bottom: 34.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextFailed(
                          controller: _event.userName,
                          keyboardType: TextInputType.name,
                          hint: LocaleKeys.user_name.tr(),
                        ),
                        SizedBox(height: 14.h),
                        CustomTextFailed(
                          controller: _event.email,
                          keyboardType: TextInputType.emailAddress,
                          hint: LocaleKeys.Email.tr(),
                        ),
                        SizedBox(height: 14.h),
                        CustomTextFailed(
                          controller: _event.mobile,
                          keyboardType: TextInputType.phone,
                          hint: LocaleKeys.Mobile_number.tr(),
                        ),
                        SizedBox(height: 14.h),
                        CustomTextFailed(
                          controller: _event.password,
                          keyboardType: TextInputType.visiblePassword,
                          hint: LocaleKeys.password.tr(),
                        ),
                        SizedBox(height: 14.h),
                        CustomTextFailed(
                          controller: _event.confirmPassword,
                          validator: (v) {
                            if (v!.isEmpty) {
                              return "${LocaleKeys.confirm_password.tr()} ${LocaleKeys.requerd.tr()}";
                            } else if (v != _event.password.text) {
                              return LocaleKeys.The_passwords_are_not_identical.tr();
                            }
                            return null;
                          },
                          keyboardType: TextInputType.visiblePassword,
                          hint: LocaleKeys.confirm_password.tr(),
                        ),
                        SizedBox(height: 42.h),
                      ],
                    ).paddingSymmetric(horizontal: 25.w),
                  ],
                ),
              ).paddingSymmetric(horizontal: 11.w),
              SizedBox(height: 27.h),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isAcceptedTerms = !isAcceptedTerms;
                      });
                    },
                    icon: Icon(
                      isAcceptedTerms ? Icons.radio_button_checked : Icons.radio_button_off,
                      color: context.color.secondary,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      push(PagesView(type: 'terms', title: LocaleKeys.Terms_and_Conditions.tr()));
                    },
                    child: Text(
                      LocaleKeys.I_agree_with_the_terms_and_conditions.tr(),
                      style: context.textTheme.subtitle1,
                    ),
                  ),
                ],
              ).paddingSymmetric(horizontal: 24.w),
              SizedBox(height: 29.h),
              BlocConsumer(
                bloc: _bloc,
                listener: (context, state) {
                  if (state is DoneRegisterState) {
                    push(ActiveCodeView(event: StartActiveCodeEvent(type: TYPE.register, mobile: _event.mobile)));
                  } else if (state is FaildRegisterState) {
                    FlashHelper.errorBar(message: state.msg);
                  }
                },
                builder: (context, state) {
                  return Btn(
                    loading: state is LoadingRegisterState,
                    text: LocaleKeys.Create_an_account.tr(),
                    onTap: () {
                      if (!isAcceptedTerms) {
                        FlashHelper.infoBar(message: LocaleKeys.The_terms_and_conditions_must_be_approved.tr());
                      } else if (_event.formKey.currentState!.validate()) {
                        _bloc.add(_event);
                      }
                    },
                  ).paddingSymmetric(horizontal: 24.w);
                },
              ),
              SizedBox(height: 30.h),
              InkWell(
                onTap: () => pushAndRemoveUntil(const LoginView()),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: LocaleKeys.You_have_already_account.tr(), style: context.textTheme.subtitle1),
                      const TextSpan(text: " "),
                      TextSpan(
                        text: LocaleKeys.Login.tr(),
                        style: context.textTheme.headline5?.copyWith(color: context.color.secondary),
                      ),
                    ],
                  ),
                ).paddingSymmetric(vertical: 8.h),
              ),
              SizedBox(height: 56.h),
            ],
          ),
        ),
      ),
    );
  }
}
