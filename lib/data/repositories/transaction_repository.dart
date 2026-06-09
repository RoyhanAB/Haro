import '../../domain/models/transaction.dart';
import '../local/local_storage_service.dart';

class TransactionRepository {
  TransactionRepository(this._storage);

  final LocalStorageService _storage;

  Future<List<Transaction>> getTransactions() => _storage.getTransactions();

  Future<void> saveTransactions(List<Transaction> transactions) =>
      _storage.saveTransactions(transactions);
}
