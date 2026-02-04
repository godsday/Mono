import 'package:mono/features/home/domain/repositories/home_repository.dart';
import 'package:mono/features/transaction/domain/entities/transaction_entity.dart';
import 'package:mono/models/top_category_model.dart';

class GetTopCategories {
  final HomeRepository homeRepository;

  GetTopCategories(this.homeRepository);

  List<TopCategory> getTopCategories(
      String type, List<TransactionEntity> transactions) {
    return homeRepository.getTopCategories(transactions, type);
  }
}
