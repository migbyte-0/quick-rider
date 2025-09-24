import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickrider/core/constants/constant_exports.dart';
import 'package:quickrider/core/shared/shared_exports.dart';
import 'package:quickrider/l10n/app_localizations.dart';

import '../presentation_exports.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PaymentCubit>().loadPaymentMethods();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          l10n.paymentMethods,
          style: AppTextStyles.appBarTitle.copyWith(color: Colors.black),
        ),
      ),
      body: BlocConsumer<PaymentCubit, PaymentState>(
        listener: (context, state) {
          if (state is PaymentMethodsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AddCardSuccess) {
            context.read<PaymentCubit>().loadPaymentMethods();
          }
        },
        builder: (context, state) {
          if (state is PaymentMethodsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PaymentMethodsLoaded) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PaymentMethodTile(
                          icon: Icons.credit_card,
                          title: l10n.addCard,
                          isAddCard: true,
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<PaymentCubit>(),
                                  child: const AddPaymentScreen(),
                                ),
                              ),
                            );
                            context.read<PaymentCubit>().loadPaymentMethods();
                          },
                        ),
                        SizedBox(height: 16.h),
                        ...state.savedCards.map((card) {
                          return CreditCardTile(
                            card: card,
                            isSelected: state.selectedCard?.id == card.id &&
                                state.selectedPaymentMethodType ==
                                    PaymentMethodType.card,
                            onTap: () =>
                                context.read<PaymentCubit>().selectCard(card),
                            onSetDefault: () => context
                                .read<PaymentCubit>()
                                .setDefaultCard(card.id),
                            onDelete: () => context
                                .read<PaymentCubit>()
                                .removeCard(card.id),
                          );
                        }),
                        SizedBox(height: 16.h),
                        PaymentMethodTile(
                          icon: Icons.money,
                          title: l10n.cash,
                          isSelected: state.selectedPaymentMethodType ==
                              PaymentMethodType.cash,
                          onTap: () => context
                              .read<PaymentCubit>()
                              .selectPaymentMethodType(PaymentMethodType.cash),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: CustomButton(
                    text: l10n.confirm,
                    onPressed: () {
                      Navigator.of(context).pop(state.selectedCard ??
                          state.selectedPaymentMethodType);
                    },
                  ),
                ),
              ],
            );
          } else if (state is PaymentMethodsError) {
            return Center(
              child: Text(state.message),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
