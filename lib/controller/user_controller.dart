import 'package:get/get.dart';

enum UserRole { user, merchant }

class UserController extends GetxController {
  static final UserController instance = Get.find<UserController>();
  final Rx<UserRole> role = UserRole.user.obs;

  void selectRole(UserRole role) {
    this.role.value = role;
  }

  UserRole get currentRole => role.value;
}
