import 'dart:isolate';
import '../parser/sms_parser_engine.dart';

class ParseSmsDraftUseCase {
  /// Parses SMS text on a parallel worker isolate, returning the full candidate and draft results.
  Future<SmsParserResult> call({
    required String sender,
    required String body,
    DateTime? timestamp,
  }) async {
    final date = timestamp ?? DateTime.now();

    return await Isolate.run(() {
      return SmsParserEngine.parseFull(
        sender: sender,
        body: body,
        date: date,
      );
    });
  }
}
