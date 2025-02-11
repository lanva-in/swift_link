import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'config_model.dart';
import 'routes_config.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        builder: (context, child) => child!,
        minTextAdapt: true,
        designSize: const Size(800, 500),
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return MultiProvider(
                  providers: [
                    ChangeNotifierProvider(create: (_) => ConfigModel())
                  ],
                  child: Consumer<ConfigModel>(
                      builder: (context, snapshot, widget) {
                        return GetMaterialApp(
                          debugShowCheckedModeBanner: false,
                          navigatorObservers: [FlutterSmartDialog.observer],
                          getPages: RouteConfig.routes(),
                          initialRoute: RouteConstants.home,
                          defaultTransition: Transition.cupertino,
                          theme: ThemeData.light(),
                          darkTheme: ThemeData.dark(),
                          themeMode: snapshot.mode,
                          builder: FlutterSmartDialog.init(),
                        );
                      }));
            }
            return const SizedBox();
          },
          future: _initConfig(),
        ));
  }

  Future<bool> _initConfig() async {
    return Future(() => true);
  }

}