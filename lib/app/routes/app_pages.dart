import 'package:coding_interview_frontend/app/controllers/home_controller.dart';
import 'package:coding_interview_frontend/app/ui/pages/home_page.dart';
import 'package:get/get.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomePage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => HomeController());
      }),
    ),
  ];
}