import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimarchclient/common/btn.dart';
import 'package:saudimarchclient/common/custom_text_failed.dart';
import 'package:saudimarchclient/common/stare_bar.dart';
import 'package:saudimarchclient/generated/locale_keys.g.dart';
import 'package:saudimarchclient/helper/extintions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:saudimarchclient/helper/flash_helper.dart';

import 'bloc/bloc.dart';
import 'bloc/events.dart';
import 'bloc/states.dart';

class CreateRate extends StatefulWidget {
  final int id;
  const CreateRate({Key? key, required this.id}) : super(key: key);

  @override
  State<CreateRate> createState() => _CreateRateState();
}

class _CreateRateState extends State<CreateRate> {
  AddRatingBloc ratingBloc = KiwiContainer().resolve<AddRatingBloc>();
  num ratingValue = 3;
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController controller = TextEditingController(text: '');
  @override
  void dispose() {
    ratingBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: "#FBF9F4".toColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: "#FBF9F4".toColor,
        elevation: 0,
        title: Text(LocaleKeys.add_comment.tr(), style: context.textTheme.headline2),
      ),
      body: SingleChildScrollView(
          child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 200.h),
            CustomStarBar(
              size: 60.px,
              rate: ratingValue,
              onRated: (v) {
                ratingValue = v;
              },
            ).onCenter,
            SizedBox(height: 40.h),
            CustomTextFailed(
              hint: LocaleKeys.write_here.tr(),
              validator: (v) {
                return v != null && v.isEmpty ? "${LocaleKeys.rate.tr()} ${LocaleKeys.requerd.tr()}" : null;
              },
              controller: controller,
            ).paddingOnly(left: 50.w, right: 50.w),
            SizedBox(height: 50.h),
            BlocConsumer(
              bloc: ratingBloc,
              listener: (context, state) {
                if (state is FaildAddRatingState) {
                  FlashHelper.errorBar(message: state.msg);
                } else if (state is DoneAddRatingState) {
                  Navigator.pop(context, [state.model.data.ratingValue, state.model.data.reviews]);
                }
              },
              builder: (context, state) {
                return Btn(
                  loading: state is LoadingAddRatingState,
                  text: LocaleKeys.send.tr(),
                  onTap: () {
                    if (state is! LoadingAddRatingState) {
                      if (formKey.currentState!.validate()) {
                        ratingBloc.add(StartAddRatingEvent(id: widget.id, ratingValue: ratingValue.toInt(), comment: controller.text));
                      }
                    }
                  },
                );
              },
            ).paddingOnly(left: 50.w, right: 50.w)
          ],
        ),
      )),
    );
  }
}
