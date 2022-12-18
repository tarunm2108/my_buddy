import 'package:flutter/material.dart';
import 'package:my_buddy/app_consts/app_colors.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: primaryColor,
      ),
    );
  }
}
