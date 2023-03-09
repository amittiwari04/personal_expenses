import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transaction;
  final Function deleteTx;

  TransactionList(this.transaction,this.deleteTx);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: transaction.isEmpty
          ? LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                Text("No transaction added yet "),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height*0.05,
                // ),
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset("assets/images/waiting.png"),
                ),
              ],
            );
          })
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8,horizontal: 5),
                  child: ListTile(
                   leading: CircleAvatar(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: FittedBox(
                          child: Text(
                            '\$${transaction[index].amount}',
                          ),
                        ),
                      ),
                      radius: 30,
                    ),
                    title: Text('${transaction[index].title}'),
                    subtitle: Text(
                        '${DateFormat().add_yMMMd().format(transaction[index].date)}'),
                    trailing: MediaQuery.of(context).size.width >360?
                     FlatButton.icon(
                      onPressed: (() => deleteTx(transaction[index].id)),
                       icon: Icon(Icons.delete,color: Colors.red,),
                        label: Text("Delete",style: TextStyle(color: Colors.red),)
                        )
                     :IconButton(
                      icon: Icon(Icons.delete,color: Colors.red,),
                      onPressed: (() => deleteTx(transaction[index].id)),
                    ),
                  ),
                );
              },
              itemCount: transaction.length,
            ),
    );
  }
}
