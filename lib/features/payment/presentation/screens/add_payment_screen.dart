import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickrider/core/constants/constant_exports.dart';
import 'package:quickrider/core/shared/shared_exports.dart';
import 'package:quickrider/features/payment/presentation/cubits/payment_cubit.dart';
import 'package:quickrider/features/payment/presentation/cubits/payment_state.dart';
import 'package:quickrider/l10n/app_localizations.dart';

import '../../domain/domain_exports.dart';

class AddPaymentScreen extends StatefulWidget {
  const AddPaymentScreen({super.key});

  @override
  State<AddPaymentScreen> createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void _onValidate() {
    if (formKey.currentState!.validate()) {
      final card = CreditCardEntity(
        id: '',
        cardNumber: cardNumber,
        expiryDate: expiryDate,
        cardHolderName: cardHolderName,
        cvvCode: cvvCode,
        bankName: 'Mock Bank',
        cardType: '',
        isDefault: false,
      );
      context.read<PaymentCubit>().saveNewCard(card);
    } else {
      context.read<PaymentCubit>().logger.w('Add card form is invalid!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          l10n.paymentMethods,
          style: AppTextStyles.appBarTitle.copyWith(color: Colors.black),
        ),
      ),
      body: BlocListener<PaymentCubit, PaymentState>(
        listener: (context, state) {
          if (state is AddCardSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Card added successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          } else if (state is AddCardFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.h),
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
                onCreditCardWidgetChange: (CreditCardBrand brand) {},
                cardBgColor: AppColors.primary,
                isHolderNameVisible: true,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      CreditCardForm(
                        formKey: formKey,
                        obscureCvv: true,
                        obscureNumber: true,
                        cardNumber: cardNumber,
                        cvvCode: cvvCode,
                        isHolderNameVisible: true,
                        isCardNumberVisible: true,
                        isExpiryDateVisible: true,
                        cardHolderName: cardHolderName,
                        expiryDate: expiryDate,
                        inputConfiguration: const InputConfiguration(
                          cardNumberDecoration: InputDecoration(
                            labelText: 'Card Number',
                            hintText: 'XXXX XXXX XXXX XXXX',
                          ),
                          expiryDateDecoration: InputDecoration(
                            labelText: 'Expired Date',
                            hintText: 'XX/XX',
                          ),
                          cvvCodeDecoration: InputDecoration(
                            labelText: 'CVV',
                            hintText: 'XXX',
                          ),
                          cardHolderDecoration: InputDecoration(
                            labelText: 'Card Holder',
                          ),
                        ),
                        onCreditCardModelChange: onCreditCardModelChange,
                      ),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: BlocBuilder<PaymentCubit, PaymentState>(
                          builder: (context, state) {
                            final isLoading = state is AddCardLoading;
                            return CustomButton(
                              text: isLoading
                                  ? l10n.verifyingMessage
                                  : l10n.confirm,
                              onPressed: isLoading ? null : _onValidate,
                              isLoading: isLoading,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
