import 'package:snag/constants/app_colors.dart';
import 'package:snag/constants/app_images.dart';
import 'package:snag/constants/app_sizes.dart';
import 'package:snag/view/screens/merchant/billing_payments/billing_details.dart';
import 'package:snag/view/widget/common_image_view_widget.dart';
import 'package:snag/view/widget/custom_app_bar_widget.dart';
import 'package:snag/view/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BillingPayments extends StatefulWidget {
  const BillingPayments({super.key});

  @override
  State<BillingPayments> createState() => _BillingPaymentsState();
}

class _BillingPaymentsState extends State<BillingPayments> {
  int? selectedLabelIndex = 0;
  @override
  Widget build(BuildContext context) {
    final List<String> labels = ["All", "Paid", "Pending", "Failed"];
    return Scaffold(
      appBar: simpleAppBar(
        actions: [
          Center(
            child: GestureDetector(
              onTap: () {},
              child: Image.asset(Assets.imagesDownload, height: 32),
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        padding: AppSizes.VERTICAL,
        physics: BouncingScrollPhysics(),
        children: [
          Padding(
            padding: AppSizes.HORIZONTAL,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MyText(
                  text: 'Billing Activity',
                  paddingTop: 8,
                  size: 24,
                  weight: FontWeight.w600,
                  paddingBottom: 8,
                ),
                MyText(
                  text:
                      'Monitor payouts, view earnings, and update payment details.',
                  size: 16,
                  lineHeight: 1.5,
                  weight: FontWeight.w500,
                  color: kQuaternaryColor,
                  paddingBottom: 30,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox(width: 12);
              },
              padding: AppSizes.HORIZONTAL,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: labels.length,
              itemBuilder: (context, index) {
                final isSelected = selectedLabelIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedLabelIndex = index;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? kSecondaryColor : kLightBlueColor,
                      border: Border.all(color: Color(0xff06A3FF)),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: MyText(
                        text: labels[index],
                        size: 14,
                        weight: FontWeight.w500,
                        color: isSelected ? kPrimaryColor : kSecondaryColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          ListView.builder(
            padding: AppSizes.HORIZONTAL,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: (context, i) {
              final List<Map<String, String>> users = [
                {
                  "amount": "\$250.00",
                  "status": "Pending",
                  "method": "PayPal — ali.khan@email.com",
                },
                {
                  "amount": "\$2000.00",
                  "status": "Paid",
                  "method": "Paytm — sam.jones@email.com",
                },
                {
                  "amount": "\$2000.00",
                  "status": "Pending",
                  "method": "Paytm — john.doe@email.com",
                },
                {
                  "amount": "\$2000.00",
                  "status": "Failed",
                  "method": "PayPal — ali.khan@email.com",
                },
                {
                  "amount": "\$2000.00",
                  "status": "Paid",
                  "method": "PayPal — ali.khan@email.com",
                },
                {
                  "amount": "\$190.00",
                  "status": "Paid",
                  "method": "Paytm — emily.smith@email.com",
                },
              ];
              return GestureDetector(
                onTap: () {
                  Get.to(() => BillingDetails());
                },
                child: _BillingTile(
                  amount: users[i]["amount"] ?? '',
                  status: users[i]["status"] ?? '',
                  method: users[i]["method"] ?? '',
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BillingTile extends StatelessWidget {
  const _BillingTile({
    required this.amount,
    required this.status,
    required this.method,
  });

  final String amount;
  final String status;
  final String method;

  Color _getStatusColor() {
    switch (status) {
      case 'Paid':
        return kGreenColor;
      case 'Pending':
        return kAmberColor;
      case 'Failed':
        return kRedColor;
      default:
        return kQuaternaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kFillColor,
        border: Border.all(color: kBorderColor, width: 1),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          CommonImageView(
            imagePath: Assets.imagesDollar,
            height: 36,
            width: 36,
            radius: 100,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  text: amount,
                  size: 15,
                  weight: FontWeight.w600,
                  paddingBottom: 4,
                ),
                MyText(text: method, size: 12, color: kQuaternaryColor),
              ],
            ),
          ),
          MyText(
            text: status,
            size: 12,
            color: _getStatusColor(),
            weight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
