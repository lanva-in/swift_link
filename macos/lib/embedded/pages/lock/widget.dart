import 'package:flutter/cupertino.dart' hide OverlayVisibilityMode;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:macos_ui/src/layout/toolbar/toolbar.dart';
import 'package:lottie/lottie.dart';
import '../../base/macos_base_widget.dart';
import 'controller.dart';
import 'item.dart';

class LockPage extends MacosBaseWidget<LockController> {
  LockPage({super.key});

  @override
  Widget buildContent(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      double maxWidth = constraints.maxWidth;
      double maxHeight = constraints.maxHeight;
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 160.h,
            child: Obx(() => topWidget(context)),
          ),
          const SizedBox(height: 10),
          bottomWidget(maxWidth, maxHeight - 160.h - 10)
        ],
      );
    });
  }

  Widget topWidget(BuildContext context) {
    if (controller.isShow.value) {
      return _searchDeviceIng(context);
    }else {
      return _noDeviceConnected(context);
    }
  }

  /// 没有绑定设备的时候
  Widget _noDeviceConnected(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Center(
                child: Container(
                    width: 120.h,
                    height: 120.h,
                    child: Image.asset(
                      'assets/images/macbook_pro.png',
                      fit: BoxFit.contain,
                        color: Theme.of(context).textTheme.bodyLarge?.color
                    ))),
            Center(child: Icon(Icons.link_off, size: 30.h, color: Theme.of(context).textTheme.bodyLarge?.color)),
          ],
        ),
        SizedBox(height: 5.h),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.w),
              ),
            ),
            onPressed: () {
              controller.startScan();
            },
            child: Container(
              width: 200.w,
              padding: EdgeInsets.all(5.h),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '绑定设备',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            )),
      ],
    );
  }

  /// 搜索设备中...
  Widget _searchDeviceIng(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Center(
                    child: Container(
                        width: 120.h,
                        height: 120.h,
                        child: Image.asset(
                          'assets/images/macbook_pro.png',
                          fit: BoxFit.contain,
                          color: Theme.of(context).textTheme.bodyLarge?.color
                        ))),
                Center(
                  child: SizedBox(
                      width: 50.h, height: 50.h, child: Center(child: Lottie.asset('assets/jsons/Animation2.json'))),
                )
              ],
            ),
            SizedBox(width: 40.w),
            Obx(() => AnimatedOpacity(
                opacity: controller.visible.value ? 1.0 : 0.0,
                duration: const Duration(seconds: 1),
                child: SizedBox(
                    width: 40.h,
                    height: 80.h,
                    child: Image.asset(
                      'assets/images/iphone_x.png',
                      fit: BoxFit.contain,
                      color: Theme.of(context).textTheme.bodyLarge?.color
                    )))),
          ],
        ),
        SizedBox(height: 5.h),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.w),
              ),
            ),
            onPressed: () {},
            child: Container(
              width: 200.w,
              padding: EdgeInsets.all(5.h),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '解除绑定',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            )),
      ],
    );
  }

  /// 绑定设备已连接
  Widget _didconnected(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: 120.h,
                height: 120.h,
                child: Image.asset(
                  'assets/images/macbook_pro.png',
                  fit: BoxFit.contain,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                )),
            SizedBox(width: 5.w),
            SizedBox(width: 120, child: Center(child: Lottie.asset('assets/jsons/Animation1.json'))),
            SizedBox(width: 5.w),
            SizedBox(
                width: 40.h,
                height: 80.h,
                child: Image.asset(
                  'assets/images/iphone_x.png',
                  fit: BoxFit.contain,
                  color: Theme.of(context).textTheme.bodyLarge?.color
                )),
          ],
        ),
        SizedBox(height: 5.h),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.w),
              ),
            ),
            onPressed: () {},
            child: Container(
              width: 200.w,
              padding: EdgeInsets.all(5.h),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '解除绑定',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget bottomWidget(double maxWidth, double height) {
    int crossAxisCount = maxWidth ~/ 150;
    if (crossAxisCount > 5) {
      crossAxisCount = 5;
    }
    return Container(
        height: height,
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount, // 每行显示的列数
            ),
            itemCount: controller.items.length,
            itemBuilder: (BuildContext context, int index) {
              final item = controller.items[index];
              final iconName = (item['icon'] ?? '') as String;
              final title = (item['title'] ?? '') as String;
              final value = (item['value'] ?? 0) as int;
              return LockItem(iconName: iconName, title: title, value: value);
            }));
  }

  @override
  List<ToolbarItem> toolbarItems(BuildContext context) {
    return [];
  }
}
