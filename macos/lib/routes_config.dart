import 'package:get/get.dart';
import './embedded/pages/about/controller.dart';
import './embedded/pages/lock/controller.dart';
import './embedded/pages/main/controller.dart';
import './embedded/pages/main/widget.dart';
import './embedded/pages/shortcut/controller.dart';

class RouteConstants {

  ///主页面
  static const main = "/app/main";

  ///锁页面
  static const lock = "/app/lock";

  ///快捷页面
  static const shortcut = "/app/shortcut";

}


class RouteConfig {

  static List<GetPage> routes() {
    return [
      GetPage(
          name: RouteConstants.main,
          page: () => MainPage(),
          maintainState: false,
          bindings: [
            BindingsBuilder(() {
              Get.lazyPut(() => MainController());
            }),
            BindingsBuilder(() {
              Get.lazyPut(() => LockController());
            }),
            BindingsBuilder(() {
              Get.lazyPut(() => ShortcutController());
            }),
            BindingsBuilder(() {
              Get.lazyPut(() => AboutController());
            }),
          ])
    ];
  }

}