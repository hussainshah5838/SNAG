import 'package:get/get.dart';
import '../constants/app_constants.dart';

/// UI-level role selection (the "choose your role" screen before login/signup).
/// Maps to UserRoles string constants when communicating with the backend.
enum UserRole { user, merchant }

class UserController extends GetxController {
  static final UserController instance = Get.find<UserController>();
  final Rx<UserRole> role = UserRole.user.obs;

  void selectRole(UserRole role) {
    this.role.value = role;
  }

  UserRole get currentRole => role.value;

  /// Converts the UI enum to the backend role string constant.
  /// Use this when passing role to any API call or service.
  String get roleString => currentRole == UserRole.merchant
      ? UserRoles.merchant
      : UserRoles.client;

  bool get isMerchant => currentRole == UserRole.merchant;
}
