import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickrider/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:quickrider/features/profile/presentation/cubits/profile_state.dart';

import 'package:quickrider/features/profile/data/datasources/profile_local_data_source.dart';

import 'package:quickrider/services/logger_services.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase _getProfileUseCase;
  final ProfileLocalDataSource _localDataSource;
  final AppLogger _logger;

  ProfileCubit({
    required GetProfileUseCase getProfileUseCase,
    required ProfileLocalDataSource localDataSource,
    required AppLogger logger,
  }) : _getProfileUseCase = getProfileUseCase,
       _localDataSource = localDataSource,
       _logger = logger,
       super(ProfileInitial());

  Future<void> fetchProfile() async {
    _logger.i('ProfileCubit: Fetching profile...');
    emit(ProfileLoading());

    final userId = await _localDataSource.getCachedUserId();
    if (userId == null || userId.isEmpty) {
      _logger.w('ProfileCubit: User ID not found in cache. Emitting error.');
      emit(const ProfileError('User ID not found. Please log in again.'));
      return;
    }
    _logger.d('ProfileCubit: Retrieved userId from cache: $userId');

    final result = await _getProfileUseCase(userId);

    result.fold(
      (failure) {
        _logger.e(
          'ProfileCubit: Failed to fetch profile for $userId - ${failure.message}',
        );
        emit(ProfileError(failure.message));
      },
      (user) {
        if (user != null) {
          _logger.i('ProfileCubit: Profile loaded for user ID: ${user.id}');
          emit(ProfileLoaded(user));
        } else {
          _logger.e('ProfileCubit: User profile data is null for ID: $userId');
          emit(const ProfileError('User profile data is missing.'));
        }
      },
    );
  }
}
