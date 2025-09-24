import '../../../../core/errors/exceptions.dart';
import '../../../../services/logger_services.dart';
import '../models/credit_card_model.dart';
import 'payment_remote_data_source.dart';

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final AppLogger logger;
  final List<CreditCardModel> _mockDbCards = [
    CreditCardModel(
        id: 'mock_card_1',
        cardNumber: '4111********1111',
        expiryDate: '12/25',
        cardHolderName: 'JOHN DOE',
        bankName: 'VISA BANK',
        cardType: 'Visa',
        isDefault: true),
    CreditCardModel(
        id: 'mock_card_2',
        cardNumber: '5111********1234',
        expiryDate: '10/24',
        cardHolderName: 'JANE SMITH',
        bankName: 'MASTERCARD BANK',
        cardType: 'MasterCard',
        isDefault: false),
  ];

  PaymentRemoteDataSourceImpl({required this.logger});

  @override
  Future<void> saveCreditCard(CreditCardModel cardModel) async {
    logger.i('Simulating API call to save card...');
    await Future.delayed(const Duration(seconds: 1));

    final cleanedCardNumber = cardModel.cardNumber.replaceAll(' ', '');

    if (!cleanedCardNumber.startsWith('1234') &&
        !cleanedCardNumber.startsWith('4111') &&
        !cleanedCardNumber.startsWith('5111')) {
      logger.w(
          'Simulating failed save: Card not starting with 1234, 4111, or 5111. Card ID: ${cardModel.id}');
      throw ServerException(
          'Failed to save credit card. Only cards starting with 1234, 4111, or 5111 are accepted for this demo.');
    }

    final existingIndex =
        _mockDbCards.indexWhere((card) => card.id == cardModel.id);
    if (existingIndex != -1) {
      _mockDbCards[existingIndex] = cardModel;
      logger.i('Simulating successful update for card ID: ${cardModel.id}');
    } else {
      _mockDbCards.add(cardModel);
      logger.i('Simulating successful save for new card ID: ${cardModel.id}');
    }
  }

  @override
  Future<void> removeCreditCard(String cardId) async {
    logger.i('Simulating API call to remove card with ID: $cardId');
    await Future.delayed(const Duration(seconds: 1));

    final initialLength = _mockDbCards.length;
    _mockDbCards.removeWhere((card) => card.id == cardId);

    if (_mockDbCards.length == initialLength) {
      logger.w('Simulating removal failure: Card ID $cardId not found.');
      throw ServerException('Card with ID $cardId not found.');
    } else {
      logger.i('Simulating successful removal of card with ID: $cardId');
    }
  }

  @override
  Future<List<CreditCardModel>> getCreditCards() async {
    logger.i('Simulating API call to get saved credit cards...');
    await Future.delayed(const Duration(seconds: 1));

    return List.from(_mockDbCards);
  }

  @override
  Future<void> setDefaultCreditCard(String cardId) async {
    logger.i('Simulating API call to set card ID: $cardId as default...');
    await Future.delayed(const Duration(milliseconds: 700));

    final cardIndex = _mockDbCards.indexWhere((card) => card.id == cardId);

    if (cardIndex == -1) {
      logger.w('Simulating setDefault failure: Card ID $cardId not found.');
      throw ServerException(
          'Card with ID $cardId not found for setting as default.');
    }

    for (var i = 0; i < _mockDbCards.length; i++) {
      final currentCard = _mockDbCards[i];
      if (i == cardIndex) {
        _mockDbCards[i] = currentCard.copyWith(isDefault: true);
      } else {
        _mockDbCards[i] = currentCard.copyWith(isDefault: false);
      }
    }

    logger.i('Simulating successful set default for card ID: $cardId');
  }
}
