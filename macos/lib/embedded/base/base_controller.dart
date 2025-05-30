import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

///业务处理基类
abstract class BaseController extends SuperController with FullLifeCycleMixin {

  @override
  void onDetached() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {}

  @override
  void onResumed() {}

  @override
  void onHidden() {}

  Future<T?>? toNamed<T>(
      String path, {
        dynamic arguments,
        int? id,
        bool preventDuplicates = true,
        Map<String, String>? parameters,
      }) {
    return Get.toNamed<T>(path,
        arguments: arguments,
        id: id,
        preventDuplicates: preventDuplicates,
        parameters: parameters);
  }

  void goBack<T>({T? result}) {
    Get.back(result: result);
  }

  void rightToolbar() {

  }

  void showLoadingDialog({String? message}) {
    SmartDialog.showLoading(
      msg: message ?? "",
      alignment: Alignment.center,
      clickMaskDismiss: false,
      animationType: SmartAnimationType.fade,
      useAnimation: true,
      backDismiss: true,
    );
  }

  void dismissLoadingDialog() {
    SmartDialog.dismiss(status: SmartStatus.loading);
  }

  void showToast(String msg) {
    SmartDialog.showToast(msg,alignment: Alignment.center);
  }

  @override
  void dispose() {
    super.dispose();
    dismissLoadingDialog();
  }
}