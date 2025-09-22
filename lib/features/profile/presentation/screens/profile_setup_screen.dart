import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickrider/core/constants/constant_exports.dart';
import 'package:quickrider/core/shared/shared_exports.dart';
import 'package:quickrider/l10n/app_localizations.dart';

import '../cubits/profile_setup_cubit.dart';
import '../cubits/profile_setup_state.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _submitProfile() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileSetupCubit>().saveProfile(
        // userId and phoneNumber are now fetched internally by ProfileSetupCubit
        name: _nameController.text.trim(),
        city: _cityController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(l10n.profile, style: AppTextStyles.textStyle18()),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocListener<ProfileSetupCubit, ProfileSetupState>(
        listener: (context, state) {
          if (state is ProfileSetupSuccess) {
            // Navigate to the main app screen after successful profile setup
            // This is where it goes to '/home', which should contain ProfileScreen or a navigator to it.
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is ProfileSetupFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message, style: AppTextStyles.smallButton),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.enterName,
                    style: AppTextStyles.textStyle18().copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: l10n.userName,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 2.w,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.enterName;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    l10n.city,
                    style: AppTextStyles.textStyle18().copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      hintText: l10n.city,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 2.w,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.city;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 40.h),
                  BlocBuilder<ProfileSetupCubit, ProfileSetupState>(
                    builder: (context, state) {
                      final isLoading = state is ProfileSetupLoading;
                      return CustomButton(
                        text: isLoading ? l10n.submit : l10n.confirm,
                        onPressed: isLoading ? null : _submitProfile,
                        isLoading: isLoading,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
