import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickrider/core/constants/constant_exports.dart';
import 'package:quickrider/core/shared/shared_exports.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:quickrider/core/shared/widgets/app_loading.dart';

import '../widgets/otp_form.dart';
import '../widgets/resend_otp_section.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  final int? resendToken;

  const OTPScreen({
    required this.phoneNumber,
    required this.verificationId,
    this.resendToken,
    super.key,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  late String _currentVerificationId;
  late int? _currentResendToken;

  @override
  void initState() {
    super.initState();
    _currentVerificationId = widget.verificationId;
    _currentResendToken = widget.resendToken;
  }

  // Callback to update verification ID and resend token from child widget
  void _updateVerificationDetails(
    String newVerificationId,
    int? newResendToken,
  ) {
    setState(() {
      _currentVerificationId = newVerificationId;
      _currentResendToken = newResendToken;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoggedInSuccess) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message, style: AppTextStyles.smallButton),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.9.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OtpForm(
                          phoneNumber: widget.phoneNumber,
                          verificationId: _currentVerificationId,
                        ),
                        SizedBox(height: 16.h),
                        ResendOtpSection(
                          phoneNumber: widget.phoneNumber,
                          onCodeResent: _updateVerificationDetails,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoading && !state.isSendingOtp) {
                    return Container(
                      color: Colors.black.withValues(alpha: 0.5),
                      child: const Center(child: AppLoading()),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
