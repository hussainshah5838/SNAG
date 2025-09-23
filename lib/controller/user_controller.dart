import 'package:get/get.dart';

enum UserRole { user, merchant }

class ChooseUserController extends GetxController {
  static final ChooseUserController instance = Get.find<ChooseUserController>();
  final Rx<UserRole> selectedRole = UserRole.user.obs;

  void selectRole(UserRole role) {
    selectedRole.value = role;
  }

  UserRole get currentRole => selectedRole.value;
}
