import 'package:quickrider/features/payment/data/models/credit_card_model.dart';

abstract class PaymentRemoteDataSource {
  Future<List<CreditCardModel>> getCreditCards();
  Future<void> saveCreditCard(CreditCardModel card);
  Future<void> removeCreditCard(String cardId);
  Future<void> setDefaultCreditCard(String cardId);
}
