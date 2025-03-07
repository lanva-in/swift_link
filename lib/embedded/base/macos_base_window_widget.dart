import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'base_controller.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:flutter/cupertino.dart' hide OverlayVisibilityMode;
import 'package:desktop_window/desktop_window.dart';

///组件基类
abstract class MacosBaseWindowWidget<T extends BaseController> extends StatefulWidget {

  T? _controller;

  T get controller {
    _controller ??= Get.find<T>();
    return _controller!;
  }

  MacosBaseWindowWidget({Key? key}) : super(key: key) {
    controller;
  }

  @override
  State<MacosBaseWindowWidget> createState() => _BaseWindowWidgetState<T>();

  Widget buildContent(BuildContext context);

  Sidebar? buildSidebar(BuildContext context);

  Sidebar? buildEndSidebar(BuildContext context);

  Widget buildPage(BuildContext context) {
    return buildWindow(context);
  }

  Widget buildWindow(BuildContext context) {
   return MacosApp(
      theme: MacosThemeData.light(),
      darkTheme: MacosThemeData.dark(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: MacosWindow(
        sidebar: buildSidebar(context),
        endSidebar: buildEndSidebar(context),
        child: buildContent(context),
      )
    );

  }
}

class _BaseWindowWidgetState<T extends BaseController> extends State<MacosBaseWindowWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(builder: (T controller){
      return widget.buildPage(context);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    DesktopWindow.setWindowSize(const Size(800,500));
    DesktopWindow.setMinWindowSize(const Size(800,500));
  }
}