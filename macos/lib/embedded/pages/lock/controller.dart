import 'dart:async';

import '../../base/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class LockController extends BaseController {

  final items = [{'icon':'key.png','title':'接近锁定/解锁','value':0},{'icon':'ruler.png','title':'接近锁定/解锁距离','value':5},
    {'icon':'lock.png','title':'离开接近锁定\n半径时锁定Mac','value':0},{'icon':'unlock.png','title':'离开接近解锁\n半径时解锁Mac','value':0},
    {'icon':'shutdown.png','title':'Mac开机后\n自动开启','value':0},{'icon':'doubleClick.png','title':'双击锁定/解锁','value':0},
    {'icon':'fingerprint.png','title':'指纹扫脸\n锁定/解锁','value':0},{'icon':'shearPlate.png','title':'剪切板\nCTRL+CMD+V','value':0},
    {'icon':'sleep.png','title':'锁定项\n睡眠','value':0},{'icon':'screenSaver.png','title':'锁定项\n屏保','value':0}];
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