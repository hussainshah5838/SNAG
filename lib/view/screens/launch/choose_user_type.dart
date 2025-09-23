// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:snag/constants/app_colors.dart';
// import 'package:snag/constants/app_images.dart';
// import 'package:snag/constants/app_sizes.dart';
// import 'package:snag/controller/user_controller.dart';
// import 'package:snag/utils/global_instances.dart';
// import 'package:snag/view/screens/auth/login.dart';
// import 'package:snag/view/widget/my_button_widget.dart';
// import 'package:snag/view/widget/my_text_widget.dart';

// class ChooseUserType extends StatefulWidget {
//   const ChooseUserType({super.key});

//   @override
//   State<ChooseUserType> createState() => _ChooseUserTypeState();
// }

// class _ChooseUserTypeState extends State<ChooseUserType> {
//   @override
//   void initState() {
//     super.initState();
//     Future.delayed(Duration.zero, () {
//       Get.bottomSheet(
//         _LoginBottomSheet(),
//         barrierColor: Colors.transparent,
//         backgroundColor: Colors.transparent,
//         isScrollControlled: true,
//         isDismissible: false,
//         enableDrag: false,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(24),
//             topRight: Radius.circular(24),
//           ),
//         ),
//         clipBehavior: Clip.antiAlias,
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kSecondaryColor,
//       body: Container(
//         height: Get.height,
//         width: Get.width,
//         child: Column(
//           children: [
//             SizedBox(height: 100),
//             Center(child: Image.asset(Assets.imagesLogo, height: 100)),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _LoginBottomSheet extends StatefulWidget {
//   @override
//   State<_LoginBottomSheet> createState() => _LoginBottomSheetState();
// }

// class _LoginBottomSheetState extends State<_LoginBottomSheet> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(top: 60),
//       height: Get.height * 0.6,
//       decoration: BoxDecoration(
//         color: kPrimaryColor,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(24),
//           topRight: Radius.circular(24),
//         ),
//       ),
//       child: ListView(
//         shrinkWrap: true,
//         padding: AppSizes.DEFAULT,
//         physics: BouncingScrollPhysics(),
//         children: [
//           MyText(
//             text: 'Let’s snag you in',
//             paddingTop: 8,
//             size: 24,
//             weight: FontWeight.w600,
//             paddingBottom: 8,
//           ),
//           MyText(
//             text:
//                 'Choose your user type\nPlease select whether you are a Simple User or a Merchant to continue.',
//             size: 16,
//             lineHeight: 1.5,
//             weight: FontWeight.w500,
//             color: kQuaternaryColor,
//             paddingBottom: 30,
//           ),
//           Obx(
//             () => _UserTypeCard(
//               icon: Icons.person,
//               title: 'Simple User',
//               description: 'For personal use and basic features.',
//               onTap: () => chooseUserController.selectRole(UserRole.user),
//               isSelected:
//                   ChooseUserController.instance.currentRole == UserRole.user,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Obx(
//             () => _UserTypeCard(
//               icon: Icons.business_center,
//               title: 'Merchant',
//               description: 'For Merchant and advanced features.',
//               onTap: () => chooseUserController.selectRole(UserRole.merchant),
//               isSelected:
//                   ChooseUserController.instance.currentRole ==
//                   UserRole.merchant,
//             ),
//           ),
//           SizedBox(height: 40),
//           MyButton(
//             buttonText: 'Continue',
//             onTap: () {
//               Get.offAll(() => Login());
//             },
//           ),
//           SizedBox(height: 12),
//           Center(
//             child: Wrap(
//               children: [
//                 MyText(text: 'Already have an account? ', size: 16),
//                 MyText(
//                   onTap: () {
//                     Get.offAll(() => Login());
//                   },
//                   text: 'Log In',
//                   weight: FontWeight.w600,
//                   color: kQuaternaryColor,
//                   size: 16,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _UserTypeCard extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String description;
//   final VoidCallback onTap;
//   final bool isSelected;

//   const _UserTypeCard({
//     required this.icon,
//     required this.title,
//     required this.description,
//     required this.onTap,
//     required this.isSelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color:
//               isSelected ? kSecondaryColor.withValues(alpha: 0.1) : kFillColor,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: isSelected ? kSecondaryColor : kBorderColor,
//             width: 1.0,
//           ),
//         ),
//         padding: EdgeInsets.all(12),
//         child: Row(
//           children: [
//             Icon(icon, size: 28, color: kSecondaryColor),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   MyText(
//                     text: title,
//                     size: 14,
//                     weight: FontWeight.w600,
//                     paddingBottom: 4,
//                   ),
//                   MyText(
//                     text: description,
//                     size: 12,
//                     color: kQuaternaryColor,
//                     weight: FontWeight.w400,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
