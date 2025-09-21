import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickrider/core/constants/constant_exports.dart';
import 'package:quickrider/core/shared/widgets/app_loading.dart';
import 'package:quickrider/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:quickrider/l10n/app_localizations.dart';

import '../cubits/auth_state.dart';

class ResendOtpSection extends StatefulWidget {
  final String phoneNumber;
  final Function(String newVerificationId, int? newResendToken) onCodeResent;

  const ResendOtpSection({
    required this.phoneNumber,
    required this.onCodeResent,
    super.key,
  });

  @override
  State<ResendOtpSection> createState() => _ResendOtpSectionState();
}

class _ResendOtpSectionState extends State<ResendOtpSection> {
  Timer? _timer;
  final ValueNotifier<int> _secondsRemaining = ValueNotifier(60);
  bool _canResend = false;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer([int? initialSeconds]) {
    _timer?.cancel();
    _secondsRemaining.value = initialSeconds ?? 60;
    _canResend = false;
    _isResending = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining.value > 0) {
        _secondsRemaining.value--;
      } else {
        _timer?.cancel();
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  void _resendCode() async {
    if (_canResend && !_isResending) {
      setState(() {
        _isResending = true;
      });
      context.read<AuthCubit>().sendOtp(widget.phoneNumber);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _secondsRemaining.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthCodeSentSuccess) {
          widget.onCodeResent(state.verificationId, state.resendToken);

          if (_isResending) {
            _startTimer();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  l10n.otpMessage,
                  style: AppTextStyles.smallButton,
                ),
                backgroundColor: AppColors.secondary,
              ),
            );
          }
          setState(() {
            _isResending = false;
          });
        } else if (state is AuthError && _isResending) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message, style: AppTextStyles.smallButton),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _isResending = false;
          });
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            l10n.didNotReceiveCode,
            textAlign: TextAlign.center,
            style: AppTextStyles.textStyle14().copyWith(
              fontSize: 14.sp,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 4.h),
          ValueListenableBuilder<int>(
            valueListenable: _secondsRemaining,
            builder: (context, value, child) {
              if (value > 0) {
                return Text(
                  '${l10n.requestNewCode} in $value s',
                  style: AppTextStyles.textStyle14().copyWith(
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                );
              } else {
                return _isResending
                    ? SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: const AppLoading(),
                      )
                    : TextButton(
                        onPressed: _canResend ? _resendCode : null,
                        child: Text(
                          l10n.resendAgainButton,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.dialogButton.copyWith(
                            color: _canResend ? AppColors.primary : Colors.grey,
                            fontSize: 16.sp,
                          ),
                        ),
                      );
              }
            },
          ),
        ],
      ),
    );
  }
}
