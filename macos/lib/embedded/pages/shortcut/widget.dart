import 'package:flutter/cupertino.dart' hide OverlayVisibilityMode;
import 'package:flutter/material.dart';
import 'package:macos_ui/src/layout/toolbar/toolbar.dart';
import '../../base/macos_base_widget.dart';
import 'controller.dart';
class ShortcutPage extends MacosBaseWidget<ShortcutController> {
  ShortcutPage({super.key});

  @override
  Widget buildContent(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double maxWidth = constraints.maxWidth;
          double maxHeight = constraints.maxHeight;
          return Container(

          );
        });
  }

  @override
  List<ToolbarItem> toolbarItems(BuildContext context) {
    return [];
  }
}
