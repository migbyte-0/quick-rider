import 'package:dartz/dartz.dart';
import 'package:quickrider/core/errors/exceptions.dart';
import 'package:quickrider/core/errors/failures.dart';
import 'package:quickrider/features/payment/data/datasources/payment_remote_data_source.dart';

import '../../domain/repository/payment_repository.dart';

import 'package:quickrider/features/payment/data/models/credit_card_model.dart';
import 'package:quickrider/features/payment/domain/entities/credit_card_entity.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Unit>> saveCreditCard(
      CreditCardEntity cardEntity) async {
    try {
      final cardModel = CreditCardModel.fromEntity(cardEntity);
      await remoteDataSource.saveCreditCard(cardModel);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeCreditCard(String cardId) async {
    try {
      await remoteDataSource.removeCreditCard(cardId);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<CreditCardEntity>>> getCreditCards() async {
    try {
      final List<CreditCardModel> cardModels =
          await remoteDataSource.getCreditCards();
      final List<CreditCardEntity> cardEntities =
          cardModels.map((model) => model.toEntity()).toList();
      return Right(cardEntities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> setDefaultCreditCard(String cardId) async {
    try {
      await remoteDataSource.setDefaultCreditCard(cardId);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
