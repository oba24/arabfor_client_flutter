import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimarchclient/helper/flash_helper.dart';
import 'package:saudimarchclient/view/profile/bloc/states.dart';
import '../../../common/btn.dart';
import '../../../common/custom_text_failed.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen_bloc/cities/bloc.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../helper/asset_image.dart';
import '../../../helper/extintions.dart';
import '../../../helper/image_picker.dart';
import '../../../helper/rout.dart';

import '../bloc/bloc.dart';
import '../bloc/events.dart';
import 'edit_password.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final StartUpdateProfileEvent _event = StartUpdateProfileEvent();
  final CitiesBloc _citiesBloc = KiwiContainer().resolve();
  final UpdateProfileBloc _bloc = KiwiContainer().resolve<UpdateProfileBloc>();

  final GlobalKey<FormState> _fKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: "#FBF9F4".toColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: "#FBF9F4".toColor,
        title: Text(
          LocaleKeys.Edit_profile.tr(),
          style: context.textTheme.headline2,
          textAlign: TextAlign.center,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: context.color.secondary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 29.h, horizontal: 24.w),
        child: Form(
          key: _fKey,
          child: Column(
            children: [
              InkWell(
                onTap: () => CustomImagePicker.openImagePicker(
                  onSubmit: (v) {
                    _event.image = v;
                    setState(() {});
                  },
                ),
                child: SizedBox(
                  height: 116.h,
                  width: 116.h,
                  child: Stack(
                    children: [
                      Builder(
                        builder: (context) {
                          if (_event.image.path.startsWith("http")) {
                            return CustomImage(
                              _event.image.path,
                              height: 104.h,
                              width: 104.h,
                              border: Border.all(color: Colors.white, width: 2.w),
                              borderRadius: BorderRadius.circular(1000),
                            );
                          } else {
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white, width: 2.w),
                                shape: BoxShape.circle,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(1000),
                                child: Image.file(
                                  _event.image,
                                  height: 104.h,
                                  width: 104.h,
                                ),
                              ),
                            );
                          }
                        },
                      ).onCenter,
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: CustomImage(
                          Assets.svg.circleEdit,
                          height: 24.h,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              CustomTextFailed(
                controller: _event.fullName,
                keyboardType: TextInputType.name,
                hint: LocaleKeys.user_name.tr(),
              ),
              SizedBox(height: 14.h),
              CustomTextFailed(
                controller: _event.mobile,
                keyboardType: TextInputType.phone,
                hint: LocaleKeys.Mobile_number.tr(),
              ),
              SizedBox(height: 14.h),
              CustomTextFailed(
                controller: _event.email,
                keyboardType: TextInputType.emailAddress,
                hint: LocaleKeys.Email.tr(),
              ),
              SizedBox(height: 14.h),
              SizedBox(height: 46.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleKeys.password.tr(),
                    style: context.textTheme.headline4!.copyWith(color: context.color.secondary),
                  ),
                  IconButton(
                    onPressed: () => push(const EditPasswordView()),
                    icon: CustomImage(
                      Assets.svg.edit,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 45.h),
              BlocConsumer(
                bloc: _bloc,
                listener: (context, state) {
                  if (state is DoneUpdateProfileState) {
                    Phoenix.rebirth(context);
                    FlashHelper.successBar(message: state.msg);
                  } else if (state is FaildUpdateProfileState) {
                    FlashHelper.errorBar(message: state.msg);
                  }
                },
                builder: (context, snapshot) {
                  return Btn(
                    loading: snapshot is LoadingUpdateProfileState,
                    text: LocaleKeys.Save.tr(),
                    onTap: () {
                      if (_fKey.currentState!.validate()) _bloc.add(_event);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
