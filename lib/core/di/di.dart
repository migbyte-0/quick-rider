import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:quickrider/features/auth/data/datasources/auth_datasources.dart'
    show AuthRemoteDataSource, AuthRemoteDataSourceImpl;
import 'package:quickrider/features/auth/domain/repository/auth_repository.dart';
import 'package:quickrider/features/auth/presentation/cubits/auth_cubit.dart';

// --- Core & Services ---
import '../../features/auth/data/repositories_impl/auth_repositories_impl.dart';
import '../../features/auth/domain/usecases/auth_usecases.dart';
import '../../services/onboarding_services.dart';
import '../network/dio_client.dart';
import '../services/secure_storage.dart';

// --- Splash Feature ---
import '../../features/splash/presentation/cubit/splash_cubit.dart';

// --- Auth Feature ---

// --- Profile Feature ---

// --- Map/Ride Feature ---
// Create a global instance of GetIt
final sl = GetIt.instance;

/// I initializes all the dependencies for the application.
Future<void> init() async {
  // --- Core & Services ---

  // External packages
  sl.registerLazySingleton(
    () => Logger(printer: PrettyPrinter(methodCount: 0)),
  );
  sl.registerLazySingleton(() => Dio());

  // Core services
  sl.registerLazySingleton<SecureStorage>(() => const SecureStorage());
  sl.registerLazySingleton(
    () => DioClient(dio: sl(), log: sl(), storage: sl()),
  );
  sl.registerSingletonAsync<OnboardingService>(
    () async => await OnboardingService.newInstance(),
  );

  // --- Features ---

  // -- Splash Feature --
  sl.registerFactory(
    () => SplashCubit(onboardingService: sl(), secureStorage: sl()),
  );

  // -- Auth Feature --
  // Factory for Cubits because they are tied to the UI lifecycle
  sl.registerFactory(
    () => AuthCubit(sendOtp: sl(), verifyOtp: sl(), secureStorage: sl()),
  );
  // Lazy Singleton for Use Cases, Repositories, and Data Sources
  sl.registerLazySingleton(() => SendOtp(sl()));
  sl.registerLazySingleton(() => VerifyOtp(sl()));
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  // -- Profile Feature --
  // sl.registerFactory(() => ProfileCubit(getProfile: sl()));
  // sl.registerLazySingleton(() => GetProfile(sl()));
  // sl.registerLazySingleton<ProfileRepository>(
  //   () => ProfileRepositoryImpl(remoteDataSource: sl()),
  // );
  // sl.registerLazySingleton<ProfileRemoteDataSource>(
  //   // I pass the configured DioClient's dio instance here
  //   () => ProfileRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  // );
  //
  // // -- Map/Ride Feature --
  // sl.registerFactory(() => MapCubit(getNearbyDrivers: sl()));
  // sl.registerLazySingleton(() => GetNearbyDrivers(sl()));
  // sl.registerLazySingleton<MapRepository>(
  //   () => MapRepositoryImpl(remoteDataSource: sl()),
  // );
  // sl.registerLazySingleton<MapRemoteDataSource>(
  //   // I pass the configured DioClient's dio instance here
  //   () => MapRemoteDataSourceImpl(dio: sl<DioClient>().dio),
  // );
}
