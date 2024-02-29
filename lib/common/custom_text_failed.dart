import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../generated/locale_keys.g.dart';
import '../helper/extintions.dart';

class CustomTextFailed extends StatelessWidget {
  final String hint;
  final String? label;
  final Widget? endIcon;
  final void Function()? onTap;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  const CustomTextFailed({
    Key? key,
    required this.hint,
    this.label,
    this.keyboardType = TextInputType.name,
    this.controller,
    this.validator,
    this.endIcon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: TextFormField(
        enabled: onTap == null,
        controller: controller,
        keyboardType: keyboardType,
        validator: validator ??
            (v) {
              return v != null && v.isEmpty ? "$hint ${LocaleKeys.requerd.tr()}" : null;
            },
        obscureText: keyboardType == TextInputType.visiblePassword,
        style: context.textTheme.subtitle2?.copyWith(color: context.color.secondary, fontSize: 16),
        decoration: InputDecoration(
          errorStyle: context.textTheme.subtitle2!.copyWith(color: Colors.red, fontSize: 12),
          suffixIcon: endIcon,
          hintText: hint,
          hintStyle: context.textTheme.subtitle2?.copyWith(fontSize: 16),
          label: Text(label ?? hint, style: context.textTheme.subtitle2),
        ),
      ),
    );
  }
}

class FilterTextFailed extends StatelessWidget {
  final String hint;
  final String? label;
  final Widget? endIcon;
  final void Function()? onTap;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  const FilterTextFailed({
    Key? key,
    required this.hint,
    this.label,
    this.keyboardType = TextInputType.name,
    this.controller,
    this.validator,
    this.endIcon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: TextFormField(
        enabled: onTap == null,
        controller: controller,
        keyboardType: keyboardType,
        validator: validator ??
            (v) {
              return v != null && v.isEmpty ? "$hint ${LocaleKeys.requerd.tr()}" : null;
            },
        obscureText: keyboardType == TextInputType.visiblePassword,
        style: context.textTheme.subtitle2?.copyWith(color: context.color.secondary, fontSize: 16),
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          
          errorStyle: context.textTheme.subtitle2!.copyWith(color: Colors.red, fontSize: 12),
          suffixIcon: endIcon,
          hintText: hint,
          hintStyle: context.textTheme.subtitle2?.copyWith(fontSize: 16),
          label: Text(label ?? hint, style: context.textTheme.subtitle2),
        ),
      ),
    );
  }
}
