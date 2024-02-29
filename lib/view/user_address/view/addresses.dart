import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/size_extension.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimarchclient/common/btn.dart';
import 'package:saudimarchclient/helper/extintions.dart';
import 'package:saudimarchclient/helper/rout.dart';
import 'package:saudimarchclient/view/user_address/bloc/events.dart';

import '../../../gen/assets.gen.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../helper/asset_image.dart';
import '../../../helper/failed_widget.dart';
import '../../../helper/flash_helper.dart';
import '../../../helper/loading_app.dart';
import '../../common_cards/address_cart.dart';
import '../bloc/bloc.dart';
import '../bloc/states.dart';
import 'add_addres.dart';

class AddressesView extends StatefulWidget {
  const AddressesView({Key? key}) : super(key: key);

  @override
  State<AddressesView> createState() => _AddressesViewState();
}

class _AddressesViewState extends State<AddressesView> {
  final UserAddresBloc _bloc = KiwiContainer().resolve<UserAddresBloc>();
  @override
  void initState() {
    _bloc.add(StartGetAddressesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _bloc,
        builder: (context, state) {
          return Scaffold(
            backgroundColor: context.color.secondaryContainer,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: context.color.secondaryContainer,
              title: Text(
                LocaleKeys.addresses.tr(),
                style: context.textTheme.headline2,
                textAlign: TextAlign.center,
              ),
              centerTitle: true,
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Btn(
              text: LocaleKeys.add_new_title.tr(),
              onTap: () => push(const AddAddressView()).then((value) {
                if (value != null && state is DoneGetAddresState) {
                  setState(() {
                    state.data.add(value);
                  });
                }
              }),
            ).paddingSymmetric(vertical: 16.h, horizontal: 24.w),
            body: Builder(
              builder: (context) {
                if (state is LoadingUserAddresState) {
                  return const LoadingApp();
                } else if (state is FaildUserAddresState) {
                  return FailedWidget(
                    statusCode: state.statusCode,
                    errType: state.errType,
                    title: state.msg,
                    onTap: () => _bloc.add(StartGetAddressesEvent()),
                  );
                } else if (state is DoneGetAddresState) {
                  return state.data.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomImage(Assets.svg.location, height: 150.h, color: context.color.secondary.withOpacity(0.2)).onCenter,
                            // Text(
                            //   LocaleKeys.there_are_no_elements_in_the_favorite.tr(),
                            //   style: context.textTheme.subtitle1?.copyWith(color: context.color.secondary.withOpacity(0.4)),
                            // ).paddingSymmetric(vertical: 12.h)
                          ],
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 34.w, vertical: 16.h),
                          itemCount: state.data.length,
                          itemBuilder: (context, i) {
                            final _deleteBloc = KiwiContainer().resolve<UserAddresBloc>();
                            return Slidable(
                              startActionPane: ActionPane(
                                dragDismissible: false,
                                // dismissible: DismissiblePane(onDismissed: () {}),
                                extentRatio: .25,
                                motion: const ScrollMotion(),
                                children: [
                                  InkWell(
                                    onTap: () {
                                      _deleteBloc.add(StartDeleteEvent(state.data[i].id));
                                    },
                                    child: Container(
                                      constraints: BoxConstraints(minWidth: 70.w),
                                      decoration: BoxDecoration(
                                        color: context.color.primary,
                                        borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(20.w), bottomEnd: Radius.circular(20.w)),
                                      ),
                                      child: BlocConsumer(
                                        bloc: _deleteBloc,
                                        listener: (context, deleteState) {
                                          if (deleteState is DoneDeleteState) {
                                            FlashHelper.successBar(message: deleteState.msg);
                                            setState(() {
                                              state.data.removeAt(i);
                                              Slidable.of(context)?.close();
                                            });
                                          } else if (deleteState is FaildUserAddresState) {
                                            FlashHelper.errorBar(message: deleteState.msg);
                                          }
                                        },
                                        builder: (context, snapshot) {
                                          if (snapshot is LoadingUserAddresState) {
                                            return CustomProgress(size: 20.px, color: context.color.secondary).onCenter;
                                          }
                                          return const Center(
                                            child: Icon(CupertinoIcons.delete, color: Colors.red),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              child: AddressWidget(
                                data: state.data[i],
                                update: () {
                                  for (var element in state.data) {
                                    if (state.data[i].id == element.id) {
                                      element.isDefault = true;
                                    } else {
                                      element.isDefault = false;
                                    }
                                  }
                                  setState(() {});
                                },
                              ),
                            );
                          },
                        );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          );
        });
  }
}
