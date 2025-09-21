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
import '../../services/logger_services.dart';
import '../../services/onboarding_services.dart';
import '../network/dio_client.dart';
import '../services/secure_storage.dart';

// --- Splash Feature ---
import '../../features/splash/presentation/cubit/splash_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // --- Core & Services ---
  sl.registerLazySingleton(() => AppLogger());
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton<SecureStorage>(() => const SecureStorage());
  sl.registerLazySingleton(
    () => DioClient(dio: sl(), log: sl(), storage: sl()),
  );
  sl.registerSingletonAsync<OnboardingService>(
    () async => await OnboardingService.newInstance(),
  );

  // --- Features ---

  // -- Cubits --
  sl.registerFactory(
    () => SplashCubit(onboardingService: sl(), secureStorage: sl()),
  );
  sl.registerFactory(() => OnboardingCubit(onboardingService: sl()));
  sl.registerFactory(
    () => AuthCubit(sendOtp: sl(), verifyOtp: sl(), secureStorage: sl()),
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
}
