import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../gen/assets.gen.dart';

class LoadingBtn extends StatelessWidget {
  const LoadingBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(Assets.loattie.loadingBtn);
  }
}
