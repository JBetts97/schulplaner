import 'package:flutter/material.dart';
import 'package:schulplaner8/Helper/helper_views.dart';

class IntroContent extends StatelessWidget {
  final String title;
  final String bodytext;
  final Widget body;
  final Widget footer;
  final TextStyle titleStyle;
  final TextStyle bodyStyle;

  const IntroContent(
      {Key key,
      @required this.title,
      this.bodytext,
      this.body,
      this.footer,
      this.titleStyle,
      this.bodyStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> footerWidgets = [];
    if (footer != null) {
      footerWidgets.addAll([const SizedBox(height: 20.0), footer]);
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: body == null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 20.0),
                Text(title, style: titleStyle, textAlign: TextAlign.center),
                bodytext == null ? nowidget() : const SizedBox(height: 20.0),
                bodytext == null
                    ? nowidget()
                    : Text(bodytext,
                        style: bodyStyle, textAlign: TextAlign.center),
              ]..addAll(footerWidgets),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 4.0),
                Text(title, style: titleStyle, textAlign: TextAlign.center),
                const SizedBox(height: 8.0),
                bodytext == null ? nowidget() : const SizedBox(height: 24.0),
                bodytext == null
                    ? nowidget()
                    : Text(bodytext,
                        style: bodyStyle, textAlign: TextAlign.center),
                bodytext == null ? nowidget() : const SizedBox(height: 24.0),
                body,
              ]..addAll(footerWidgets),
            ),
    );
  }
}
