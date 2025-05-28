import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseProgressIndicator extends StatelessWidget {
  const BaseProgressIndicator({
    Key? key,
    this.size,
    this.color,
    this.strokeWidth,
  }) : super(key: key);

  final double? size;
  final Color? color;
  final double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size ?? 24.w,
        height: size ?? 24.h,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth ?? 3,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
