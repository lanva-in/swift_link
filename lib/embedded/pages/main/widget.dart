import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:flutter/material.dart';
import 'package:swift_link/embedded/base/macos_base_window_widget.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:macos_ui/src/layout/sidebar/sidebar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:swift_link/embedded/pages/main/controller.dart';

class MainPage extends MacosBaseWindowWidget<MainController> {
  MainPage({super.key});

  @override
  Widget buildContent(BuildContext context) {
    return Obx(() =>
        IndexedStack(
          index: controller.isShowAbout.value ? 2 : controller.pageIndex.value,
          children: controller.allPages,
        ));
  }

  @override
  Sidebar? buildEndSidebar(BuildContext context) {
    return Sidebar(
      startWidth: 300,
      minWidth: 300,
      topOffset: 0,
      shownByDefault: false,
      builder: (context, _) {
        return MacosScaffold(
          toolBar: ToolBar(
            title: const Text('日志'),
            actions: [
              ToolBarIconButton(
                label: '',
                tooltipMessage: '删除日志',
                icon: const MacosIcon(
                  CupertinoIcons.delete,
                ),
                onPressed: () {
                  print('删除日志');
                },
                showLabel: false,
              ),
            ],
          ),
          children: [
            ContentArea(
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Container(),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Sidebar? buildSidebar(BuildContext context) {
    return Sidebar(
      key: controller.sidebarKey,
      top: GestureDetector(
        onTap: () {
          // setState(() => showDevice = true);
        },
        child: Container(
        ),
      ),
      minWidth: 220,
      builder: (context, scrollController) {
        return Obx(() =>
            SidebarItems(
              currentIndex: controller.pageIndex.value,
              onChanged: (i) {
                controller.isShowAbout.value = false;
                controller.pageIndex.value = i;
              },
              scrollController: scrollController,
              itemSize: SidebarItemSize.large,
              unselectedColor: Colors.transparent,
              items: const [
                SidebarItem(
                  leading: MacosIcon(Icons.lock),
                  label: Text('锁屏控制'),
                ),
                SidebarItem(
                  leading: MacosIcon(Icons.app_shortcut),
                  label: Text('快捷控制'),
                ),
              ],
            ));
      },
      bottom: MacosListTile(
        leading: const MacosIcon(CupertinoIcons.profile_circled),
        title: Text(
            'Sam',
            style: TextStyle(
                color: Colors.blue)),
        onClick: () {
          controller.isShowAbout.value = true;
        },
      ),
    );
  }
}