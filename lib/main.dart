import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/chart.dart';
import '../widgets/new_transaction.dart';
import 'models/transaction.dart';
import 'widgets/transactionlist.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown
  //   ]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _addTransaction(String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
    );
    setState(() {
      _userTransaction.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    _userTransaction.removeWhere((tx) => tx.id == id);
    setState(() {});
  }

  final List<Transaction> _userTransaction = [];

  Iterable<Transaction> get _recentTransaction {
    return _userTransaction.where(
      (tx) {
        return tx.date.isAfter(DateTime.now().subtract(
          Duration(days: 7),
        ));
      },
    );
  }

  void _StartAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: ((_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addTransaction),
          behavior: HitTestBehavior.opaque,
        );
      }),
    );
  }

  bool _showChart = false;


  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appbar = AppBar(
        title: Text('Personal Expenses'),
        actions: [
          IconButton(
            onPressed: () {
              _StartAddNewTransaction(context);
            },
            icon: Icon(Icons.add),
          )
        ],
  );

    final txListWidget = Container(
              height: (mediaQuery.size.height
               - appbar.preferredSize.height
               - mediaQuery.padding.top)*0.7,
              child: TransactionList(_userTransaction, _deleteTransaction),
              );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appbar,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            if(isLandscape)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Switch(value: _showChart, onChanged: (val){
                  setState(() {
                    _showChart=val;
                  });
                }),
              ],
            ),


            if(!isLandscape)
            Container(
              height: (mediaQuery.size.height
               - appbar.preferredSize.height
               - mediaQuery.padding.top)*0.3,
             child: Chart(_recentTransaction.toList()
             ),),
             if(!isLandscape) txListWidget,


             if(isLandscape)
            _showChart? Container(
              height: (mediaQuery.size.height
               - appbar.preferredSize.height
               - mediaQuery.padding.top)*0.7,
             child: Chart(_recentTransaction.toList()),
             ):
            txListWidget,

          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _StartAddNewTransaction(context);
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
