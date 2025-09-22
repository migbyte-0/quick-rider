import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickrider/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:quickrider/features/profile/domain/usecases/save_profile_usecase.dart';
import 'package:quickrider/services/logger_services.dart';

import '../../../auth/domain/entities/user_entites.dart';
import 'profile_setup_state.dart';

class ProfileSetupCubit extends Cubit<ProfileSetupState> {
  final SaveProfileUseCase saveProfileUseCase;
  final ProfileLocalDataSource profileLocalDataSource;
  final AppLogger _logger;

  ProfileSetupCubit({
    required this.saveProfileUseCase,
    required this.profileLocalDataSource,
    required AppLogger logger,
  }) : _logger = logger,
       super(ProfileSetupInitial());

  Future<void> saveProfile({required String name, required String city}) async {
    emit(ProfileSetupLoading());
    _logger.i('ProfileSetupCubit: Attempting to save profile...');

    String? currentUserId;
    String? currentPhoneNumber;

    try {
      currentUserId = await profileLocalDataSource.getCachedUserId();
      currentPhoneNumber = '523423444';
      _logger.w(
        'ProfileSetupCubit: Using a mocked phone number. Implement fetching real phoneNumber from cache.',
      );

      if (currentUserId == null || currentUserId.isEmpty) {
        _logger.e(
          'ProfileSetupCubit: Failed to get cached user ID before saving profile.',
        );
        emit(
          ProfileSetupFailure(
            message: 'User ID not found. Please log in again.',
          ),
        );
        return;
      }
      if (currentPhoneNumber.isEmpty) {
        _logger.e(
          'ProfileSetupCubit: Failed to get cached phone number before saving profile.',
        );
        emit(
          ProfileSetupFailure(
            message: 'Phone number not found. Please log in again.',
          ),
        );
        return;
      }

      _logger.d(
        'ProfileSetupCubit: Retrieved userId: $currentUserId and phoneNumber: $currentPhoneNumber from cache/mock.',
      );
    } catch (e, st) {
      _logger.e(
        'ProfileSetupCubit: Error retrieving userId/phoneNumber from cache: $e',
        error: e,
        stackTrace: st,
      );
      emit(
        ProfileSetupFailure(
          message: 'Failed to retrieve user data: ${e.toString()}',
        ),
      );
      return;
    }

    final user = UserEntity(
      id: currentUserId,
      phoneNumber: currentPhoneNumber,
      name: name,
      city: city,
    );

    _logger.d('ProfileSetupCubit: Constructed UserEntity: ');
    final result = await saveProfileUseCase(user);

    result.fold(
      (failure) {
        _logger.e(
          'ProfileSetupCubit: Failed to save profile - ${failure.message}',
        );
        emit(ProfileSetupFailure(message: failure.message));
      },
      (_) {
        _logger.i(
          'ProfileSetupCubit: Profile saved successfully for user ID: $currentUserId',
        );
        emit(ProfileSetupSuccess());
      },
    );
  }
}
