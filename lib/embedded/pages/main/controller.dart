import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swift_link/embedded/base/base_controller.dart';
import 'package:swift_link/embedded/pages/about/widget.dart';
import 'package:swift_link/embedded/pages/lock/widget.dart';
import 'package:swift_link/embedded/pages/shortcut/widget.dart';

class MainController extends BaseController {
  RxInt pageIndex = 0.obs;

  RxBool isShowAbout = false.obs;


  List<Widget> allPages = [
    LockPage(),
    ShortcutPage(),
    AboutPage(),
  ];

  final GlobalKey sidebarKey = GlobalKey();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}