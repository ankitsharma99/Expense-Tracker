import 'package:meta/meta.dart';

class Txn {
  final String id;
  final String title;
  final double amount;
  final DateTime
      date; // DateTime is a predefined class/object of a class that gets shipped with dart

  Txn(
      {@required this.id,
      @required this.title,
      @required this.amount,
      @required this.date});
} //Class for all the transactions
