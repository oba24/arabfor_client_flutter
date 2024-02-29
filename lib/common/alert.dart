import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaling/flutter_screen_scaling.dart';
import 'btn.dart';
import '../gen/assets.gen.dart';
import '../helper/asset_image.dart';
import '../helper/extintions.dart';

import '../generated/locale_keys.g.dart';
import '../helper/rout.dart';

class CustomAlert {
  static Future succAlert(String title, Widget btnWidget) async {
    // bool _finish = false;
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30.px))),
      isScrollControlled: true,
      context: navigator.currentContext!,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(70))),
              // padding: EdgeInsets.all(10),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 54.h),
                  CustomImage(
                    Assets.svg.sucss,
                    height: 124.h,
                    width: 124.h,
                  ),
                  SizedBox(height: 43.h),
                  AnimatedOpacity(
                    duration: const Duration(seconds: 1),
                    opacity: 1,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 50.w),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: context.textTheme.headline4,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 42.h),
                          btnWidget,
                          SizedBox(height: 42.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static selectOptionalSeetButton({
    required String title,
    required List items,
    dynamic item,
    required Function(dynamic item) onSubmit,
    bool multi = false,
    List<Widget>? trailing,
  }) {
    dynamic _item = item;
    return showModalBottomSheet(
      isDismissible: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(50.px), topRight: Radius.circular(50.px))),
      context: navigator.currentContext!,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 16),
                  Container(
                    height: 50,
                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
                    alignment: Alignment.center,
                    child: Text(title, style: context.textTheme.headline1!.copyWith(fontSize: 16), textAlign: TextAlign.center),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    flex: items.length < 5 ? 0 : 1,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
                          child: ListTile(
                            title: Row(
                              children: [
                                Radio(
                                  value: true,
                                  groupValue: multi ? _item.any((e) => e.id == items[index].id) : _item.id == items[index].id,
                                  activeColor: context.color.secondary,
                                  onChanged: (v) {
                                    if (multi) {
                                      if (_item.any((e) => e.id == items[index].id)) {
                                        _item.removeWhere((e) => e.id == items[index].id);
                                      } else {
                                        _item.add(items[index]);
                                      }
                                    } else {
                                      _item = items[index];
                                    }
                                    setState(() {});
                                  },
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  items[index].name ?? "",
                                  style: context.textTheme.bodyText1!.copyWith(
                                    fontSize: 16,
                                    color: (multi ? _item.any((e) => e.id == items[index].id) : _item.id == items[index].id)
                                        ? context.color.secondary
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            trailing: trailing == null ? null : trailing[index],
                            onTap: () {
                              if (multi) {
                                if (_item.any((e) => e.id == items[index].id)) {
                                  _item.removeWhere((e) => e.id == items[index].id);
                                } else {
                                  _item.add(items[index]);
                                }
                              } else {
                                _item = items[index];
                              }
                              setState(() {});
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.h,
                      vertical: 20.h,
                    ),
                    child: Btn(
                      onTap: () {
                        Navigator.pop(context, true);
                      },
                      text: LocaleKeys.Selecte.tr(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((value) => value == true ? onSubmit(_item) : onSubmit(item));
  }
}
