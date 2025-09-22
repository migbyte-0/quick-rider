import 'package:shared_preferences/shared_preferences.dart';

import 'package:quickrider/services/logger_services.dart';

abstract class ProfileLocalDataSource {
  Future<void> cacheUserId(String userId);
  Future<String?> getCachedUserId();
  Future<void> cachePhoneNumber(String phoneNumber);
  Future<String?> getCachedPhoneNumber();
}

const CACHED_USER_ID = 'CACHED_USER_ID';
const CACHED_PHONE_NUMBER = 'CACHED_PHONE_NUMBER';

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final SharedPreferences sharedPreferences;
  final AppLogger logger;

  ProfileLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.logger,
  });

  @override
  Future<void> cacheUserId(String userId) async {
    logger.i('Attempting to cache userId: $userId');
    try {
      final success = await sharedPreferences.setString(CACHED_USER_ID, userId);
      if (success) {
        logger.i('Successfully cached userId: $userId');
      } else {
        logger.e('Failed to cache userId: $userId');
      }
    } catch (e, st) {
      logger.e('Error caching userId: $userId', error: e, stackTrace: st);
    }
  }

  @override
  Future<String?> getCachedUserId() async {
    logger.i('Attempting to retrieve cached userId...');
    try {
      final userId = sharedPreferences.getString(CACHED_USER_ID);
      if (userId != null && userId.isNotEmpty) {
        logger.i('Retrieved cached userId: $userId');
      } else {
        logger.w('No userId found in cache.');
      }
      return userId;
    } catch (e, st) {
      logger.e('Error retrieving cached userId', error: e, stackTrace: st);
      return null;
    }
  }

  //  Caching and retrieval for phone number
  @override
  Future<void> cachePhoneNumber(String phoneNumber) async {
    logger.i('Attempting to cache phoneNumber: $phoneNumber');
    try {
      final success = await sharedPreferences.setString(
        CACHED_PHONE_NUMBER,
        phoneNumber,
      );
      if (success) {
        logger.i('Successfully cached phoneNumber: $phoneNumber');
      } else {
        logger.e('Failed to cache phoneNumber: $phoneNumber');
      }
    } catch (e, st) {
      logger.e(
        'Error caching phoneNumber: $phoneNumber',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<String?> getCachedPhoneNumber() async {
    logger.i('Attempting to retrieve cached phoneNumber...');
    try {
      final phoneNumber = sharedPreferences.getString(CACHED_PHONE_NUMBER);
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        logger.i('Retrieved cached phoneNumber: $phoneNumber');
      } else {
        logger.w('No phoneNumber found in cache.');
      }
      return phoneNumber;
    } catch (e, st) {
      logger.e('Error retrieving cached phoneNumber', error: e, stackTrace: st);
      return null;
    }
  }
}
