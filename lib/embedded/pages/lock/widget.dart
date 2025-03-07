import 'package:flutter/cupertino.dart' hide OverlayVisibilityMode;
import 'package:flutter/material.dart';
import 'package:macos_ui/src/layout/toolbar/toolbar.dart';
import 'package:swift_link/embedded/base/macos_base_widget.dart';
import 'package:swift_link/embedded/pages/lock/controller.dart';
import 'package:swift_link/embedded/pages/lock/item.dart';
class LockPage extends MacosBaseWidget<LockController> {
  LockPage({super.key});

  @override
  Widget buildContent(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double maxWidth = constraints.maxWidth;
          int crossAxisCount = maxWidth ~/ 120;
          return GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount, // 每行显示的列数
          ),
              itemCount: controller.items.length,
              itemBuilder: (BuildContext context,int index){
              final item = controller.items[index];
              final iconName = (item['icon'] ?? '') as String;
              final title = (item['title'] ?? '') as String;
              final value = (item['value'] ?? 0) as int;
              return LockItem(iconName: iconName, title: title, value: value);
          });
        });
  }

  @override
  List<ToolbarItem> toolbarItems(BuildContext context) {
    return [];
  }
}
