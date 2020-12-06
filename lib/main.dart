import 'dart:ui';
import './widgets/chart.dart';
import 'package:flutter/material.dart';
import './widgets/txn_list.dart';
import './widgets/new_txn.dart';
import './models/txns.dart';

void main() {
  runApp(ExpenseApp());
}

class ExpenseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
          primarySwatch: Colors.cyan,
          accentColor: Colors.lightGreenAccent,
          errorColor: Colors.indigo,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.blue,
                ),
              ),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                    color: Colors.black,
                    fontFamily: 'OpenSans',
                    fontSize: 25,
                    fontWeight: FontWeight.w300,
                  ),
                ),
          )),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ///This variable will hold a list of txns
  final List<Txn> _userTransactions = [];

//For puuting as an argument in the chart constructor at line number 114
  List<Txn> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  bool _showChart = false;
  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Txn(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTxn(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = (mediaQuery.orientation == Orientation.landscape);
    final appBar = AppBar(
      elevation: 0.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Expense',
                style: TextStyle(fontFamily: 'Open Sans'),
              ),
              Text(
                ' Tracker',
                style: TextStyle(
                    fontFamily: 'Open Sans', fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
    );
    final txList = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7, //height of appBar gets deducted from the transaction list (i. e Full height - appBar height)
      child: TxnList(_userTransactions, _deleteTransaction),
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Show Chart'),
                  Switch(
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    },
                  ),
                ],
              ),
            if (!isLandscape)
              Container(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.3, //height of appBar gets deducted from the transaction list (i. e Full height - appBar height)
                child: Chart(_recentTransactions),
              ),
            if (!isLandscape) txList,
            if (isLandscape)
              _showChart
                  ? Container(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.7, //height of appBar gets deducted from the transaction list (i. e Full height - appBar height)
                      child: Chart(_recentTransactions),
                    )
                  : txList
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        hoverColor: Colors.black38,
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
        backgroundColor: Colors.white,
        elevation: 5.0,
      ),
    );
  }
}
