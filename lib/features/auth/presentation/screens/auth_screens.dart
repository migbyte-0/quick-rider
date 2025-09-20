import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';

class AuthScreen extends StatelessWidget {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoggedInSuccess) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              bool showOtpField = state is AuthCodeSentSuccess;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      hintText: 'e.g., 0512345678',
                    ),
                    keyboardType: TextInputType.phone,
                    enabled: !showOtpField,
                  ),
                  const SizedBox(height: 12),

                  if (showOtpField)
                    TextField(
                      controller: _otpController,
                      decoration: const InputDecoration(
                        labelText: 'Verification Code',
                        hintText: 'Mock code is 123456',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  const SizedBox(height: 20),

                  if (!showOtpField)
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthCubit>().sendOtp(
                          _phoneController.text.trim(),
                        );
                      },
                      child: const Text('Send Code'),
                    )
                  else
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthCubit>().verifyOtp(
                          _otpController.text.trim(),
                        );
                      },
                      child: const Text('Verify & Sign In'),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
