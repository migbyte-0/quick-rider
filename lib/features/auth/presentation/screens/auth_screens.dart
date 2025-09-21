import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickrider/core/constants/constant_exports.dart';
import 'package:quickrider/core/shared/shared_exports.dart';
import '../../../../core/util/validators.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import 'otp_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthCodeSentSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OTPScreen(
                  phoneNumber: _phoneController.text.trim(),
                  verificationId: state.verificationId,
                  resendToken: state.resendToken,
                ),
              ),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: SvgPicture.asset(
                  AppAssets.coloredDecor,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        if (state is AuthLoading && state.isSendingOtp) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: Center(child: AppLoading()),
                          );
                        }

                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(AppAssets.logo),
                              const SizedBox(height: 40),
                              Card(
                                color: Colors.white,
                                elevation: 8.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    children: [
                                      CustomTextFormField(
                                        controller: _phoneController,
                                        hintText: l10n.phoneHintText,
                                        prefixIcon: Icons.phone_android,
                                        keyboardType: TextInputType.phone,
                                        enabled: true,
                                        validator: Validators.validatePhone,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        maxLength: 9,
                                      ),
                                      const SizedBox(height: 24),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 50,
                                        child: CustomButton(
                                          onPressed: () {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              context.read<AuthCubit>().sendOtp(
                                                _phoneController.text.trim(),
                                              );
                                            }
                                          },
                                          text: l10n.sendCodeButton,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
