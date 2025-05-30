import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../base/base_controller.dart';
import '../about/widget.dart';
import '../lock/widget.dart';
import '../shortcut/widget.dart';

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