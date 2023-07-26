import 'package:flutter/cupertino.dart';

class TapIcon extends StatelessWidget {
  Icon icon;
  void Function()? onTap;

  TapIcon({
    Key? key,
    required this.icon,
    required this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: icon,
    );
  }
}
