import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'package:kiwi/kiwi.dart';
import 'package:saudimarchclient/common/btn.dart';
import 'package:saudimarchclient/common/custom_text_failed.dart';
import 'package:saudimarchclient/generated/locale_keys.g.dart';
import 'package:saudimarchclient/helper/extintions.dart';
import 'package:saudimarchclient/helper/flash_helper.dart';
import 'package:saudimarchclient/models/pay_types_model.dart';
import 'package:saudimarchclient/view/common_cards/address_cart.dart';
import 'package:saudimarchclient/view/create_order/success.dart';
import 'package:saudimarchclient/view/user_address/bloc/bloc.dart';
import 'package:saudimarchclient/view/user_address/bloc/events.dart';
import 'package:saudimarchclient/view/user_address/bloc/states.dart';
import 'package:saudimarchclient/view/user_address/view/add_addres.dart';
import '../../common/alert.dart';
import '../../gen_bloc/shipping_types/bloc.dart';
import '../../gen_bloc/shipping_types/events.dart';
import '../../gen_bloc/shipping_types/states.dart';
import '../../helper/rout.dart';
import '../../models/shipping_model.dart';
import 'bloc/bloc.dart';
import 'bloc/event.dart';
import 'bloc/state.dart';

class CreateOrderView extends StatefulWidget {
  const CreateOrderView({Key? key}) : super(key: key);

  @override
  State<CreateOrderView> createState() => _CreateOrderViewState();
}

class _CreateOrderViewState extends State<CreateOrderView> {
  final _addressBloc = KiwiContainer().resolve<UserAddresBloc>();
  final _shippingBloc = KiwiContainer().resolve<ShippingBloc>();
  final _createOrderBloc = KiwiContainer().resolve<CreateOrderBloc>();
  ShippingModel shippingData = ShippingModel.fromJson({});
  final StartCreateOrderEvent _event = StartCreateOrderEvent();
  List<PayTypeModel> payTypes = [
    PayTypeModel(id: 0, name: LocaleKeys.cash.tr(), key: "cash"),
    PayTypeModel(id: 1, name: LocaleKeys.credit.tr(), key: "credit"),
    PayTypeModel(id: 2, name: LocaleKeys.wallet.tr(), key: "wallet"),
  ];

  PayTypeModel payTypeData = PayTypeModel.fromJson(({}));
  @override
  void initState() {
    _addressBloc.add(StartGetAddressesEvent());

    super.initState();
  }

  @override
  void dispose() {
    _addressBloc.close();
    _shippingBloc.close();
    _createOrderBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: "#FBF9F4".toColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: "#FBF9F4".toColor,
        title: Text(
          LocaleKeys.confirm_order.tr(),
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
          key: _event.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.client_info.tr(),
                style: context.textTheme.headline4!.copyWith(fontSize: 27),
              ),
              CustomTextFailed(
                controller: _event.clientName,
                keyboardType: TextInputType.name,
                hint: LocaleKeys.client_name.tr(),
              ),
              SizedBox(height: 14.h),
              CustomTextFailed(
                controller: _event.phone,
                keyboardType: TextInputType.phone,
                hint: LocaleKeys.Mobile_number.tr(),
              ),
              SizedBox(height: 14.h),
              CustomTextFailed(
                controller: TextEditingController(text: payTypeData.name),
                onTap: () {
                  CustomAlert.selectOptionalSeetButton(
                    title: LocaleKeys.pay_type.tr(),
                    items: payTypes,
                    onSubmit: (v) {
                      setState(() {
                        payTypeData = v;
                        _event.payType = payTypeData.key;
                      });
                    },
                    item: payTypeData,
                  );
                },
                keyboardType: TextInputType.name,
                hint: LocaleKeys.pay_type.tr(),
                endIcon: Icon(Icons.arrow_forward_ios, color: context.color.secondary, size: 15.px),
              ),
              SizedBox(height: 14.h),
              BlocConsumer(
                bloc: _shippingBloc,
                listener: (context, shippingState) {
                  if (shippingState is DoneShippingState) {
                    CustomAlert.selectOptionalSeetButton(
                      title: LocaleKeys.delivery_type.tr(),
                      items: shippingState.shipping,
                      onSubmit: (v) {
                        setState(() {
                          shippingData = v;
                          _event.shippingId = shippingData.id;
                        });
                      },
                      item: shippingData,
                    );
                  }
                },
                builder: (context, shippingState) {
                  return CustomTextFailed(
                    controller: TextEditingController(text: shippingData.name),
                    keyboardType: TextInputType.name,
                    onTap: () {
                      if (shippingState is! LoadingShippingState) {
                        _shippingBloc.add(StartShippingEvent());
                      }
                    },
                    hint: LocaleKeys.delivery_type.tr(),
                    endIcon: shippingState is LoadingShippingState
                        ? SizedBox(
                            width: 5,
                            height: 5,
                            child: CircularProgressIndicator.adaptive(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(context.color.secondary),
                            ).paddingAll(15.px),
                          )
                        : Icon(Icons.arrow_forward_ios, color: context.color.secondary, size: 15.px),
                  );
                },
              ),
              SizedBox(height: 29.h),
              Text(LocaleKeys.stored_address.tr(), style: context.textTheme.headline4!.copyWith(fontSize: 27)),
              BlocConsumer(
                bloc: _addressBloc,
                listener: (context, state) {
                  if (state is DoneGetAddresState) {
                    for (var element in state.data) {
                      if (element.isDefault) {
                        _event.addressId = element.id;
                      }
                    }
                  }
                },
                builder: (context, state) {
                  if (state is DoneGetAddresState) {
                    return Column(
                      children: List.generate(
                        state.data.length,
                        (i) => SizedBox(
                          child: AddressWidget(
                            data: state.data[i],
                            update: () {
                              for (var e in state.data) {
                                e.isDefault = e.id == state.data[i].id;
                              }
                              setState(() {
                                _event.addressId = state.data[i].id;
                              });
                            },
                          ),
                        ),
                      )..add(
                          SizedBox(
                            child: InkWell(
                                onTap: () {
                                  push(const AddAddressView()).then((value) {
                                    setState(() {
                                      state.data.add(value);
                                    });
                                  });
                                },
                                child: Text(LocaleKeys.add_address.tr() + ' + ', style: context.textTheme.headlineMedium).paddingAll(10.h)),
                          ),
                        ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              SizedBox(height: 30.h),
              BlocConsumer(
                bloc: _createOrderBloc,
                listener: (context, state) {
                  if (state is FaildCreateOrderState) {
                    FlashHelper.errorBar(message: state.msg);
                  } else if (state is DoneCreateOrderState) {
                    pushAndRemoveUntil(OrderSuccessView(id: state.orderId));
                  }
                },
                builder: (context, state) {
                  return Btn(
                    text: LocaleKeys.pay.tr(),
                    loading: state is LoadingCreateOrderState,
                    onTap: () {
                      if (_event.formKey.currentState!.validate()) {
                        _createOrderBloc.add(_event);
                      }
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
