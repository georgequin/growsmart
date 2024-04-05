import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../state.dart';
import '../ui/common/app_colors.dart';
import '../ui/common/ui_helpers.dart';
import 'money_util.dart';


class PaymentModalWidget extends StatelessWidget {
  final Function(PaymentMethod) onPaymentMethodSelected;
  final VoidCallback onProceedWithPayment;
  final int totalAmount;
  final PaymentMethod selectedPaymentMethod;
  final bool isPaymentProcessing;

  const PaymentModalWidget({
    Key? key,
    required this.onPaymentMethodSelected,
    required this.onProceedWithPayment,
    required this.totalAmount,
    required this.selectedPaymentMethod,
    required this.isPaymentProcessing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define your modal UI here
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: kcSecondaryColor,
        borderRadius: BorderRadius.only(topRight: Radius.circular(25.0), topLeft: Radius.circular(25.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Your modal content goes here
          const Text(
            "Choose Payment Method",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: kcPrimaryColor,
              fontFamily: "Panchang",
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 0.0, // Space between the chips
            runSpacing: 2.0, // Space between the rows
            children: [
              _buildPaymentMethodOption(
                context,
                paymentMethodIcon: "binance_pay",
                method: PaymentMethod.binancePay,
                selectedMethod: selectedPaymentMethod,
                onTap: () =>
                    onPaymentMethodSelected(PaymentMethod.binancePay),
              ),
              _buildPaymentMethodOption(
                context,
                paymentMethodIcon: "flutter_wave",
                method: PaymentMethod.flutterWave,
                selectedMethod: selectedPaymentMethod,
                onTap: () =>
                    onPaymentMethodSelected(PaymentMethod.flutterWave),
              ),
            ],
          ),
          verticalSpaceMedium,
          const Divider(color: Colors.white54),
          _buildTotalSection(totalAmount),
          const SizedBox(height: 20),
          isPaymentProcessing ? const CircularProgressIndicator() :
          ElevatedButton(
          onPressed: onProceedWithPayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: kcPrimaryColor, // Button color
            minimumSize: const Size.fromHeight(50), // Button height
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/pay.svg',
                height: 20, // Icon size
              ),
              horizontalSpaceSmall,
              Text(
                "Pay   \$${totalAmount.toStringAsFixed(2)}", // Adjust text format as needed
                style: const TextStyle(fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Panchang"
                ),
              ),
            ],
          )


      )
        ],
      ),
    );
  }


  Widget _buildPaymentMethodOption(
      BuildContext context, {
        required String paymentMethodIcon,
        required PaymentMethod method,
        required PaymentMethod selectedMethod,
        required VoidCallback onTap,
      }) {
    bool isSelected = selectedMethod == method;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? kcPrimaryColor : Colors.transparent,
            width: 5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: SvgPicture.asset(
          'assets/icons/$paymentMethodIcon.svg',
          height: 44,
        ),
      ),
    );
  }

  Widget _buildTotalSection(int totalAmount) {
    return Column(
      children: [
        // _buildTotalLineItem(
        //   label: "Fees",
        //   amount: "\$0.5 ~ N750", // Replace with the actual fees
        // ),
        // _buildTotalLineItem(
        //   label: "Subtotal",
        //   amount: "\$50 ~ N75,000", // Replace with the actual subtotal
        // ),
        _buildTotalLineItem(
          label: "Total Amount",
          amount: MoneyUtils().formatAmountToDollars(totalAmount), //
        ),
      ],
    );
  }

  Widget _buildTotalLineItem({required String label, required String amount}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          Text(
            amount,
            style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
