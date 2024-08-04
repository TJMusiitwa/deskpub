import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

class VerticalTitle extends StatelessWidget {
  final String title;
  final String value;

  const VerticalTitle({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            textAlign: TextAlign.center,
            style: MacosTheme.of(context).typography.headline.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: MacosTheme.brightnessOf(context) == Brightness.light
                      ? MacosColors.black
                      : MacosColors.white,
                ),
          ),
          Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
            style: MacosTheme.of(context)
                .typography
                .subheadline
                .copyWith(fontSize: 12.0, color: MacosColors.systemGrayColor),
          ),
        ],
      ),
    );
  }
}
