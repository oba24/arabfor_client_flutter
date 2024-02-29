import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimarchclient/helper/extintions.dart';
import 'package:saudimarchclient/helper/flash_helper.dart';
import 'package:saudimarchclient/helper/loading_app.dart';
import 'package:saudimarchclient/models/addres_model.dart';
import 'package:saudimarchclient/view/user_address/bloc/bloc.dart';
import 'package:saudimarchclient/view/user_address/bloc/events.dart';
import 'package:saudimarchclient/view/user_address/bloc/states.dart';

class AddressWidget extends StatefulWidget {
  final AddressDatum data;
  final Function update;

  const AddressWidget({
    Key? key,
    required this.data,
    required this.update,
  }) : super(key: key);

  @override
  State<AddressWidget> createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  final UserAddresBloc bloc = KiwiContainer().resolve<UserAddresBloc>();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => bloc.add(StartIsDefaultEvent(widget.data.id)),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: context.color.secondary.withOpacity(0.1)))),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.data.name, style: context.textTheme.headline4),
                  SizedBox(height: 10.h),
                  Text(widget.data.address, style: context.textTheme.bodyText1),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            Container(
              height: 30.h,
              width: 30.h,
              margin: EdgeInsetsDirectional.only(end: 8.h),
              padding: EdgeInsets.all(5.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: widget.data.isDefault ? context.color.secondary : context.color.primary,
              ),
              child: BlocConsumer(
                bloc: bloc,
                listener: (context, state) {
                  if (state is DoneIsDefaultState) {
                    FlashHelper.successBar(message: state.msg);
                    widget.update();
                  } else if (state is FaildUserAddresState) {
                    FlashHelper.errorBar(message: state.msg);
                  }
                },
                builder: (context, snapshot) {
                  if (snapshot is LoadingUserAddresState) {
                    return CustomProgress(size: 20.px, color: context.color.secondary);
                  } else if (widget.data.isDefault) {
                    return const Icon(Icons.check, color: Colors.white);
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
