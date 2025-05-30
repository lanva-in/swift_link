import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'base_controller.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart' hide OverlayVisibilityMode;

///组件基类
abstract class MacosBaseWidget<T extends BaseController> extends StatefulWidget {

  T? _controller;

  T get controller {
    _controller ??= Get.find<T>();
    return _controller!;
  }

  String titleStr = "";

  MacosBaseWidget({Key? key,String? title}) : super(key: key) {
    controller;
    titleStr = title ?? "";
  }

  @override
  State<MacosBaseWidget> createState() => _BaseWidgetState<T>();

  Widget buildContent(BuildContext context);

  List<ToolbarItem> toolbarItems(BuildContext context);

  Widget buildPage(BuildContext context) {
    return buildScaffold(context);
  }

  MacosTheme buildScaffold(BuildContext context) {
    return MacosTheme(
      data: MacosThemeData.dark(),
      child: MacosScaffold(
        toolBar: ToolBar(
          title: Text(titleStr),
          titleWidth: 150.0,
          leading: MacosTooltip(
            message: '左边栏',
            useMousePosition: false,
            child: MacosIconButton(
              icon: MacosIcon(
                CupertinoIcons.sidebar_left,
                color: MacosTheme.brightnessOf(context).resolve(
                  const Color.fromRGBO(0, 0, 0, 0.5),
                  const Color.fromRGBO(255, 255, 255, 0.5),
                ),
                size: 20.0,
              ),
              boxConstraints: const BoxConstraints(
                minHeight: 20,
                minWidth: 20,
                maxWidth: 48,
                maxHeight: 38,
              ),
              onPressed: () => MacosWindowScope.of(context).toggleSidebar(),
            ),
          ),
          actions: toolbarItems(context),
        ),
        children: [
          ContentArea(
            builder: (context, scrollController) {
              return buildContent(context);
            },
          ),
        ],
      ),
    );
  }
}

class _BaseWidgetState<T extends BaseController> extends State<MacosBaseWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.buildPage(context);
  }
}