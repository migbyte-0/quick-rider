import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickrider/core/constants/constant_exports.dart';
import 'package:quickrider/core/shared/shared_exports.dart';
import 'package:quickrider/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:quickrider/features/auth/presentation/cubits/auth_state.dart';
import 'package:quickrider/l10n/app_localizations.dart';

class OtpForm extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const OtpForm({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
  });

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  String _enteredOtp = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(AppAssets.otpLogo),
        SizedBox(height: 40.h),
        Column(
          children: [
            Text(
              l10n.otpMessage,
              textAlign: TextAlign.center,
              style: AppTextStyles.textStyle18().copyWith(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              '${l10n.phoneNumber}: ${widget.phoneNumber}',
              textAlign: TextAlign.center,
              style: AppTextStyles.textStyle18().copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(height: 24.h),
            Center(
              child: OtpTextField(
                numberOfFields: 6,
                borderColor: AppColors.primary,
                focusedBorderColor: AppColors.primary,
                showFieldAsBox: true,
                fieldWidth: 40.w,
                styles: [
                  AppTextStyles.inputFieldText.copyWith(fontSize: 20.sp),
                  AppTextStyles.inputFieldText.copyWith(fontSize: 20.sp),
                  AppTextStyles.inputFieldText.copyWith(fontSize: 20.sp),
                  AppTextStyles.inputFieldText.copyWith(fontSize: 20.sp),
                  AppTextStyles.inputFieldText.copyWith(fontSize: 20.sp),
                  AppTextStyles.inputFieldText.copyWith(fontSize: 20.sp),
                ],
                onCodeChanged: (String code) {
                  _enteredOtp = code;
                },
                onSubmit: (String verificationCode) {
                  _enteredOtp = verificationCode;
                  context.read<AuthCubit>().verifyOtp(
                    widget.verificationId,
                    _enteredOtp.trim(),
                  );
                },
                keyboardType: TextInputType.number,
                enabledBorderColor: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(8.0.r),
                decoration: InputDecoration(
                  hintText: l10n.otpHintText,
                  hintStyle: AppTextStyles.textStyle14().copyWith(
                    color: Colors.grey,
                    fontSize: 14.sp,
                  ),
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  bool isLoading = state is AuthLoading && !state.isSendingOtp;
                  return CustomButton(
                    onPressed: () {
                      if (_enteredOtp.length == 6) {
                        context.read<AuthCubit>().verifyOtp(
                          widget.verificationId,
                          _enteredOtp.trim(),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              l10n.otp,
                              style: AppTextStyles.smallButton,
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    text: isLoading
                        ? l10n.verifyingMessage
                        : l10n.verifySignInButton,
                    isLoading: isLoading,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
