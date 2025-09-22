import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:quickrider/features/auth/data/datasources/auth_datasources.dart'
    show AuthRemoteDataSource, AuthRemoteDataSourceImpl;
import 'package:quickrider/features/auth/domain/repository/auth_repository.dart';
import 'package:quickrider/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:quickrider/features/onboarding/presentation/cubit/onboarding_cubit.dart';

// --- Core & Services ---
import '../../features/auth/data/repositories_impl/auth_repositories_impl.dart';
import '../../features/auth/domain/usecases/auth_usecases.dart';
import '../../features/profile/data/datasources/profile_datasources.dart';
import '../../features/profile/data/repositories/profile_repositories.dart';
import '../../features/profile/domain/repository/profile_repository.dart';
import '../../features/profile/presentation/presentation_exports.dart';
import '../../services/logger_services.dart';
import '../../services/onboarding_services.dart';
import '../network/dio_client.dart';
import '../services/secure_storage.dart';

// --- Splash Feature ---
import '../../features/splash/presentation/cubit/splash_cubit.dart';

import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

// --- Core & Services ---

// --- Splash Feature ---

// --- Profile Feature ---
import '../../features/profile/data/datasources/profile_local_data_source.dart';
import '../../features/profile/domain/usecases/save_profile_usecase.dart';

// Keep this import here

// --- Core & Services ---

// --- Auth Feature Imports ---
import '../../features/auth/data/datasources/auth_datasources.dart';
// Assuming SendOtp and VerifyOtp are here

// --- Onboarding Feature Imports ---

// --- Splash Feature Imports ---

// --- Profile Feature Imports ---
import '../../features/profile/domain/usecases/get_profile_usecase.dart'; // NEW: For ProfileCubit
// NEW: The actual ProfileCubit

// --- Core & Services ---

// --- Auth Feature Imports ---
// Assuming SendOtp and VerifyOtp are here

// --- Onboarding Feature Imports ---

// --- Splash Feature Imports ---

// --- Profile Feature Imports ---

final sl = GetIt.instance;

Future<void> init() async {
  // --- Core & Services ---
  sl.registerLazySingleton(() => AppLogger()); // Logger is registered
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton<SecureStorage>(() => const SecureStorage());
  sl.registerLazySingleton(
    () => DioClient(dio: sl(), log: sl(), storage: sl()),
  );
  sl.registerSingletonAsync<OnboardingService>(
    () async => await OnboardingService.newInstance(),
  );

  // --- External Dependencies ---
  // Ensure SharedPreferences is initialized before anything tries to use it.
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // --- Features ---

  // -- Cubits (Presentation Layer) --
  sl.registerFactory(
    () => SplashCubit(onboardingService: sl(), secureStorage: sl()),
  );
  sl.registerFactory(() => OnboardingCubit(onboardingService: sl()));
  sl.registerFactory(
    () => AuthCubit(
      sendOtp: sl(),
      verifyOtp: sl(),
      secureStorage: sl(),
      localDataSource: sl(), // ProfileLocalDataSource injected here
      logger: sl(),
    ),
  );
  sl.registerFactory(
    () => ProfileSetupCubit(
      saveProfileUseCase: sl(),
      logger: sl(),
      profileLocalDataSource: sl(),
    ),
  );
  sl.registerFactory(
    () => ProfileCubit(
      getProfileUseCase: sl(),
      localDataSource: sl(), // ProfileLocalDataSource injected here
      logger: sl(),
    ),
  );

  // -- Auth Feature Dependencies --
  sl.registerLazySingleton(() => SendOtp(sl()));
  sl.registerLazySingleton(() => VerifyOtp(sl()));
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(logger: sl()),
  );

  // -- Profile Feature Dependencies --
  sl.registerLazySingleton(() => SaveProfileUseCase(sl()));
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSourceImpl(
      sharedPreferences: sl(),
      logger: sl(),
    ), // <<< Inject logger
  );
}
