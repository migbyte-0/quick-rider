import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:quickrider/features/auth/data/datasources/auth_datasources.dart'
    show AuthRemoteDataSource, AuthRemoteDataSourceImpl;
import 'package:quickrider/features/auth/domain/repository/auth_repository.dart';
import 'package:quickrider/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:quickrider/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:quickrider/features/payment/domain/usecases/set_default_credit_card_usecase.dart'
    show SetDefaultCreditCardUseCase;

// --- Core & Services ---
import '../../features/auth/data/repositories_impl/auth_repositories_impl.dart';
import '../../features/auth/domain/usecases/auth_usecases.dart'; // SendOtp, VerifyOtp
import '../../features/map/data/datasources/map_remote_data_source.dart';
import '../../features/map/data/datasources/map_remote_datasource_impl.dart';
import '../../features/map/data/repositories_impl/map_repositories_impl.dart'
    show MapRepositoryImpl;
import '../../features/map/domain/domain_exports.dart';
import '../../features/map/domain/usecases/get_available_car_types.dart'
    show GetAvailableCarTypesUseCase;
import '../../features/map/domain/usecases/listen_to_trip_updates.dart';
import '../../features/map/domain/usecases/request_trip.dart';
import '../../features/map/presentation/presentation_exports.dart';
import '../../features/payment/data/datasources/payment_remote_data_source.dart';
import '../../features/payment/data/datasources/payment_remote_datasouce_impl.dart';
import '../../features/payment/data/repositories/payment_repository_impl.dart';
import '../../features/payment/domain/repository/payment_repository.dart';
import '../../features/payment/domain/usecases/get_credit_cards_usecase.dart';
import '../../features/payment/domain/usecases/remove_credit_card_usecase.dart';
import '../../features/payment/domain/usecases/save_credit_card_usecase.dart';
import '../../features/payment/presentation/cubits/payment_cubit.dart';
import '../../features/profile/data/datasources/profile_datasource_impl.dart';
import '../../features/profile/data/datasources/profile_datasources.dart'; // ProfileRemoteDataSource
import '../../features/profile/data/repositories/profile_repositories.dart'; // ProfileRepositoryImpl
import '../../features/profile/domain/repository/profile_repository.dart';
import '../../features/profile/presentation/presentation_exports.dart'; // ProfileSetupCubit, ProfileCubit
import '../../services/logger_services.dart';
import '../../services/onboarding_services.dart';
import '../network/dio_client.dart';
import '../services/secure_storage.dart';
import '../language/cubit/language_cubit.dart'; // Import LanguageCubit

// --- Splash Feature ---
import '../../features/splash/presentation/cubit/splash_cubit.dart';

// --- Profile Feature ---
import '../../features/profile/data/datasources/profile_local_data_source.dart';
import '../../features/profile/domain/usecases/save_profile_usecase.dart';
import '../../features/profile/domain/usecases/get_profile_usecase.dart';

// --- External Dependencies ---
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http; // <--- Import http client

// lib/core/di/di.dart

import 'package:location/location.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // <--- NEW IMPORT

// --- Core & Services ---
import '../network/network_info.dart'; // <--- Ensure NetworkInfo abstract class is imported
// ... other imports for features (auth, map, payment, profile, splash)

final sl = GetIt.instance;

Future<void> init() async {
  // --- Core & Services ---
  sl.registerLazySingleton(() => AppLogger());
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<SecureStorage>(() => const SecureStorage());
  sl.registerLazySingleton(
    () => DioClient(dio: sl(), log: sl(), storage: sl()),
  );
  sl.registerSingletonAsync<OnboardingService>(
    () async => await OnboardingService.newInstance(),
  );

  // --- External Dependencies ---
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Register Connectivity_plus
  sl.registerLazySingleton(() => Connectivity()); // <--- REGISTER CONNECTIVITY

  // Register NetworkInfoImpl
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      sl(), // Provides Connectivity instance
      logger: sl(), // Provides AppLogger instance
    ),
  );

  // Register the Location service from the 'location' package
  sl.registerLazySingleton(() => Location());

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
      localDataSource: sl(),
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
      localDataSource: sl(),
      logger: sl(),
    ),
  );
  sl.registerFactory(() => LanguageCubit());
  sl.registerFactory(() => PaymentCubit(
      removeCreditCardUseCase: sl(),
      setDefaultCreditCardUseCase: sl(),
      getCreditCardsUseCase: sl(),
      saveCreditCardUseCase: sl(),
      logger: sl()));

  sl.registerFactory(() => MapsCubit(
        searchPlacesUseCase: sl(),
        getNearbyDriversUseCase: sl(),
        getAvailableCarTypesUseCase: sl(),
        requestTripUseCase: sl(),
        listenToTripUpdatesUseCase: sl(),
        logger: sl(),
      ));

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
    () => ProfileLocalDataSourceImpl(sharedPreferences: sl(), logger: sl()),
  );

  // -- Payment Feature Dependencies --
  sl.registerLazySingleton(() => SaveCreditCardUseCase(sl()));
  sl.registerLazySingleton(() => RemoveCreditCardUseCase(sl()));
  sl.registerLazySingleton(() => SetDefaultCreditCardUseCase(sl()));
  sl.registerLazySingleton(() => GetCreditCardsUseCase(sl()));
  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(logger: sl()),
  );

  // --- Map Feature Dependencies ---
  // Use Cases
  sl.registerLazySingleton(() => SearchPlacesUseCase(sl()));
  sl.registerLazySingleton(() => GetNearbyDriversUseCase(sl()));
  sl.registerLazySingleton(() => GetAvailableCarTypesUseCase(sl()));
  sl.registerLazySingleton(() => RequestTripUseCase(sl()));
  sl.registerLazySingleton(() => ListenToTripUpdatesUseCase(sl()));

  // Repository
  sl.registerLazySingleton<MapRepository>(
    () => MapRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(), // <--- Correctly provided
      logger: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<MapRemoteDataSource>(
    () => MapRemoteDataSourceImpl(
      client: sl(),
      locationService: sl<Location>(),
      logger: sl(),
    ),
  );
}
