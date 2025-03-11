import 'package:flutter/cupertino.dart' hide OverlayVisibilityMode;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:macos_ui/src/layout/toolbar/toolbar.dart';
import 'package:swift_link/embedded/base/macos_base_widget.dart';
import 'package:swift_link/embedded/pages/lock/controller.dart';
import 'package:swift_link/embedded/pages/lock/item.dart';
import 'package:lottie/lottie.dart';

class LockPage extends MacosBaseWidget<LockController> {
  LockPage({super.key});

  @override
  Widget buildContent(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double maxWidth = constraints.maxWidth;
          double maxHeight = constraints.maxHeight;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               SizedBox(
                 height: 120.h,
                 child: topWidget(context),
               ),
              const SizedBox(height: 10),
              bottomWidget(maxWidth,maxHeight - 120.h - 10)
            ],
          );
        });
  }

  Widget topWidget(BuildContext context) {
     return Row(
       mainAxisAlignment: MainAxisAlignment.center,
       crossAxisAlignment: CrossAxisAlignment.center,
       children: [
         Icon(Icons.computer,size: 120.h,color: Theme.of(context).textTheme.bodyLarge?.color),
         SizedBox(width: 120,child: Center(child: Lottie.asset('assets/jsons/Animation1.json'))),
         Icon(Icons.phone_iphone,size: 120.h,color: Theme.of(context).textTheme.bodyLarge?.color)
       ],
     );
  }

  Widget bottomWidget(double maxWidth,double height) {
    int crossAxisCount = maxWidth ~/ 150;
   return Container(
       height: height,
       child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
     crossAxisCount: crossAxisCount, // 每行显示的列数
   ),
       itemCount: controller.items.length,
       itemBuilder: (BuildContext context,int index){
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
