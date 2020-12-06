import 'package:flutter/material.dart';
import 'package:personalExpensesTracker/models/txns.dart';
import 'package:intl/intl.dart';

class TxnList extends StatelessWidget {
  final List<Txn> transactions;
  final Function deleteTx;

  TxnList(this.transactions, this.deleteTx);
  @override
  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return Column(
                children: [
                  Text(
                    'Spend some money, you miser!',
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/getrich.jpg',
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              );
            },
          )
        : ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                elevation: 1,
                margin: EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 5,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: FittedBox(
                        child: Text('₹${transactions[index].amount}'),
                      ),
                    ),
                  ),
                  title: Text(
                    transactions[index].title,
                    style: Theme.of(context).textTheme.title,
                  ),
                  subtitle: Text(
                    DateFormat.yMMMd().format(transactions[index].date),
                  ),
                  trailing: MediaQuery.of(context).size.width > 400
                      ? FlatButton.icon(
                          icon: Icon(Icons.delete),
                          label: Text('Delete'),
                          onPressed: () => deleteTx(transactions[index].id),
                          textColor: Theme.of(context).errorColor,
                        )
                      : IconButton(
                          icon: Icon(Icons.delete),
                          color: Theme.of(context).errorColor,
                          onPressed: () => deleteTx(transactions[index].id),
                        ),
                ),
              );
            },
            //ListView is a Column with a scroll view
            itemCount: transactions.length,
          );
  }
}
